import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Role-Based Access Control (RBAC) service for CampusLoop.
///
/// Restricts community creation initially to the three designated administrators,
/// and manages delegated permissions with immutable audit logging.
class RbacService {
  /// The three initially authorized administrators.
  static const List<String> initialAdminEmails = [
    'siddhidheer1@gmail.com',
    'lavanyaupta136@gmail.com',
    'aggarwaldivyanshi80@gmail.com',
  ];

  /// Checks if an email is one of the initial administrators.
  static bool isInitialAdmin(String email) {
    final lower = email.trim().toLowerCase();
    return initialAdminEmails.any((admin) => admin.toLowerCase() == lower);
  }

  /// Ensures that any initial administrator has role 'admin' and canCreateCommunity=true.
  static Future<StudentProfile> ensurePermissions(
    Session session,
    StudentProfile profile,
  ) async {
    final lowerEmail = profile.email.trim().toLowerCase();
    if (isInitialAdmin(lowerEmail)) {
      if (profile.role != 'admin' || profile.canCreateCommunity != true) {
        profile
          ..role = 'admin'
          ..canCreateCommunity = true
          ..isEmailVerified = true
          ..updatedAt = DateTime.now();

        final updated = await StudentProfile.db.updateRow(session, profile);

        // Ensure active permission record
        final existingPerms = await CommunityCreationPermission.db.find(
          session,
          where: (t) => t.email.equals(lowerEmail),
        );
        if (existingPerms.isEmpty) {
          await CommunityCreationPermission.db.insertRow(
            session,
            CommunityCreationPermission(
              email: lowerEmail,
              profileId: updated.id!,
              grantedByEmail: 'system@campusloop.internal',
              grantedByProfileId: 0,
              grantedAt: DateTime.now(),
              isActive: true,
            ),
          );
        }
        return updated;
      }
    }
    return profile;
  }

  /// Verifies if a user is an administrator.
  static Future<bool> isAdmin(Session session, int profileId) async {
    final profile = await StudentProfile.db.findById(session, profileId);
    if (profile == null) return false;

    if (isInitialAdmin(profile.email)) return true;
    return profile.role == 'admin';
  }

  /// Verifies if a user has permission to create communities.
  /// Server-side validation — cannot be bypassed by frontend checks.
  static Future<bool> canCreateCommunity(Session session, int profileId) async {
    final profile = await StudentProfile.db.findById(session, profileId);
    if (profile == null) return false;

    final lower = profile.email.trim().toLowerCase();
    if (isInitialAdmin(lower)) return true;
    if (profile.role == 'admin') return true;
    if (profile.canCreateCommunity == true) return true;

    // Check active delegated permission table
    final perms = await CommunityCreationPermission.db.find(
      session,
      where: (t) => t.profileId.equals(profileId) & t.isActive.equals(true),
    );
    return perms.isNotEmpty;
  }

  /// Grants community creation permission to a registered, verified user.
  /// Callable ONLY by authorized administrators.
  static Future<bool> grantCommunityCreationPermission(
    Session session, {
    required int adminProfileId,
    required String targetEmail,
    String? reason,
  }) async {
    final requestingAdmin =
        await StudentProfile.db.findById(session, adminProfileId);
    if (requestingAdmin == null ||
        !await isAdmin(session, adminProfileId)) {
      throw Exception(
        'Access denied: Only CampusLoop administrators can grant community creation permissions.',
      );
    }

    final lowerTarget = targetEmail.trim().toLowerCase();

    // Prevent ordinary self-granting
    if (requestingAdmin.email.toLowerCase() == lowerTarget &&
        !isInitialAdmin(requestingAdmin.email)) {
      throw Exception('Self-escalation of privileges is strictly prohibited.');
    }

    // Find target profile
    final targets = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(lowerTarget),
    );
    if (targets.isEmpty) {
      throw Exception(
        'User with email $targetEmail not found. User must register on CampusLoop first.',
      );
    }

    final target = targets.first;

    // Update target profile
    target
      ..canCreateCommunity = true
      ..role = (target.role == 'admin' ? 'admin' : 'community_creator')
      ..updatedAt = DateTime.now();
    await StudentProfile.db.updateRow(session, target);

    // Update or insert permission record
    final perms = await CommunityCreationPermission.db.find(
      session,
      where: (t) => t.email.equals(lowerTarget),
    );
    final now = DateTime.now();

    if (perms.isEmpty) {
      await CommunityCreationPermission.db.insertRow(
        session,
        CommunityCreationPermission(
          email: lowerTarget,
          profileId: target.id!,
          grantedByEmail: requestingAdmin.email,
          grantedByProfileId: requestingAdmin.id!,
          grantedAt: now,
          isActive: true,
        ),
      );
    } else {
      final p = perms.first;
      p
        ..isActive = true
        ..grantedAt = now
        ..revokedAt = null
        ..grantedByEmail = requestingAdmin.email
        ..grantedByProfileId = requestingAdmin.id!;
      await CommunityCreationPermission.db.updateRow(session, p);
    }

    // Record in audit log
    await PermissionAuditLog.db.insertRow(
      session,
      PermissionAuditLog(
        action: 'GRANT',
        adminEmail: requestingAdmin.email,
        adminProfileId: requestingAdmin.id!,
        targetEmail: lowerTarget,
        targetProfileId: target.id!,
        reason: reason ?? 'Community creation access delegated by administrator.',
        timestamp: now,
      ),
    );

    return true;
  }

  /// Revokes community creation permission.
  /// Callable ONLY by authorized administrators.
  static Future<bool> revokeCommunityCreationPermission(
    Session session, {
    required int adminProfileId,
    required String targetEmail,
    String? reason,
  }) async {
    final requestingAdmin =
        await StudentProfile.db.findById(session, adminProfileId);
    if (requestingAdmin == null ||
        !await isAdmin(session, adminProfileId)) {
      throw Exception(
        'Access denied: Only CampusLoop administrators can revoke community creation permissions.',
      );
    }

    final lowerTarget = targetEmail.trim().toLowerCase();

    // The three initial administrators cannot be revoked
    if (isInitialAdmin(lowerTarget)) {
      throw Exception(
        'Cannot revoke community creation permissions from initial platform administrators.',
      );
    }

    final targets = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(lowerTarget),
    );
    if (targets.isEmpty) {
      throw Exception('User with email $targetEmail not found.');
    }

    final target = targets.first;

    // Update target profile
    target
      ..canCreateCommunity = false
      ..role = (target.role == 'admin' ? 'admin' : 'student')
      ..updatedAt = DateTime.now();
    await StudentProfile.db.updateRow(session, target);

    // Deactivate permission record
    final perms = await CommunityCreationPermission.db.find(
      session,
      where: (t) => t.email.equals(lowerTarget),
    );
    final now = DateTime.now();
    for (final p in perms) {
      p
        ..isActive = false
        ..revokedAt = now;
      await CommunityCreationPermission.db.updateRow(session, p);
    }

    // Record in audit log
    await PermissionAuditLog.db.insertRow(
      session,
      PermissionAuditLog(
        action: 'REVOKE',
        adminEmail: requestingAdmin.email,
        adminProfileId: requestingAdmin.id!,
        targetEmail: lowerTarget,
        targetProfileId: target.id!,
        reason: reason ?? 'Community creation access revoked by administrator.',
        timestamp: now,
      ),
    );

    return true;
  }
}
