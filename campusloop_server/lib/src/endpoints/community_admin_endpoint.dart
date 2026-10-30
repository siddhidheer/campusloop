import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/rbac_service.dart';
import '../services/spam_moderation_service.dart';

/// Endpoint for community permission delegation, administrator search,
/// and spam keyword rule management.
class CommunityAdminEndpoint extends Endpoint {
  /// Checks whether a profile is an administrator.
  Future<bool> isAdministrator(Session session, int profileId) async {
    return await RbacService.isAdmin(session, profileId);
  }

  /// Checks whether a profile has permission to create communities.
  Future<bool> canCreateCommunity(Session session, int profileId) async {
    return await RbacService.canCreateCommunity(session, profileId);
  }

  /// Searches for an existing registered user by their verified email address.
  /// Accessible only to administrators.
  Future<StudentProfile?> searchUserByEmail(
    Session session,
    int adminProfileId,
    String email,
  ) async {
    final isAdmin = await RbacService.isAdmin(session, adminProfileId);
    if (!isAdmin) {
      throw Exception(
        'Access denied: Only CampusLoop administrators can search users for permission delegation.',
      );
    }

    final cleanEmail = email.trim().toLowerCase();
    final results = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );

    if (results.isEmpty) return null;
    return results.first;
  }

  /// Grants community creation permission to a registered user.
  /// Immediately recorded in audit log.
  Future<bool> grantPermission(
    Session session,
    int adminProfileId,
    String targetEmail, {
    String? reason,
  }) async {
    return await RbacService.grantCommunityCreationPermission(
      session,
      adminProfileId: adminProfileId,
      targetEmail: targetEmail,
      reason: reason,
    );
  }

  /// Revokes previously granted community creation permission.
  /// Cannot revoke initial administrators.
  Future<bool> revokePermission(
    Session session,
    int adminProfileId,
    String targetEmail, {
    String? reason,
  }) async {
    return await RbacService.revokeCommunityCreationPermission(
      session,
      adminProfileId: adminProfileId,
      targetEmail: targetEmail,
      reason: reason,
    );
  }

  /// Lists all users who currently hold community creation permissions.
  Future<List<StudentProfile>> listAuthorizedUsers(
    Session session,
    int adminProfileId,
  ) async {
    final isAdmin = await RbacService.isAdmin(session, adminProfileId);
    if (!isAdmin) {
      throw Exception('Access denied: Administrator privileges required.');
    }

    // 1. Initial Admins
    final profiles = <StudentProfile>[];
    for (final email in RbacService.initialAdminEmails) {
      final p = await StudentProfile.db.find(
        session,
        where: (t) => t.email.equals(email.toLowerCase()),
      );
      if (p.isNotEmpty) {
        profiles.add(p.first);
      }
    }

    // 2. Additional delegated users
    final delegated = await StudentProfile.db.find(
      session,
      where: (t) =>
          t.canCreateCommunity.equals(true) | t.role.equals('admin') | t.role.equals('community_creator'),
    );

    for (final d in delegated) {
      if (!profiles.any((p) => p.email.toLowerCase() == d.email.toLowerCase())) {
        profiles.add(d);
      }
    }

    return profiles;
  }

  /// Returns immutable audit logs of permission changes.
  Future<List<PermissionAuditLog>> getAuditLogs(
    Session session,
    int adminProfileId, {
    int limit = 50,
  }) async {
    final isAdmin = await RbacService.isAdmin(session, adminProfileId);
    if (!isAdmin) {
      throw Exception('Access denied: Administrator privileges required.');
    }

    return await PermissionAuditLog.db.find(
      session,
      limit: limit,
      orderBy: (t) => t.timestamp.desc(),
    );
  }

  /// Lists configurable spam rules.
  Future<List<SpamKeywordRule>> getSpamRules(
    Session session,
    int adminProfileId,
  ) async {
    final isAdmin = await RbacService.isAdmin(session, adminProfileId);
    if (!isAdmin) {
      throw Exception('Access denied: Administrator privileges required.');
    }

    await SpamModerationService.ensureDefaultRules(session);
    return await SpamKeywordRule.db.find(
      session,
      orderBy: (t) => t.category,
    );
  }

  /// Adds a new spam keyword / pattern rule.
  Future<SpamKeywordRule> addSpamRule(
    Session session,
    int adminProfileId,
    String pattern,
    String category,
  ) async {
    final isAdmin = await RbacService.isAdmin(session, adminProfileId);
    if (!isAdmin) {
      throw Exception('Access denied: Administrator privileges required.');
    }

    final cleanPattern = pattern.trim().toLowerCase();
    if (cleanPattern.isEmpty) {
      throw Exception('Pattern cannot be empty.');
    }

    final rule = SpamKeywordRule(
      pattern: cleanPattern,
      category: category.trim().isNotEmpty ? category.trim() : 'commercial_promotion',
      severity: 'block',
      isEnabled: true,
      createdAt: DateTime.now(),
    );

    return await SpamKeywordRule.db.insertRow(session, rule);
  }

  /// Toggles an existing spam rule on or off.
  Future<bool> toggleSpamRule(
    Session session,
    int adminProfileId,
    int ruleId,
    bool isEnabled,
  ) async {
    final isAdmin = await RbacService.isAdmin(session, adminProfileId);
    if (!isAdmin) {
      throw Exception('Access denied: Administrator privileges required.');
    }

    final rule = await SpamKeywordRule.db.findById(session, ruleId);
    if (rule == null) {
      throw Exception('Spam rule not found.');
    }

    rule.isEnabled = isEnabled;
    await SpamKeywordRule.db.updateRow(session, rule);
    return true;
  }

  /// Retrieves moderation logs of blocked / flagged messages.
  Future<List<ModerationLog>> getModerationLogs(
    Session session,
    int adminProfileId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final isAdmin = await RbacService.isAdmin(session, adminProfileId);
    if (!isAdmin) {
      throw Exception('Access denied: Administrator privileges required.');
    }

    return await ModerationLog.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.timestamp.desc(),
    );
  }
}
