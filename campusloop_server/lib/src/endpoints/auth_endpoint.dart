import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/email_service.dart';
import '../services/rbac_service.dart';

/// Endpoint for verified Gmail registration, OTP verification, and login.
class AuthEndpoint extends Endpoint {
  /// Request a 6-digit OTP for email verification during registration.
  /// Enforces Gmail validation, single-use OTPs, and 60-second cooldowns.
  Future<AuthResponse> requestRegistrationOtp(
    Session session,
    String email,
  ) async {
    final cleanEmail = email.trim().toLowerCase();

    // 1. Strict Gmail Domain & Format Validation
    if (!EmailService.isValidGmail(cleanEmail)) {
      return AuthResponse(
        success: false,
        message:
            'Registration is restricted to genuine Gmail accounts (@gmail.com). Please provide a valid Gmail address.',
      );
    }

    // 2. Check if already registered and verified
    final existingProfile = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );
    if (existingProfile.isNotEmpty &&
        existingProfile.first.isEmailVerified == true) {
      return AuthResponse(
        success: false,
        message:
            'An account with this email is already registered and verified. Please sign in.',
      );
    }

    // 3. Check OTP cooldown (60 seconds)
    final existingOtps = await EmailVerificationOtp.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail),
      orderBy: (t) => t.createdAt.desc(),
      limit: 1,
    );

    final now = DateTime.now();
    if (existingOtps.isNotEmpty) {
      final lastOtp = existingOtps.first;
      final diff = now.difference(lastOtp.lastSentAt).inSeconds;
      if (diff < 60) {
        final waitSeconds = 60 - diff;
        return AuthResponse(
          success: false,
          message:
              'Please wait $waitSeconds seconds before requesting another verification code.',
        );
      }
    }

    // 4. Invalidate any previous unexpired OTPs for this email
    for (final oldOtp in existingOtps) {
      if (!oldOtp.isUsed) {
        oldOtp.isUsed = true;
        await EmailVerificationOtp.db.updateRow(session, oldOtp);
      }
    }

    // 5. Generate secure random OTP and salt
    final otp = EmailService.generateSecureOtp();
    final salt = EmailService.generateSalt();
    final otpHash = EmailService.hashOtp(otp, salt);
    const expirationMinutes = 5;
    final expiresAt = now.add(const Duration(minutes: expirationMinutes));

    // 6. Save hashed OTP in database (never plaintext)
    await EmailVerificationOtp.db.insertRow(
      session,
      EmailVerificationOtp(
        email: cleanEmail,
        otpHash: otpHash,
        salt: salt,
        attempts: 0,
        isUsed: false,
        createdAt: now,
        expiresAt: expiresAt,
        lastSentAt: now,
      ),
    );

    // 7. Deliver OTP via email
    await EmailService.sendOtpEmail(
      session: session,
      recipientEmail: cleanEmail,
      otp: otp,
      expirationMinutes: expirationMinutes,
    );

    final isLiveEmailActive =
        session.serverpod.getPassword('scloudAuthEmailKey') != null ||
        session.serverpod.getPassword('smtpHost') != null ||
        Platform.environment['SMTP_HOST'] != null;

    final feedbackMsg = isLiveEmailActive
        ? 'A 6-digit verification code has been sent to $cleanEmail. Valid for $expirationMinutes minutes.'
        : 'A 6-digit verification code has been sent to $cleanEmail. (Verification code: $otp)';

    return AuthResponse(
      success: true,
      message: feedbackMsg,
      email: cleanEmail,
      requiresOtp: true,
    );
  }

  /// Verifies the OTP code for an email address.
  Future<AuthResponse> verifyOtp(
    Session session,
    String email,
    String enteredOtp,
  ) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanOtp = enteredOtp.trim();

    if (!EmailService.isValidGmail(cleanEmail)) {
      return AuthResponse(
        success: false,
        message: 'Invalid Gmail address provided.',
      );
    }

    if (cleanOtp.length != 6 || int.tryParse(cleanOtp) == null) {
      return AuthResponse(
        success: false,
        message: 'Please enter a valid 6-digit verification code.',
      );
    }

    final otps = await EmailVerificationOtp.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail) & t.isUsed.equals(false),
      orderBy: (t) => t.createdAt.desc(),
      limit: 1,
    );

    if (otps.isEmpty) {
      return AuthResponse(
        success: false,
        message:
            'No active verification code found for this email. Please request a new code.',
      );
    }

    final otpRecord = otps.first;
    final now = DateTime.now();

    // Check expiration
    if (now.isAfter(otpRecord.expiresAt)) {
      otpRecord.isUsed = true;
      await EmailVerificationOtp.db.updateRow(session, otpRecord);
      return AuthResponse(
        success: false,
        message:
            'Verification code has expired. Please request a new one.',
      );
    }

    // Check attempt limits (brute-force protection: max 5 attempts)
    if (otpRecord.attempts >= 5) {
      otpRecord.isUsed = true;
      await EmailVerificationOtp.db.updateRow(session, otpRecord);
      return AuthResponse(
        success: false,
        message:
            'Too many incorrect attempts. For security, this verification code is invalidated. Please request a new code.',
      );
    }

    // Verify cryptographic hash
    final expectedHash = EmailService.hashOtp(cleanOtp, otpRecord.salt);
    if (expectedHash != otpRecord.otpHash) {
      otpRecord.attempts += 1;
      await EmailVerificationOtp.db.updateRow(session, otpRecord);
      final remaining = 5 - otpRecord.attempts;
      return AuthResponse(
        success: false,
        message:
            'Incorrect verification code. $remaining attempt(s) remaining.',
      );
    }

    // Mark OTP as used
    otpRecord.isUsed = true;
    await EmailVerificationOtp.db.updateRow(session, otpRecord);

    return AuthResponse(
      success: true,
      message: 'Email address verified successfully!',
      email: cleanEmail,
    );
  }

  /// Completes student registration after verified OTP check.
  /// Activates the account, hashes the password, and seeds initial roles.
  Future<AuthResponse> completeRegistration(
    Session session, {
    required String displayName,
    required String email,
    required String password,
    required String otp,
    String? department,
    int? year,
    String? bio,
    required List<String> studySubjects,
    required List<String> interests,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    // 1. Validate OTP first
    final otpVerification = await verifyOtp(session, cleanEmail, otp);
    if (!otpVerification.success) {
      return otpVerification;
    }

    if (password.length < 6) {
      return AuthResponse(
        success: false,
        message: 'Password must be at least 6 characters long.',
      );
    }

    final now = DateTime.now();

    // 2. Check if this email is an initial administrator
    final isAdmin = RbacService.isInitialAdmin(cleanEmail);
    final role = isAdmin ? 'admin' : 'student';
    final canCreate = isAdmin ? true : false;

    // 3. Hash password
    final salt = EmailService.generateSalt();
    final pwdHash = EmailService.hashPassword(password, salt);

    // Save or update UserAccount
    final existingAccounts = await UserAccount.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );
    if (existingAccounts.isEmpty) {
      await UserAccount.db.insertRow(
        session,
        UserAccount(
          email: cleanEmail,
          passwordHash: pwdHash,
          salt: salt,
          isEmailVerified: true,
          emailVerifiedAt: now,
          role: role,
          canCreateCommunity: canCreate,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      final acc = existingAccounts.first;
      acc
        ..passwordHash = pwdHash
        ..salt = salt
        ..isEmailVerified = true
        ..emailVerifiedAt = now
        ..role = (isAdmin ? 'admin' : acc.role)
        ..canCreateCommunity = (isAdmin ? true : acc.canCreateCommunity)
        ..updatedAt = now;
      await UserAccount.db.updateRow(session, acc);
    }

    // 4. Save or update StudentProfile
    final existingProfiles = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );

    StudentProfile profile;
    if (existingProfiles.isEmpty) {
      profile = await StudentProfile.db.insertRow(
        session,
        StudentProfile(
          displayName: displayName.trim(),
          email: cleanEmail,
          department: department?.trim(),
          year: year ?? 1,
          bio: bio?.trim(),
          studySubjects: studySubjects,
          interests: interests,
          role: role,
          canCreateCommunity: canCreate,
          isEmailVerified: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      profile = existingProfiles.first;
      profile
        ..displayName = displayName.trim()
        ..department = department?.trim() ?? profile.department
        ..year = year ?? profile.year
        ..bio = bio?.trim() ?? profile.bio
        ..studySubjects = studySubjects
        ..interests = interests
        ..role = (isAdmin ? 'admin' : profile.role ?? role)
        ..canCreateCommunity =
            (isAdmin ? true : profile.canCreateCommunity ?? canCreate)
        ..isEmailVerified = true
        ..updatedAt = now;
      profile = await StudentProfile.db.updateRow(session, profile);
    }

    // Ensure initial admin permissions are initialized
    profile = await RbacService.ensurePermissions(session, profile);

    return AuthResponse(
      success: true,
      message: 'Registration and verification successful! Welcome to CampusLoop.',
      profile: profile,
      email: cleanEmail,
      role: profile.role,
      canCreateCommunity: profile.canCreateCommunity,
    );
  }

  /// Secure sign in. Only registered and verified Gmail users can log in.
  Future<AuthResponse> login(
    Session session,
    String email,
    String password,
  ) async {
    final cleanEmail = email.trim().toLowerCase();

    if (!EmailService.isValidGmail(cleanEmail)) {
      return AuthResponse(
        success: false,
        message: 'Please enter a valid @gmail.com address.',
      );
    }

    // 1. Retrieve user account
    final accounts = await UserAccount.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );

    // 2. Retrieve student profile
    final profiles = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );

    if (profiles.isEmpty && accounts.isEmpty) {
      return AuthResponse(
        success: false,
        message:
            'No account found with this Gmail address. Please register as a New User.',
      );
    }

    // Check email verification status
    if (accounts.isNotEmpty && !accounts.first.isEmailVerified) {
      return AuthResponse(
        success: false,
        message:
            'Your email address has not been verified yet. Please complete OTP verification.',
        requiresOtp: true,
        email: cleanEmail,
      );
    }

    // Check password if account credentials exist
    if (accounts.isNotEmpty) {
      final acc = accounts.first;
      final computedHash = EmailService.hashPassword(password, acc.salt);
      if (computedHash != acc.passwordHash) {
        return AuthResponse(
          success: false,
          message: 'Incorrect password. Please try again.',
        );
      }
    }

    var profile = profiles.isNotEmpty ? profiles.first : null;
    if (profile == null && accounts.isNotEmpty) {
      // Reconstitute profile if missing
      final acc = accounts.first;
      profile = await StudentProfile.db.insertRow(
        session,
        StudentProfile(
          displayName: cleanEmail.split('@').first,
          email: cleanEmail,
          department: 'General Studies',
          year: 1,
          bio: 'CampusLoop student',
          studySubjects: [],
          interests: [],
          role: acc.role,
          canCreateCommunity: acc.canCreateCommunity,
          isEmailVerified: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    if (profile != null) {
      // Ensure permissions for initial admins
      profile = await RbacService.ensurePermissions(session, profile);
    }

    return AuthResponse(
      success: true,
      message: 'Sign in successful!',
      profile: profile,
      email: cleanEmail,
      role: profile?.role,
      canCreateCommunity: profile?.canCreateCommunity,
    );
  }
}
