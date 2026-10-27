import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

/// CampusLoop Serverpod client.
class Client extends ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    AuthenticationKeyManager? authenticationKeyManager,
    StreamingConnectionHandler? streamingConnectionHandler,
    ConnectionTimeout? connectionTimeout,
    Function(ServerpodClientException error, StackTrace stackTrace)? onFailedCall,
    Function(ServerpodClientException error, StackTrace stackTrace)? onSucceededCall,
  }) : super(
          host,
          Protocol.instance,
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionHandler: streamingConnectionHandler,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
        ) {
    event = EndpointEvent(this);
    profile = EndpointProfile(this);
    community = EndpointCommunity(this);
    communityPost = EndpointCommunityPost(this);
    campusUpdate = EndpointCampusUpdate(this);
    studyPartner = EndpointStudyPartner(this);
    seed = EndpointSeed(this);
  }

  late final EndpointEvent event;
  late final EndpointProfile profile;
  late final EndpointCommunity community;
  late final EndpointCommunityPost communityPost;
  late final EndpointCampusUpdate campusUpdate;
  late final EndpointStudyPartner studyPartner;
  late final EndpointSeed seed;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
        'event': event,
        'profile': profile,
        'community': community,
        'communityPost': communityPost,
        'campusUpdate': campusUpdate,
        'studyPartner': studyPartner,
        'seed': seed,
      };
}

class EndpointEvent extends EndpointRef {
  EndpointEvent(super.caller);

  @override
  String get name => 'event';

  Future<CampusEvent> createEvent(CampusEvent event) =>
      caller.callServerEndpoint<CampusEvent>(
        'event',
        'createEvent',
        {'event': event},
      );

  Future<CampusEvent?> getEvent(int eventId) =>
      caller.callServerEndpoint<CampusEvent?>(
        'event',
        'getEvent',
        {'eventId': eventId},
      );

  Future<List<CampusEvent>> listEvents({
    String? category,
    int limit = 20,
    int offset = 0,
  }) =>
      caller.callServerEndpoint<List<CampusEvent>>(
        'event',
        'listEvents',
        {
          'category': category,
          'limit': limit,
          'offset': offset,
        },
      );

  Future<List<CampusEvent>> listAllEvents({
    int limit = 50,
    int offset = 0,
  }) =>
      caller.callServerEndpoint<List<CampusEvent>>(
        'event',
        'listAllEvents',
        {
          'limit': limit,
          'offset': offset,
        },
      );

  Future<List<CampusEvent>> searchEvents(String query) =>
      caller.callServerEndpoint<List<CampusEvent>>(
        'event',
        'searchEvents',
        {'query': query},
      );

  Future<CampusEvent> updateEvent(
    CampusEvent event,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<CampusEvent>(
        'event',
        'updateEvent',
        {
          'event': event,
          'requestingProfileId': requestingProfileId,
        },
      );

  Future<bool> deleteEvent(int eventId, int requestingProfileId) =>
      caller.callServerEndpoint<bool>(
        'event',
        'deleteEvent',
        {
          'eventId': eventId,
          'requestingProfileId': requestingProfileId,
        },
      );

  Future<List<String>> getCategories() =>
      caller.callServerEndpoint<List<String>>(
        'event',
        'getCategories',
        {},
      );
}

class EndpointProfile extends EndpointRef {
  EndpointProfile(super.caller);

  @override
  String get name => 'profile';

  Future<StudentProfile> createProfile(StudentProfile profile) =>
      caller.callServerEndpoint<StudentProfile>(
        'profile',
        'createProfile',
        {'profile': profile},
      );

  Future<StudentProfile?> getProfile(int profileId) =>
      caller.callServerEndpoint<StudentProfile?>(
        'profile',
        'getProfile',
        {'profileId': profileId},
      );

  Future<StudentProfile?> getProfileByEmail(String email) =>
      caller.callServerEndpoint<StudentProfile?>(
        'profile',
        'getProfileByEmail',
        {'email': email},
      );

