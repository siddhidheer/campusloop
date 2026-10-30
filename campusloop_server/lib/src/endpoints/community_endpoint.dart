import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/rbac_service.dart';

/// Endpoint for interest-based community operations.
///
/// Handles community CRUD, membership management, and discovery.
/// Community management restricted to creator.
class CommunityEndpoint extends Endpoint {
  /// Create a new community.
  Future<Community> createCommunity(
    Session session,
    Community community,
    int creatorProfileId,
  ) async {
    if (community.name.trim().isEmpty) {
      throw Exception('Community name is required.');
    }
    if (community.description.trim().isEmpty) {
      throw Exception('Community description is required.');
    }

    // Verify creator profile exists
    final creator = await StudentProfile.db.findById(session, creatorProfileId);
    if (creator == null) {
      throw Exception('Creator profile not found.');
    }

    // Server-side RBAC enforcement: verify creator has permission
    final hasPermission =
        await RbacService.canCreateCommunity(session, creatorProfileId);
    if (!hasPermission) {
      throw Exception(
        'Access denied: You do not have permission to create communities. Contact a CampusLoop administrator to request community creation access.',
      );
    }

    // Check for duplicate community name
    final existing = await Community.db.find(
      session,
      where: (t) => t.name.equals(community.name.trim()),
    );
    if (existing.isNotEmpty) {
      throw Exception('A community with this name already exists.');
    }

    final now = DateTime.now();
    community
      ..name = community.name.trim()
      ..description = community.description.trim()
      ..creatorProfileId = creatorProfileId
      ..memberCount = 1
      ..createdAt = now
      ..updatedAt = now;

    final created = await Community.db.insertRow(session, community);

    // Auto-add creator as a member with 'admin' role
    final membership = CommunityMembership(
      communityId: created.id!,
      profileId: creatorProfileId,
      role: 'admin',
      joinedAt: now,
    );
    await CommunityMembership.db.insertRow(session, membership);

    return created;
  }

  /// Get a community by ID.
  Future<Community?> getCommunity(Session session, int communityId) async {
    return await Community.db.findById(session, communityId);
  }

  /// Retrieves or initializes the shared "General Discussion" community.
  /// A common space where all registered CampusLoop users can discuss college-related topics.
  Future<Community> getOrCreateGeneralDiscussion(Session session) async {
    final existing = await Community.db.find(
      session,
      where: (t) => t.name.equals('General Discussion'),
    );
    if (existing.isNotEmpty) {
      return existing.first;
    }

    final now = DateTime.now();
    final generalCommunity = Community(
      name: 'General Discussion',
      description:
          'A common space where all registered CampusLoop users can discuss college-related topics, ask questions, share useful information, and interact with one another.',
      category: 'Academic',
      interests: [
        'Campus Life',
        'Academics',
        'Events',
        'Q&A',
        'Discussions',
      ],
      creatorProfileId: 1,
      memberCount: 1,
      createdAt: now,
      updatedAt: now,
    );
    return await Community.db.insertRow(session, generalCommunity);
  }

