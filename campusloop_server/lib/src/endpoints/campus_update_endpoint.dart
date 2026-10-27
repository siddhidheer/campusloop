import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for campus update/announcement operations.
///
/// Supports creating, listing, filtering, and managing campus-wide announcements.
/// Publishing restricted to authorized profiles.
class CampusUpdateEndpoint extends Endpoint {
  /// Create a new campus update/announcement.
  Future<CampusUpdate> createUpdate(
    Session session,
    CampusUpdate update,
  ) async {
    if (update.title.trim().isEmpty) {
      throw Exception('Update title is required.');
    }
    if (update.content.trim().isEmpty) {
      throw Exception('Update content is required.');
    }
    if (update.category.trim().isEmpty) {
      throw Exception('Update category is required.');
    }

    // Verify the author profile exists
    final author =
        await StudentProfile.db.findById(session, update.authorProfileId);
    if (author == null) {
      throw Exception('Author profile not found.');
    }

    final now = DateTime.now();
    update
      ..title = update.title.trim()
      ..content = update.content.trim()
      ..category = update.category.trim()
      ..createdAt = now
      ..updatedAt = now;

    // Auto-publish if isPublished is true
    if (update.isPublished) {
      update.publishedAt = now;
    }

    return await CampusUpdate.db.insertRow(session, update);
  }

  /// Get a single update by ID.
  Future<CampusUpdate?> getUpdate(Session session, int updateId) async {
    return await CampusUpdate.db.findById(session, updateId);
  }

  /// List published updates with optional category filter.
  Future<List<CampusUpdate>> listUpdates(
    Session session, {
    String? category,
    int limit = 20,
    int offset = 0,
  }) async {
    if (category != null && category.isNotEmpty) {
      return await CampusUpdate.db.find(
        session,
        where: (t) =>
            t.isPublished.equals(true) & t.category.equals(category),
        limit: limit,
        offset: offset,
        orderBy: (t) => t.publishedAt,
        orderDescending: true,
      );
    }

    return await CampusUpdate.db.find(
      session,
      where: (t) => t.isPublished.equals(true),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.publishedAt,
      orderDescending: true,
    );
  }

  /// Update an existing campus update.
  /// Only the original author can modify.
  Future<CampusUpdate> updateUpdate(
    Session session,
    CampusUpdate update,
    int requestingProfileId,
  ) async {
    if (update.id == null) {
      throw Exception('Update ID is required.');
    }

    final existing = await CampusUpdate.db.findById(session, update.id!);
    if (existing == null) {
      throw Exception('Update not found.');
    }

    if (existing.authorProfileId != requestingProfileId) {
      throw Exception('You are not authorized to edit this update.');
    }

    update.updatedAt = DateTime.now();
    if (update.isPublished && existing.publishedAt == null) {
      update.publishedAt = DateTime.now();
    }

    return await CampusUpdate.db.updateRow(session, update);
  }

  /// Delete a campus update (author only).
  Future<bool> deleteUpdate(
    Session session,
    int updateId,
    int requestingProfileId,
  ) async {
    final existing = await CampusUpdate.db.findById(session, updateId);
    if (existing == null) {
      throw Exception('Update not found.');
    }

    if (existing.authorProfileId != requestingProfileId) {
      throw Exception('You are not authorized to delete this update.');
    }

    final deleted = await CampusUpdate.db.deleteWhere(
      session,
      where: (t) => t.id.equals(updateId),
    );
    return deleted.isNotEmpty;
  }

  /// Get available update categories.
  Future<List<String>> getCategories(Session session) async {
    final updates = await CampusUpdate.db.find(
      session,
      where: (t) => t.isPublished.equals(true),
    );
    final categories = updates.map((u) => u.category).toSet().toList();
    categories.sort();
    return categories;
  }
}