  Future<StudentProfile> updateProfile(StudentProfile profile) =>
      caller.callServerEndpoint<StudentProfile>(
        'profile',
        'updateProfile',
        {'profile': profile},
      );

  Future<List<StudentProfile>> listProfiles({
    int limit = 20,
    int offset = 0,
  }) =>
      caller.callServerEndpoint<List<StudentProfile>>(
        'profile',
        'listProfiles',
        {
          'limit': limit,
          'offset': offset,
        },
      );

  Future<List<StudentProfile>> findStudyPartners(int profileId) =>
      caller.callServerEndpoint<List<StudentProfile>>(
        'profile',
        'findStudyPartners',
        {'profileId': profileId},
      );
}

class EndpointCommunity extends EndpointRef {
  EndpointCommunity(super.caller);

  @override
  String get name => 'community';

  Future<Community> createCommunity(
    Community community,
    int creatorProfileId,
  ) =>
      caller.callServerEndpoint<Community>(
        'community',
        'createCommunity',
        {
          'community': community,
          'creatorProfileId': creatorProfileId,
        },
      );

  Future<Community?> getCommunity(int communityId) =>
      caller.callServerEndpoint<Community?>(
        'community',
        'getCommunity',
        {'communityId': communityId},
      );

  Future<List<Community>> listCommunities({
    String? category,
    int limit = 20,
    int offset = 0,
  }) =>
      caller.callServerEndpoint<List<Community>>(
        'community',
        'listCommunities',
        {
          'category': category,
          'limit': limit,
          'offset': offset,
        },
      );

  Future<List<Community>> searchCommunities(String query) =>
      caller.callServerEndpoint<List<Community>>(
        'community',
        'searchCommunities',
        {'query': query},
      );

  Future<CommunityMembership> joinCommunity(
    int communityId,
    int profileId,
  ) =>
      caller.callServerEndpoint<CommunityMembership>(
        'community',
        'joinCommunity',
        {
          'communityId': communityId,
          'profileId': profileId,
        },
      );

  Future<bool> leaveCommunity(int communityId, int profileId) =>
      caller.callServerEndpoint<bool>(
        'community',
        'leaveCommunity',
        {
          'communityId': communityId,
          'profileId': profileId,
        },
      );

  Future<List<CommunityMembership>> getMembers(int communityId) =>
      caller.callServerEndpoint<List<CommunityMembership>>(
        'community',
        'getMembers',
        {'communityId': communityId},
      );

  Future<List<Community>> getJoinedCommunities(int profileId) =>
      caller.callServerEndpoint<List<Community>>(
        'community',
        'getJoinedCommunities',
        {'profileId': profileId},
      );

  Future<bool> isMember(int communityId, int profileId) =>
      caller.callServerEndpoint<bool>(
        'community',
        'isMember',
        {
          'communityId': communityId,
          'profileId': profileId,
        },
      );

  Future<bool> deleteCommunity(int communityId, int requestingProfileId) =>
      caller.callServerEndpoint<bool>(
        'community',
        'deleteCommunity',
        {
          'communityId': communityId,
          'requestingProfileId': requestingProfileId,
        },
      );
}

class EndpointCommunityPost extends EndpointRef {
  EndpointCommunityPost(super.caller);

  @override
  String get name => 'communityPost';

  Future<CommunityPost> createPost(CommunityPost post) =>
      caller.callServerEndpoint<CommunityPost>(
        'communityPost',
        'createPost',
        {'post': post},
      );

  Future<List<CommunityPost>> listPosts(
    int communityId, {
    int limit = 30,
    int offset = 0,
  }) =>
      caller.callServerEndpoint<List<CommunityPost>>(
        'communityPost',
        'listPosts',
        {
          'communityId': communityId,
          'limit': limit,
          'offset': offset,
        },
      );

  Future<CommunityPost> togglePin(int postId, int requestingProfileId) =>
      caller.callServerEndpoint<CommunityPost>(
        'communityPost',
        'togglePin',
        {
          'postId': postId,
          'requestingProfileId': requestingProfileId,
        },
      );

