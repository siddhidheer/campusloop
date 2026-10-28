/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:campusloop_client/src/protocol/campus_event.dart' as _isvc2zbb;
import 'package:campusloop_client/src/protocol/campus_update.dart' as _iiyyc0fa;
import 'package:campusloop_client/src/protocol/community.dart' as _ih1h51b7;
import 'package:campusloop_client/src/protocol/community_membership.dart'
    as _iy33aivh;
import 'package:campusloop_client/src/protocol/community_post.dart'
    as _i5khyfwd;
import 'package:campusloop_client/src/protocol/student_profile.dart'
    as _iu5j17l1;
import 'package:campusloop_client/src/protocol/study_partner_request.dart'
    as _ia93fw83;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Endpoint for campus update/announcement operations.
///
/// Supports creating, listing, filtering, and managing campus-wide announcements.
/// Publishing restricted to authorized profiles.
/// {@category Endpoint}
class EndpointCampusUpdate extends _isc.EndpointRef {
  EndpointCampusUpdate(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'campusUpdate';

  /// Create a new campus update/announcement.
  _ida.Future<_iiyyc0fa.CampusUpdate> createUpdate(
          _iiyyc0fa.CampusUpdate update) =>
      caller.callServerEndpoint<_iiyyc0fa.CampusUpdate>(
        'campusUpdate',
        'createUpdate',
        {'update': update},
      );

  /// Get a single update by ID.
  _ida.Future<_iiyyc0fa.CampusUpdate?> getUpdate(int updateId) =>
      caller.callServerEndpoint<_iiyyc0fa.CampusUpdate?>(
        'campusUpdate',
        'getUpdate',
        {'updateId': updateId},
      );

  /// List published updates with optional category filter.
  _ida.Future<List<_iiyyc0fa.CampusUpdate>> listUpdates({
    String? category,
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_iiyyc0fa.CampusUpdate>>(
        'campusUpdate',
        'listUpdates',
        {
          'category': category,
          'limit': limit,
          'offset': offset,
        },
      );

  /// Update an existing campus update.
  /// Only the original author can modify.
  _ida.Future<_iiyyc0fa.CampusUpdate> updateUpdate(
    _iiyyc0fa.CampusUpdate update,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<_iiyyc0fa.CampusUpdate>(
        'campusUpdate',
        'updateUpdate',
        {
          'update': update,
          'requestingProfileId': requestingProfileId,
        },
      );

  /// Delete a campus update (author only).
  _ida.Future<bool> deleteUpdate(
    int updateId,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<bool>(
        'campusUpdate',
        'deleteUpdate',
        {
          'updateId': updateId,
          'requestingProfileId': requestingProfileId,
        },
      );

  /// Get available update categories.
  _ida.Future<List<String>> getCategories() =>
      caller.callServerEndpoint<List<String>>(
        'campusUpdate',
        'getCategories',
        {},
      );
}

/// Endpoint for interest-based community operations.
///
/// Handles community CRUD, membership management, and discovery.
/// Community management restricted to creator.
/// {@category Endpoint}
class EndpointCommunity extends _isc.EndpointRef {
  EndpointCommunity(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'community';

  /// Create a new community.
  _ida.Future<_ih1h51b7.Community> createCommunity(
    _ih1h51b7.Community community,
    int creatorProfileId,
  ) =>
      caller.callServerEndpoint<_ih1h51b7.Community>(
        'community',
        'createCommunity',
        {
          'community': community,
          'creatorProfileId': creatorProfileId,
        },
      );

  /// Get a community by ID.
  _ida.Future<_ih1h51b7.Community?> getCommunity(int communityId) =>
      caller.callServerEndpoint<_ih1h51b7.Community?>(
        'community',
        'getCommunity',
        {'communityId': communityId},
      );

  /// List all communities with pagination.
  _ida.Future<List<_ih1h51b7.Community>> listCommunities({
    String? category,
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_ih1h51b7.Community>>(
        'community',
        'listCommunities',
        {
          'category': category,
          'limit': limit,
          'offset': offset,
        },
      );

  /// Search communities by name.
  _ida.Future<List<_ih1h51b7.Community>> searchCommunities(String query) =>
      caller.callServerEndpoint<List<_ih1h51b7.Community>>(
        'community',
        'searchCommunities',
        {'query': query},
      );

  /// Join a community.
  /// Prevents duplicate memberships on the server.
  _ida.Future<_iy33aivh.CommunityMembership> joinCommunity(
    int communityId,
    int profileId,
  ) =>
      caller.callServerEndpoint<_iy33aivh.CommunityMembership>(
        'community',
        'joinCommunity',
        {
          'communityId': communityId,
          'profileId': profileId,
        },
      );

  /// Leave a community.
  /// Community creators cannot leave (they must delete).
  _ida.Future<bool> leaveCommunity(
    int communityId,
    int profileId,
  ) =>
      caller.callServerEndpoint<bool>(
        'community',
        'leaveCommunity',
        {
          'communityId': communityId,
          'profileId': profileId,
        },
      );

  /// Get members of a community.
  _ida.Future<List<_iy33aivh.CommunityMembership>> getMembers(
          int communityId) =>
      caller.callServerEndpoint<List<_iy33aivh.CommunityMembership>>(
        'community',
        'getMembers',
        {'communityId': communityId},
      );

  /// Get communities a profile is a member of.
  _ida.Future<List<_ih1h51b7.Community>> getJoinedCommunities(int profileId) =>
      caller.callServerEndpoint<List<_ih1h51b7.Community>>(
        'community',
        'getJoinedCommunities',
        {'profileId': profileId},
      );

  /// Check if a profile is a member of a community.
  _ida.Future<bool> isMember(
    int communityId,
    int profileId,
  ) =>
      caller.callServerEndpoint<bool>(
        'community',
        'isMember',
        {
          'communityId': communityId,
          'profileId': profileId,
        },
      );

  /// Delete a community (creator only).
  _ida.Future<bool> deleteCommunity(
    int communityId,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<bool>(
        'community',
        'deleteCommunity',
        {
          'communityId': communityId,
          'requestingProfileId': requestingProfileId,
        },
      );
}

/// Endpoint for community post operations.
///
/// Members can create posts, admins/creators can pin/delete.
/// {@category Endpoint}
class EndpointCommunityPost extends _isc.EndpointRef {
  EndpointCommunityPost(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'communityPost';

  /// Create a post in a community.
  /// Requires the author to be a community member.
  _ida.Future<_i5khyfwd.CommunityPost> createPost(
          _i5khyfwd.CommunityPost post) =>
      caller.callServerEndpoint<_i5khyfwd.CommunityPost>(
        'communityPost',
        'createPost',
        {'post': post},
      );

  /// List posts for a community, pinned posts first.
  _ida.Future<List<_i5khyfwd.CommunityPost>> listPosts(
    int communityId, {
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_i5khyfwd.CommunityPost>>(
        'communityPost',
        'listPosts',
        {
          'communityId': communityId,
          'limit': limit,
          'offset': offset,
        },
      );

  /// Toggle pin status of a post (admin/creator only).
  _ida.Future<_i5khyfwd.CommunityPost> togglePin(
    int postId,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<_i5khyfwd.CommunityPost>(
        'communityPost',
        'togglePin',
        {
          'postId': postId,
          'requestingProfileId': requestingProfileId,
        },
      );

  /// Delete a post (author or community admin only).
  _ida.Future<bool> deletePost(
    int postId,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<bool>(
        'communityPost',
        'deletePost',
        {
          'postId': postId,
          'requestingProfileId': requestingProfileId,
        },
      );
}

/// Endpoint for campus event operations.
///
/// Handles event creation, retrieval, filtering, search, and management.
/// Event creation/editing requires ownership verification.
/// {@category Endpoint}
class EndpointEvent extends _isc.EndpointRef {
  EndpointEvent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'event';

  /// Create a new campus event.
  _ida.Future<_isvc2zbb.CampusEvent> createEvent(_isvc2zbb.CampusEvent event) =>
      caller.callServerEndpoint<_isvc2zbb.CampusEvent>(
        'event',
        'createEvent',
        {'event': event},
      );

  /// Get a single event by ID.
  _ida.Future<_isvc2zbb.CampusEvent?> getEvent(int eventId) =>
      caller.callServerEndpoint<_isvc2zbb.CampusEvent?>(
        'event',
        'getEvent',
        {'eventId': eventId},
      );

  /// List upcoming events with optional category filter and pagination.
  _ida.Future<List<_isvc2zbb.CampusEvent>> listEvents({
    String? category,
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_isvc2zbb.CampusEvent>>(
        'event',
        'listEvents',
        {
          'category': category,
          'limit': limit,
          'offset': offset,
        },
      );

  /// List all events (including past) with pagination.
  _ida.Future<List<_isvc2zbb.CampusEvent>> listAllEvents({
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_isvc2zbb.CampusEvent>>(
        'event',
        'listAllEvents',
        {
          'limit': limit,
          'offset': offset,
        },
      );

  /// Search events by title (case-insensitive contains).
  _ida.Future<List<_isvc2zbb.CampusEvent>> searchEvents(String query) =>
      caller.callServerEndpoint<List<_isvc2zbb.CampusEvent>>(
        'event',
        'searchEvents',
        {'query': query},
      );

  /// Update an existing event.
  /// Only the organizer (creator) can edit their events.
  _ida.Future<_isvc2zbb.CampusEvent> updateEvent(
    _isvc2zbb.CampusEvent event,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<_isvc2zbb.CampusEvent>(
        'event',
        'updateEvent',
        {
          'event': event,
          'requestingProfileId': requestingProfileId,
        },
      );

  /// Delete an event.
  /// Only the organizer can delete their events.
  _ida.Future<bool> deleteEvent(
    int eventId,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<bool>(
        'event',
        'deleteEvent',
        {
          'eventId': eventId,
          'requestingProfileId': requestingProfileId,
        },
      );

  /// Get list of distinct event categories.
  _ida.Future<List<String>> getCategories() =>
      caller.callServerEndpoint<List<String>>(
        'event',
        'getCategories',
        {},
      );
}

/// Endpoint for student profile operations.
///
/// Handles profile creation, retrieval, updates, and discovery.
/// All profile mutations require authenticated sessions.
/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  /// Register a new student profile.
  /// Returns the created profile with generated ID.
  _ida.Future<_iu5j17l1.StudentProfile> createProfile(
          _iu5j17l1.StudentProfile profile) =>
      caller.callServerEndpoint<_iu5j17l1.StudentProfile>(
        'profile',
        'createProfile',
        {'profile': profile},
      );

  /// Retrieve a profile by its ID.
  _ida.Future<_iu5j17l1.StudentProfile?> getProfile(int profileId) =>
      caller.callServerEndpoint<_iu5j17l1.StudentProfile?>(
        'profile',
        'getProfile',
        {'profileId': profileId},
      );

  /// Retrieve a profile by email address.
  _ida.Future<_iu5j17l1.StudentProfile?> getProfileByEmail(String email) =>
      caller.callServerEndpoint<_iu5j17l1.StudentProfile?>(
        'profile',
        'getProfileByEmail',
        {'email': email},
      );

  /// Update an existing student profile.
  /// Validates that the requesting user owns the profile.
  _ida.Future<_iu5j17l1.StudentProfile> updateProfile(
          _iu5j17l1.StudentProfile profile) =>
      caller.callServerEndpoint<_iu5j17l1.StudentProfile>(
        'profile',
        'updateProfile',
        {'profile': profile},
      );

  /// List all profiles with pagination support.
  _ida.Future<List<_iu5j17l1.StudentProfile>> listProfiles({
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_iu5j17l1.StudentProfile>>(
        'profile',
        'listProfiles',
        {
          'limit': limit,
          'offset': offset,
        },
      );

  /// Find potential study partners by matching subjects.
  /// Returns profiles that share at least one study subject,
  /// excluding the requesting profile.
  _ida.Future<List<_iu5j17l1.StudentProfile>> findStudyPartners(
          int profileId) =>
      caller.callServerEndpoint<List<_iu5j17l1.StudentProfile>>(
        'profile',
        'findStudyPartners',
        {'profileId': profileId},
      );
}

/// Endpoint for seeding development/demo data.
///
/// This endpoint creates sample records for testing purposes.
/// All seeded data is clearly marked as development sample data.
/// This endpoint should be disabled or removed in production.
/// {@category Endpoint}
class EndpointSeed extends _isc.EndpointRef {
  EndpointSeed(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'seed';

  /// Seed development sample data.
  /// Returns a summary message.
  _ida.Future<String> seedDevelopmentData() =>
      caller.callServerEndpoint<String>(
        'seed',
        'seedDevelopmentData',
        {},
      );
}

/// Endpoint for study-partner connection requests.
///
/// Manages the lifecycle: send → pending → accept/reject.
/// Prevents duplicate and self-requests on the server.
/// {@category Endpoint}
class EndpointStudyPartner extends _isc.EndpointRef {
  EndpointStudyPartner(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'studyPartner';

  /// Send a study-partner request.
  /// Validates profiles exist, prevents duplicates and self-requests.
  _ida.Future<_ia93fw83.StudyPartnerRequest> sendRequest(
    int fromProfileId,
    int toProfileId,
    String? message,
  ) =>
      caller.callServerEndpoint<_ia93fw83.StudyPartnerRequest>(
        'studyPartner',
        'sendRequest',
        {
          'fromProfileId': fromProfileId,
          'toProfileId': toProfileId,
          'message': message,
        },
      );

  /// Accept a pending study-partner request.
  /// Only the recipient can accept.
  _ida.Future<_ia93fw83.StudyPartnerRequest> acceptRequest(
    int requestId,
    int acceptingProfileId,
  ) =>
      caller.callServerEndpoint<_ia93fw83.StudyPartnerRequest>(
        'studyPartner',
        'acceptRequest',
        {
          'requestId': requestId,
          'acceptingProfileId': acceptingProfileId,
        },
      );

  /// Reject a pending study-partner request.
  /// Only the recipient can reject.
  _ida.Future<_ia93fw83.StudyPartnerRequest> rejectRequest(
    int requestId,
    int rejectingProfileId,
  ) =>
      caller.callServerEndpoint<_ia93fw83.StudyPartnerRequest>(
        'studyPartner',
        'rejectRequest',
        {
          'requestId': requestId,
          'rejectingProfileId': rejectingProfileId,
        },
      );

  /// Get incoming pending requests for a profile.
  _ida.Future<List<_ia93fw83.StudyPartnerRequest>> getIncomingRequests(
          int profileId) =>
      caller.callServerEndpoint<List<_ia93fw83.StudyPartnerRequest>>(
        'studyPartner',
        'getIncomingRequests',
        {'profileId': profileId},
      );

  /// Get outgoing pending requests from a profile.
  _ida.Future<List<_ia93fw83.StudyPartnerRequest>> getOutgoingRequests(
          int profileId) =>
      caller.callServerEndpoint<List<_ia93fw83.StudyPartnerRequest>>(
        'studyPartner',
        'getOutgoingRequests',
        {'profileId': profileId},
      );

  /// Get all accepted connections for a profile.
  _ida.Future<List<_ia93fw83.StudyPartnerRequest>> getConnections(
          int profileId) =>
      caller.callServerEndpoint<List<_ia93fw83.StudyPartnerRequest>>(
        'studyPartner',
        'getConnections',
        {'profileId': profileId},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
          host,
          _il2as5qe.Protocol(),
          securityContext: securityContext,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
          httpClientOverride: httpClientOverride,
        ) {
    campusUpdate = EndpointCampusUpdate(this);
    community = EndpointCommunity(this);
    communityPost = EndpointCommunityPost(this);
    event = EndpointEvent(this);
    profile = EndpointProfile(this);
    seed = EndpointSeed(this);
    studyPartner = EndpointStudyPartner(this);
    modules = Modules(this);
  }

  late final EndpointCampusUpdate campusUpdate;

  late final EndpointCommunity community;

  late final EndpointCommunityPost communityPost;

  late final EndpointEvent event;

  late final EndpointProfile profile;

  late final EndpointSeed seed;

  late final EndpointStudyPartner studyPartner;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
        'campusUpdate': campusUpdate,
        'community': community,
        'communityPost': communityPost,
        'event': event,
        'profile': profile,
        'seed': seed,
        'studyPartner': studyPartner,
      };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
        'serverpod_auth_idp': modules.serverpod_auth_idp,
        'serverpod_auth_core': modules.serverpod_auth_core,
      };
}
