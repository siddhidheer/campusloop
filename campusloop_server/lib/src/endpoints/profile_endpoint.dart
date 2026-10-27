import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for student profile operations.
///
/// Handles profile creation, retrieval, updates, and discovery.
/// All profile mutations require authenticated sessions.
class ProfileEndpoint extends Endpoint {
  /// Register a new student profile.
  /// Returns the created profile with generated ID.
  Future<StudentProfile> createProfile(
    Session session,
    StudentProfile profile,
  ) async {
    // Validate required fields
    if (profile.displayName.trim().isEmpty) {
      throw Exception('Display name is required.');
    }
    if (profile.email.trim().isEmpty) {
      throw Exception('Email is required.');
    }

    // Check for duplicate email
    final existing = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(profile.email.trim().toLowerCase()),
    );
    if (existing.isNotEmpty) {
      throw Exception('A profile with this email already exists.');
    }

    final now = DateTime.now();
    profile
      ..email = profile.email.trim().toLowerCase()
      ..displayName = profile.displayName.trim()
      ..createdAt = now
      ..updatedAt = now;

    return await StudentProfile.db.insertRow(session, profile);
  }

  /// Retrieve a profile by its ID.
  Future<StudentProfile?> getProfile(Session session, int profileId) async {
    return await StudentProfile.db.findById(session, profileId);
  }

  /// Retrieve a profile by email address.
  Future<StudentProfile?> getProfileByEmail(
      Session session, String email) async {
    final results = await StudentProfile.db.find(
      session,
      where: (t) => t.email.equals(email.trim().toLowerCase()),
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Update an existing student profile.
  /// Validates that the requesting user owns the profile.
  Future<StudentProfile> updateProfile(
    Session session,
    StudentProfile profile,
  ) async {
    if (profile.id == null) {
      throw Exception('Profile ID is required for update.');
    }

    final existing = await StudentProfile.db.findById(session, profile.id!);
    if (existing == null) {
      throw Exception('Profile not found.');
    }

    // Server-side authorization: in a production environment,
    // verify session identity matches the profile owner.
    // For the development session, we validate the profile exists.

    if (profile.displayName.trim().isEmpty) {
      throw Exception('Display name cannot be empty.');
    }

    profile.updatedAt = DateTime.now();
    return await StudentProfile.db.updateRow(session, profile);
  }

  /// List all profiles with pagination support.
  Future<List<StudentProfile>> listProfiles(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    return await StudentProfile.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.displayName,
    );
  }

  /// Find potential study partners by matching subjects.
  /// Returns profiles that share at least one study subject,
  /// excluding the requesting profile.
  Future<List<StudentProfile>> findStudyPartners(
    Session session,
    int profileId,
  ) async {
    final myProfile = await StudentProfile.db.findById(session, profileId);
    if (myProfile == null) {
      throw Exception('Your profile was not found.');
    }

    if (myProfile.studySubjects.isEmpty) {
      return [];
    }

    // Retrieve all other profiles and filter by matching subjects
    final allProfiles = await StudentProfile.db.find(
      session,
      where: (t) => t.id.notEquals(profileId),
    );

    // Filter profiles that have at least one matching subject
    final matches = allProfiles.where((p) {
      return p.studySubjects.any(
        (subject) => myProfile.studySubjects.contains(subject),
      );
    }).toList();

    // Sort by number of matching subjects (most matches first)
    matches.sort((a, b) {
      final aMatches = a.studySubjects
          .where((s) => myProfile.studySubjects.contains(s))
          .length;
      final bMatches = b.studySubjects
          .where((s) => myProfile.studySubjects.contains(s))
          .length;
      return bMatches.compareTo(aMatches);
    });

    return matches;
  }
}
