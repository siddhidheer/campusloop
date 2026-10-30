import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/spam_moderation_service.dart';

/// Endpoint for community post operations.
///
/// Members can create posts, admins/creators can pin/delete.
/// Includes automated keyword-based spam and promotional content moderation.
class CommunityPostEndpoint extends Endpoint {
  /// Create a post in a community.
  /// Automatically runs spam detection and blocks unsolicited promotional content.
  Future<CommunityPost> createPost(
    Session session,
    CommunityPost post,
  ) async {
    if (post.title.trim().isEmpty) {
      throw Exception('Post title is required.');
    }
    if (post.content.trim().isEmpty) {
      throw Exception('Post content is required.');
    }

    // Verify community exists
    final community = await Community.db.findById(session, post.communityId);
    if (community == null) {
      throw Exception('Community not found.');
    }

    // Verify author profile exists
    final author =
        await StudentProfile.db.findById(session, post.authorProfileId);
    if (author == null) {
      throw Exception('Author profile not found.');
    }

    // Verify author is a member (General Discussion auto-joins verified students)
    final memberships = await CommunityMembership.db.find(
      session,
      where: (t) =>
          t.communityId.equals(post.communityId) &
          t.profileId.equals(post.authorProfileId),
    );
    if (memberships.isEmpty) {
      if (community.name == 'General Discussion') {
        final membership = CommunityMembership(
          communityId: post.communityId,
          profileId: post.authorProfileId,
          role: 'member',
          joinedAt: DateTime.now(),
        );
        await CommunityMembership.db.insertRow(session, membership);
      } else {
        throw Exception('You must be a community member to post.');
      }
    }

    // ── Backend Automated Spam Moderation ──
    final spamCheck = await SpamModerationService.checkContent(
      session,
      authorProfileId: post.authorProfileId,
      authorEmail: author.email,
      communityId: post.communityId,
      title: post.title,
      content: post.content,
    );

    if (spamCheck.isSpam) {
      throw Exception(
        spamCheck.friendlyFeedback ??
            'Your message could not be published because it appears to contain spam or promotional content. Please keep discussions relevant to the college community.',
      );
    }

    final now = DateTime.now();
    post
      ..title = post.title.trim()
      ..content = post.content.trim()
      ..isPinned = false
      ..createdAt = now
      ..updatedAt = now;

    return await CommunityPost.db.insertRow(session, post);
  }

  /// Inspect a message for spam without saving (for testing / pre-checks).
  Future<SpamCheckResult> checkMessageForSpam(
    Session session,
    String title,
    String content, {
    int profileId = 0,
    String email = 'test@gmail.com',
  }) async {
    return await SpamModerationService.checkContent(
      session,
      authorProfileId: profileId,
      authorEmail: email,
      communityId: 0,
      title: title,
      content: content,
    );
  }

  /// List posts for a community, pinned posts first.
  Future<List<CommunityPost>> listPosts(
    Session session,
    int communityId, {
    int limit = 30,
    int offset = 0,
  }) async {
    // Get pinned posts first
    final pinned = await CommunityPost.db.find(
      session,
      where: (t) =>
          t.communityId.equals(communityId) & t.isPinned.equals(true),
      orderBy: (t) => t.createdAt.desc(),
    );

    // Then unpinned posts
    final unpinned = await CommunityPost.db.find(
      session,
      where: (t) =>
          t.communityId.equals(communityId) & t.isPinned.equals(false),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt.desc(),
    );

    return [...pinned, ...unpinned];
  }

  /// Toggle pin status of a post (admin/creator only).
  Future<CommunityPost> togglePin(
    Session session,
    int postId,
    int requestingProfileId,
  ) async {
    final post = await CommunityPost.db.findById(session, postId);
    if (post == null) {
      throw Exception('Post not found.');
    }

    // Verify requester is community creator/admin
    final community = await Community.db.findById(session, post.communityId);
    if (community == null) {
      throw Exception('Community not found.');
    }

    if (community.creatorProfileId != requestingProfileId) {
      final memberships = await CommunityMembership.db.find(
        session,
        where: (t) =>
            t.communityId.equals(post.communityId) &
            t.profileId.equals(requestingProfileId) &
            t.role.equals('admin'),
      );
      if (memberships.isEmpty) {
        throw Exception('Only community admins can pin/unpin posts.');
      }
    }

    post
      ..isPinned = !post.isPinned
      ..updatedAt = DateTime.now();

    return await CommunityPost.db.updateRow(session, post);
  }

  /// Delete a post (author or community admin only).
  Future<bool> deletePost(
    Session session,
    int postId,
    int requestingProfileId,
  ) async {
    final post = await CommunityPost.db.findById(session, postId);
    if (post == null) {
      throw Exception('Post not found.');
    }

    // Author can delete their own post
    if (post.authorProfileId != requestingProfileId) {
      // Otherwise, must be community admin
      final community = await Community.db.findById(session, post.communityId);
      if (community == null ||
          community.creatorProfileId != requestingProfileId) {
        throw Exception('You are not authorized to delete this post.');
      }
    }

    final deleted = await CommunityPost.db.deleteWhere(
      session,
      where: (t) => t.id.equals(postId),
    );
    return deleted.isNotEmpty;
  }
}
