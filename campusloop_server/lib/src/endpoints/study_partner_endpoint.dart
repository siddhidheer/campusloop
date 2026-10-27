import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for study-partner connection requests.
///
/// Manages the lifecycle: send → pending → accept/reject.
/// Prevents duplicate and self-requests on the server.
class StudyPartnerEndpoint extends Endpoint {
  /// Send a study-partner request.
  /// Validates profiles exist, prevents duplicates and self-requests.
  Future<StudyPartnerRequest> sendRequest(
    Session session,
    int fromProfileId,
    int toProfileId,
    String? message,
  ) async {
    if (fromProfileId == toProfileId) {
      throw Exception('You cannot send a request to yourself.');
    }

    // Verify both profiles exist
    final fromProfile =
        await StudentProfile.db.findById(session, fromProfileId);
    if (fromProfile == null) {
      throw Exception('Your profile was not found.');
    }

    final toProfile = await StudentProfile.db.findById(session, toProfileId);
    if (toProfile == null) {
      throw Exception('The target student profile was not found.');
    }

    // Check for existing request in either direction
    final existingRequests = await StudyPartnerRequest.db.find(
      session,
      where: (t) =>
          (t.fromProfileId.equals(fromProfileId) &
              t.toProfileId.equals(toProfileId)) |
          (t.fromProfileId.equals(toProfileId) &
              t.toProfileId.equals(fromProfileId)),
    );

    if (existingRequests.isNotEmpty) {
      final existing = existingRequests.first;
      if (existing.status == 'accepted') {
        throw Exception('You are already connected with this student.');
      }
      if (existing.status == 'pending') {
        throw Exception(
            'A pending request already exists between you and this student.');
      }
    }

    // Calculate matching subjects
    final matchingSubjects = fromProfile.studySubjects
        .where((s) => toProfile.studySubjects.contains(s))
        .toList();

    final now = DateTime.now();
    final request = StudyPartnerRequest(
      fromProfileId: fromProfileId,
      toProfileId: toProfileId,
      status: 'pending',
      matchingSubjects: matchingSubjects,
      message: message,
      createdAt: now,
      updatedAt: now,
    );

    return await StudyPartnerRequest.db.insertRow(session, request);
  }

  /// Accept a pending study-partner request.
  /// Only the recipient can accept.
  Future<StudyPartnerRequest> acceptRequest(
    Session session,
    int requestId,
    int acceptingProfileId,
  ) async {
    final request = await StudyPartnerRequest.db.findById(session, requestId);
    if (request == null) {
      throw Exception('Request not found.');
    }

    if (request.toProfileId != acceptingProfileId) {
      throw Exception('You are not authorized to accept this request.');
    }

    if (request.status != 'pending') {
      throw Exception('This request is no longer pending (status: ${request.status}).');
    }

    request
      ..status = 'accepted'
      ..updatedAt = DateTime.now();

    return await StudyPartnerRequest.db.updateRow(session, request);
  }

  /// Reject a pending study-partner request.
  /// Only the recipient can reject.
  Future<StudyPartnerRequest> rejectRequest(
    Session session,
    int requestId,
    int rejectingProfileId,
  ) async {
    final request = await StudyPartnerRequest.db.findById(session, requestId);
    if (request == null) {
      throw Exception('Request not found.');
    }

    if (request.toProfileId != rejectingProfileId) {
      throw Exception('You are not authorized to reject this request.');
    }

    if (request.status != 'pending') {
      throw Exception('This request is no longer pending (status: ${request.status}).');
    }

    request
      ..status = 'rejected'
      ..updatedAt = DateTime.now();

    return await StudyPartnerRequest.db.updateRow(session, request);
  }

  /// Get incoming pending requests for a profile.
  Future<List<StudyPartnerRequest>> getIncomingRequests(
    Session session,
    int profileId,
  ) async {
    return await StudyPartnerRequest.db.find(
      session,
      where: (t) =>
          t.toProfileId.equals(profileId) & t.status.equals('pending'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get outgoing pending requests from a profile.
  Future<List<StudyPartnerRequest>> getOutgoingRequests(
    Session session,
    int profileId,
  ) async {
    return await StudyPartnerRequest.db.find(
      session,
      where: (t) =>
          t.fromProfileId.equals(profileId) & t.status.equals('pending'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get all accepted connections for a profile.
  Future<List<StudyPartnerRequest>> getConnections(
    Session session,
    int profileId,
  ) async {
    return await StudyPartnerRequest.db.find(
      session,
      where: (t) =>
          (t.fromProfileId.equals(profileId) |
              t.toProfileId.equals(profileId)) &
          t.status.equals('accepted'),
      orderBy: (t) => t.updatedAt,
      orderDescending: true,
    );
  }
}
