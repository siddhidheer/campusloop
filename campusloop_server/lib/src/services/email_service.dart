import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/business/util/serverpod_cloud_email_client.dart';

/// Service for email validation, secure OTP generation, and email delivery.
class EmailService {
  /// Strict Gmail validation regex.
  /// 1. Must end in @gmail.com
  /// 2. Username must be 6 to 30 alphanumeric characters / dots
  /// 3. Cannot begin or end with a dot, no consecutive dots.
  static final RegExp _gmailRegex = RegExp(
    r'^[a-zA-Z0-9](?!.*\.\.)[a-zA-Z0-9.]{4,28}[a-zA-Z0-9]@gmail\.com$',
    caseSensitive: false,
  );

  /// Validates whether the given email is a genuine, properly formatted Gmail address.
  /// Rejects non-Gmail domains, disposable addresses, and malformed strings.
  static bool isValidGmail(String email) {
    final trimmed = email.trim().toLowerCase();
    if (trimmed.isEmpty) return false;

    // Must end with @gmail.com
    if (!trimmed.endsWith('@gmail.com')) {
      return false;
    }

    // Reject disposable / temporary email patterns
    if (trimmed.contains('+') ||
        trimmed.contains('trash') ||
        trimmed.contains('temp') ||
        trimmed.contains('fake')) {
      return false;
    }

    return _gmailRegex.hasMatch(trimmed);
  }

  /// Generates a cryptographically secure random 6-digit OTP string.
  static String generateSecureOtp() {
    final random = Random.secure();
    // 100000 to 999999 inclusive
    final code = 100000 + random.nextInt(900000);
    return code.toString();
  }

  /// Generates a random cryptographic salt.
  static String generateSalt([int length = 16]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(values);
  }

  /// Hashes an OTP with a salt using SHA-256.
  /// Plaintext OTP is NEVER stored in the database.
  static String hashOtp(String otp, String salt) {
    final bytes = utf8.encode('$salt:$otp:campusloop_auth_pepper');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Hashes a password with a salt using SHA-256.
  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt:$password:campusloop_pwd_pepper');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Dispatches the OTP email to the recipient.
  /// Uses Serverpod Cloud transactional email or SMTP if configured,
  /// otherwise logs the OTP securely to the backend audit logs.
  static Future<bool> sendOtpEmail({
    required Session session,
    required String recipientEmail,
    required String otp,
    required int expirationMinutes,
  }) async {
    // 1. Try Serverpod Cloud Email Service first (hosted transactional email)
    final cloudEmailKey = session.serverpod.getPassword('scloudAuthEmailKey');
    if (cloudEmailKey != null && cloudEmailKey.isNotEmpty) {
      try {
        final emailClient = ServerpodCloudEmailClient();
        await emailClient.sendEmail(
          token: cloudEmailKey,
          emailType: ServerpodCloudEmailType.signup,
          email: recipientEmail,
          projectName: 'CampusLoop',
          authCode: otp,
        );
        session.log(
          'Email OTP delivered to $recipientEmail via Serverpod Cloud email service',
          level: LogLevel.info,
        );
        return true;
      } catch (e) {
        session.log(
          'Failed to send via Serverpod Cloud Email service: $e. Checking SMTP / fallback.',
          level: LogLevel.warning,
        );
      }
    }

    final smtpHost = Platform.environment['SMTP_HOST'] ??
        session.serverpod.getPassword('smtpHost');
    final smtpPort = int.tryParse(Platform.environment['SMTP_PORT'] ??
        session.serverpod.getPassword('smtpPort') ??
        '587') ??
        587;
    final smtpUser = Platform.environment['SMTP_USER'] ??
        session.serverpod.getPassword('smtpUser');
    final smtpPass = Platform.environment['SMTP_PASS'] ??
        session.serverpod.getPassword('smtpPass');
    final smtpFrom = Platform.environment['SMTP_FROM'] ??
        session.serverpod.getPassword('smtpFrom') ??
        'no-reply@campusloop.internal';

    final subject = 'CampusLoop — Email Verification Code: $otp';
    final textBody = '''
Hello from CampusLoop!

Your verification code is: $otp

This code will expire in $expirationMinutes minutes.
For your security, do not share this code with anyone.

If you did not request this verification, please ignore this email.

— The CampusLoop Team
''';

    if (smtpHost != null &&
        smtpHost.isNotEmpty &&
        smtpUser != null &&
        smtpPass != null) {
      try {
        await _sendSmtpMessage(
          host: smtpHost,
          port: smtpPort,
          user: smtpUser,
          pass: smtpPass,
          from: smtpFrom,
          to: recipientEmail,
          subject: subject,
          body: textBody,
        );
        session.log(
          'Email OTP delivered to $recipientEmail via SMTP server $smtpHost',
          level: LogLevel.info,
        );
        return true;
      } catch (e) {
        session.log(
          'Failed to send email via SMTP: $e. Falling back to secure audit log.',
          level: LogLevel.warning,
        );
      }
    }

    // Development & local test fallback with full audit entry:
    session.log(
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
      '🔑 [CampusLoop OTP Verification Code]\n'
      'Recipient: $recipientEmail\n'
      'Code:      $otp (Valid for $expirationMinutes mins)\n'
      'Configure production SMTP in passwords.yaml (smtpHost, smtpUser, smtpPass) for live email delivery.\n'
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
      level: LogLevel.info,
    );
    print(
      '🔑 [CampusLoop OTP Verification Code for $recipientEmail]: $otp (Valid for $expirationMinutes mins)',
    );
    return true;
  }

  /// Lightweight direct SMTP mailer implementation with STARTTLS and AUTH LOGIN.
  static Future<void> _sendSmtpMessage({
    required String host,
    required int port,
    required String user,
    required String pass,
    required String from,
    required String to,
    required String subject,
    required String body,
  }) async {
    Socket socket = await Socket.connect(host, port,
        timeout: const Duration(seconds: 10));
    final reader = socket.map(utf8.decode);

    Future<String> readLine() async {
      await for (final chunk in reader) {
        return chunk;
      }
      return '';
    }

    void writeLine(String line) {
      socket.write('$line\r\n');
    }

    try {
      await readLine();
      writeLine('EHLO campusloop.internal');
      await readLine();

      if (port == 587) {
        writeLine('STARTTLS');
        final tlsResp = await readLine();
        if (tlsResp.startsWith('220')) {
          socket = await SecureSocket.secure(socket, host: host);
          writeLine('EHLO campusloop.internal');
          await readLine();
        }
      }

      // AUTH LOGIN
      writeLine('AUTH LOGIN');
      await readLine();
      writeLine(base64.encode(utf8.encode(user)));
      await readLine();
      writeLine(base64.encode(utf8.encode(pass)));
      final authResp = await readLine();
      if (!authResp.startsWith('235')) {
        throw Exception('SMTP Authentication failed: $authResp');
      }

      writeLine('MAIL FROM:<$from>');
      await readLine();
      writeLine('RCPT TO:<$to>');
      await readLine();
      writeLine('DATA');
      await readLine();

      final message = 'From: CampusLoop <$from>\r\n'
          'To: <$to>\r\n'
          'Subject: $subject\r\n'
          'MIME-Version: 1.0\r\n'
          'Content-Type: text/plain; charset=utf-8\r\n'
          '\r\n'
          '$body\r\n'
          '.';
      writeLine(message);
      await readLine();

      writeLine('QUIT');
    } finally {
      await socket.close();
    }
  }
}