  Future<bool> deletePost(int postId, int requestingProfileId) =>
      caller.callServerEndpoint<bool>(
        'communityPost',
        'deletePost',
        {
          'postId': postId,
          'requestingProfileId': requestingProfileId,
        },
      );
}

class EndpointCampusUpdate extends EndpointRef {
  EndpointCampusUpdate(super.caller);

  @override
  String get name => 'campusUpdate';

  Future<CampusUpdate> createUpdate(CampusUpdate update) =>
      caller.callServerEndpoint<CampusUpdate>(
        'campusUpdate',
        'createUpdate',
        {'update': update},
      );

  Future<CampusUpdate?> getUpdate(int updateId) =>
      caller.callServerEndpoint<CampusUpdate?>(
        'campusUpdate',
        'getUpdate',
        {'updateId': updateId},
      );

  Future<List<CampusUpdate>> listUpdates({
    String? category,
    int limit = 20,
    int offset = 0,
  }) =>
      caller.callServerEndpoint<List<CampusUpdate>>(
        'campusUpdate',
        'listUpdates',
        {
          'category': category,
          'limit': limit,
          'offset': offset,
        },
      );

  Future<CampusUpdate> updateUpdate(
    CampusUpdate update,
    int requestingProfileId,
  ) =>
      caller.callServerEndpoint<CampusUpdate>(
        'campusUpdate',
        'updateUpdate',
        {
          'update': update,
          'requestingProfileId': requestingProfileId,
        },
      );

  Future<bool> deleteUpdate(int updateId, int requestingProfileId) =>
      caller.callServerEndpoint<bool>(
        'campusUpdate',
        'deleteUpdate',
        {
          'updateId': updateId,
          'requestingProfileId': requestingProfileId,
        },
      );

  Future<List<String>> getCategories() =>
      caller.callServerEndpoint<List<String>>(
        'campusUpdate',
        'getCategories',
        {},
      );
}

class EndpointStudyPartner extends EndpointRef {
  EndpointStudyPartner(super.caller);

  @override
  String get name => 'studyPartner';

  Future<StudyPartnerRequest> sendRequest(
    int fromProfileId,
    int toProfileId,
    String? message,
  ) =>
      caller.callServerEndpoint<StudyPartnerRequest>(
        'studyPartner',
        'sendRequest',
        {
          'fromProfileId': fromProfileId,
          'toProfileId': toProfileId,
          'message': message,
        },
      );

  Future<StudyPartnerRequest> acceptRequest(
    int requestId,
    int acceptingProfileId,
  ) =>
      caller.callServerEndpoint<StudyPartnerRequest>(
        'studyPartner',
        'acceptRequest',
        {
          'requestId': requestId,
          'acceptingProfileId': acceptingProfileId,
        },
      );

  Future<StudyPartnerRequest> rejectRequest(
    int requestId,
    int rejectingProfileId,
  ) =>
      caller.callServerEndpoint<StudyPartnerRequest>(
        'studyPartner',
        'rejectRequest',
        {
          'requestId': requestId,
          'rejectingProfileId': rejectingProfileId,
        },
      );

  Future<List<StudyPartnerRequest>> getIncomingRequests(int profileId) =>
      caller.callServerEndpoint<List<StudyPartnerRequest>>(
        'studyPartner',
        'getIncomingRequests',
        {'profileId': profileId},
      );

  Future<List<StudyPartnerRequest>> getOutgoingRequests(int profileId) =>
      caller.callServerEndpoint<List<StudyPartnerRequest>>(
        'studyPartner',
        'getOutgoingRequests',
        {'profileId': profileId},
      );

  Future<List<StudyPartnerRequest>> getConnections(int profileId) =>
      caller.callServerEndpoint<List<StudyPartnerRequest>>(
        'studyPartner',
        'getConnections',
        {'profileId': profileId},
      );
}

class EndpointSeed extends EndpointRef {
  EndpointSeed(super.caller);

  @override
  String get name => 'seed';

  Future<String> seedDevelopmentData() =>
      caller.callServerEndpoint<String>(
        'seed',
        'seedDevelopmentData',
        {},
      );
}
