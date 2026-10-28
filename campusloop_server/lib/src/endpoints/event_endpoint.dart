import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for campus event operations.
///
/// Handles event creation, retrieval, filtering, search, and management.
/// Event creation/editing requires ownership verification.
class EventEndpoint extends Endpoint {
  /// Create a new campus event.
  Future<CampusEvent> createEvent(
    Session session,
    CampusEvent event,
  ) async {
    // Validate required fields
    if (event.title.trim().isEmpty) {
      throw Exception('Event title is required.');
    }
    if (event.description.trim().isEmpty) {
      throw Exception('Event description is required.');
    }
    if (event.venue.trim().isEmpty) {
      throw Exception('Event venue is required.');
    }
    if (event.category.trim().isEmpty) {
      throw Exception('Event category is required.');
    }

    // Verify the organizer profile exists
    final organizer = await StudentProfile.db.findById(
      session,
      event.organizerProfileId,
    );
    if (organizer == null) {
      throw Exception('Organizer profile not found.');
    }

    final now = DateTime.now();
    event
      ..title = event.title.trim()
      ..description = event.description.trim()
      ..venue = event.venue.trim()
      ..organizer = organizer.displayName
      ..createdAt = now
      ..updatedAt = now;

    return await CampusEvent.db.insertRow(session, event);
  }

  /// Get a single event by ID.
  Future<CampusEvent?> getEvent(Session session, int eventId) async {
    return await CampusEvent.db.findById(session, eventId);
  }

  /// List upcoming events with optional category filter and pagination.
  Future<List<CampusEvent>> listEvents(
    Session session, {
    String? category,
    int limit = 20,
    int offset = 0,
  }) async {
    final now = DateTime.now();

    if (category != null && category.isNotEmpty) {
      return await CampusEvent.db.find(
        session,
        where: (t) =>
            (t.dateTime > now) & t.category.equals(category),
        limit: limit,
        offset: offset,
        orderBy: (t) => t.dateTime,
      );
    }

    return await CampusEvent.db.find(
      session,
      where: (t) => t.dateTime > now,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.dateTime,
    );
  }

  /// List all events (including past) with pagination.
  Future<List<CampusEvent>> listAllEvents(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    return await CampusEvent.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.dateTime.desc(),
    );
  }

  /// Search events by title (case-insensitive contains).
  Future<List<CampusEvent>> searchEvents(
    Session session,
    String query,
  ) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final allEvents = await CampusEvent.db.find(session);
    final lowerQuery = query.trim().toLowerCase();

    return allEvents
        .where((e) =>
            e.title.toLowerCase().contains(lowerQuery) ||
            e.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Update an existing event.
  /// Only the organizer (creator) can edit their events.
  Future<CampusEvent> updateEvent(
    Session session,
    CampusEvent event,
    int requestingProfileId,
  ) async {
    if (event.id == null) {
      throw Exception('Event ID is required for update.');
    }

    final existing = await CampusEvent.db.findById(session, event.id!);
    if (existing == null) {
      throw Exception('Event not found.');
    }

    // Authorization: only the organizer can edit
    if (existing.organizerProfileId != requestingProfileId) {
      throw Exception('You are not authorized to edit this event.');
    }

    event.updatedAt = DateTime.now();
    return await CampusEvent.db.updateRow(session, event);
  }

  /// Delete an event.
  /// Only the organizer can delete their events.
  Future<bool> deleteEvent(
    Session session,
    int eventId,
    int requestingProfileId,
  ) async {
    final existing = await CampusEvent.db.findById(session, eventId);
    if (existing == null) {
      throw Exception('Event not found.');
    }

    if (existing.organizerProfileId != requestingProfileId) {
      throw Exception('You are not authorized to delete this event.');
    }

    final deleted = await CampusEvent.db.deleteWhere(
      session,
      where: (t) => t.id.equals(eventId),
    );
    return deleted.isNotEmpty;
  }

  /// Get list of distinct event categories.
  Future<List<String>> getCategories(Session session) async {
    final events = await CampusEvent.db.find(session);
    final categories = events.map((e) => e.category).toSet().toList();
    categories.sort();
    return categories;
  }
}