  /// List all communities with pagination.
  Future<List<Community>> listCommunities(
    Session session, {
    String? category,
    int limit = 20,
    int offset = 0,
  }) async {
    // Ensure the General Discussion community is always initialized
    await getOrCreateGeneralDiscussion(session);

    if (category != null && category.isNotEmpty) {
      return await Community.db.find(
        session,
        where: (t) => t.category.equals(category),
        limit: limit,
        offset: offset,
        orderBy: (t) => t.memberCount.desc(),
      );
    }

    return await Community.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.memberCount.desc(),
    );
  }

  /// Search communities by name.
  Future<List<Community>> searchCommunities(
    Session session,
    String query,
  ) async {
    if (query.trim().isEmpty) return [];

    final allCommunities = await Community.db.find(session);
    final lowerQuery = query.trim().toLowerCase();

    return allCommunities
        .where((c) =>
            c.name.toLowerCase().contains(lowerQuery) ||
            c.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Join a community.
  /// Prevents duplicate memberships on the server.
  Future<CommunityMembership> joinCommunity(
    Session session,
    int communityId,
    int profileId,
  ) async {
    final community = await Community.db.findById(session, communityId);
    if (community == null) {
      throw Exception('Community not found.');
    }

    // Check for existing membership
    final existing = await CommunityMembership.db.find(
      session,
      where: (t) =>
          t.communityId.equals(communityId) & t.profileId.equals(profileId),
    );
    if (existing.isNotEmpty) {
      throw Exception('You are already a member of this community.');
    }

    final membership = CommunityMembership(
      communityId: communityId,
      profileId: profileId,
      role: 'member',
      joinedAt: DateTime.now(),
    );
    final result =
        await CommunityMembership.db.insertRow(session, membership);

    // Update member count
    community
      ..memberCount = community.memberCount + 1
      ..updatedAt = DateTime.now();
    await Community.db.updateRow(session, community);

    return result;
  }

  /// Leave a community.
  /// Community creators cannot leave (they must delete).
  Future<bool> leaveCommunity(
    Session session,
    int communityId,
    int profileId,
  ) async {
    final community = await Community.db.findById(session, communityId);
    if (community == null) {
      throw Exception('Community not found.');
    }

    if (community.creatorProfileId == profileId) {
      throw Exception(
          'As the community creator, you cannot leave. Delete the community instead.');
    }

    final deleted = await CommunityMembership.db.deleteWhere(
      session,
      where: (t) =>
          t.communityId.equals(communityId) & t.profileId.equals(profileId),
    );

    if (deleted.isEmpty) {
      throw Exception('You are not a member of this community.');
    }

    // Update member count
    community
      ..memberCount = (community.memberCount - 1).clamp(0, 999999)
      ..updatedAt = DateTime.now();
    await Community.db.updateRow(session, community);

    return true;
  }

  /// Get members of a community.
  Future<List<CommunityMembership>> getMembers(
    Session session,
    int communityId,
  ) async {
    return await CommunityMembership.db.find(
      session,
      where: (t) => t.communityId.equals(communityId),
      orderBy: (t) => t.joinedAt,
    );
  }

  /// Get communities a profile is a member of.
  Future<List<Community>> getJoinedCommunities(
    Session session,
    int profileId,
  ) async {
    final memberships = await CommunityMembership.db.find(
      session,
      where: (t) => t.profileId.equals(profileId),
    );

    final communities = <Community>[];
    for (final membership in memberships) {
      final community =
          await Community.db.findById(session, membership.communityId);
      if (community != null) {
        communities.add(community);
      }
    }
    return communities;
  }

  /// Check if a profile is a member of a community.
  Future<bool> isMember(
    Session session,
    int communityId,
    int profileId,
  ) async {
    final memberships = await CommunityMembership.db.find(
      session,
      where: (t) =>
          t.communityId.equals(communityId) & t.profileId.equals(profileId),
    );
    return memberships.isNotEmpty;
  }

  /// Delete a community (creator only).
  Future<bool> deleteCommunity(
    Session session,
    int communityId,
    int requestingProfileId,
  ) async {
    final community = await Community.db.findById(session, communityId);
    if (community == null) {
      throw Exception('Community not found.');
    }

    if (community.creatorProfileId != requestingProfileId) {
      throw Exception('Only the community creator can delete it.');
    }

    // Remove all memberships first
    await CommunityMembership.db.deleteWhere(
      session,
      where: (t) => t.communityId.equals(communityId),
    );

    // Remove all posts
    await CommunityPost.db.deleteWhere(
      session,
      where: (t) => t.communityId.equals(communityId),
    );

    // Delete community
    await Community.db.deleteWhere(
      session,
      where: (t) => t.id.equals(communityId),
    );

    return true;
  }
}
