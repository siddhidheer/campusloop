import 'package:serverpod/serverpod.dart';
import '../endpoints/campus_update_endpoint.dart';
import '../endpoints/community_endpoint.dart';
import '../endpoints/community_post_endpoint.dart';
import '../endpoints/event_endpoint.dart';
import '../endpoints/profile_endpoint.dart';
import '../endpoints/seed_endpoint.dart';
import '../endpoints/study_partner_endpoint.dart';
import 'protocol.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'campusUpdate': CampusUpdateEndpoint()
        ..initialize(
          server,
          'campusUpdate',
          null,
        ),
      'community': CommunityEndpoint()
        ..initialize(
          server,
          'community',
          null,
        ),
      'communityPost': CommunityPostEndpoint()
        ..initialize(
          server,
          'communityPost',
          null,
        ),
      'event': EventEndpoint()
        ..initialize(
          server,
          'event',
          null,
        ),
      'profile': ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'seed': SeedEndpoint()
        ..initialize(
          server,
          'seed',
          null,
        ),
      'studyPartner': StudyPartnerEndpoint()
        ..initialize(
          server,
          'studyPartner',
          null,
        ),
    };

    connectors['campusUpdate'] = EndpointConnector(
      name: 'campusUpdate',
      endpoint: endpoints['campusUpdate']!,
      methodConnectors: {
        'createUpdate': MethodConnector(
          name: 'createUpdate',
          params: {
            'update': ParameterDescription(
              name: 'update',
              type: getType<CampusUpdate>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['campusUpdate'] as CampusUpdateEndpoint)
                  .createUpdate(session, params['update']),
        ),
        'getUpdate': MethodConnector(
          name: 'getUpdate',
          params: {
            'updateId': ParameterDescription(
              name: 'updateId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['campusUpdate'] as CampusUpdateEndpoint)
                  .getUpdate(session, params['updateId']),
        ),
        'listUpdates': MethodConnector(
          name: 'listUpdates',
          params: {
            'category': ParameterDescription(
              name: 'category',
              type: getType<String?>(),
              nullable: true,
            ),
            'limit': ParameterDescription(
              name: 'limit',
              type: getType<int>(),
              nullable: false,
            ),
            'offset': ParameterDescription(
              name: 'offset',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['campusUpdate'] as CampusUpdateEndpoint).listUpdates(
            session,
            category: params['category'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'updateUpdate': MethodConnector(
          name: 'updateUpdate',
          params: {
            'update': ParameterDescription(
              name: 'update',
              type: getType<CampusUpdate>(),
              nullable: false,
            ),
            'requestingProfileId': ParameterDescription(
              name: 'requestingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['campusUpdate'] as CampusUpdateEndpoint).updateUpdate(
            session,
            params['update'],
            params['requestingProfileId'],
          ),
        ),
        'deleteUpdate': MethodConnector(
          name: 'deleteUpdate',
          params: {
            'updateId': ParameterDescription(
              name: 'updateId',
              type: getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': ParameterDescription(
              name: 'requestingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['campusUpdate'] as CampusUpdateEndpoint).deleteUpdate(
            session,
            params['updateId'],
            params['requestingProfileId'],
          ),
        ),
        'getCategories': MethodConnector(
          name: 'getCategories',
          params: {},
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['campusUpdate'] as CampusUpdateEndpoint)
                  .getCategories(session),
        ),
      },
    );

    connectors['community'] = EndpointConnector(
      name: 'community',
      endpoint: endpoints['community']!,
      methodConnectors: {
        'createCommunity': MethodConnector(
          name: 'createCommunity',
          params: {
            'community': ParameterDescription(
              name: 'community',
              type: getType<Community>(),
              nullable: false,
            ),
            'creatorProfileId': ParameterDescription(
              name: 'creatorProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint).createCommunity(
            session,
            params['community'],
            params['creatorProfileId'],
          ),
        ),
        'getCommunity': MethodConnector(
          name: 'getCommunity',
          params: {
            'communityId': ParameterDescription(
              name: 'communityId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint)
                  .getCommunity(session, params['communityId']),
        ),
        'listCommunities': MethodConnector(
          name: 'listCommunities',
          params: {
            'category': ParameterDescription(
              name: 'category',
              type: getType<String?>(),
              nullable: true,
            ),
            'limit': ParameterDescription(
              name: 'limit',
              type: getType<int>(),
              nullable: false,
            ),
            'offset': ParameterDescription(
              name: 'offset',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint).listCommunities(
            session,
            category: params['category'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'searchCommunities': MethodConnector(
          name: 'searchCommunities',
          params: {
            'query': ParameterDescription(
              name: 'query',
              type: getType<String>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint)
                  .searchCommunities(session, params['query']),
        ),
        'joinCommunity': MethodConnector(
          name: 'joinCommunity',
          params: {
            'communityId': ParameterDescription(
              name: 'communityId',
              type: getType<int>(),
              nullable: false,
            ),
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint).joinCommunity(
            session,
            params['communityId'],
            params['profileId'],
          ),
        ),
        'leaveCommunity': MethodConnector(
          name: 'leaveCommunity',
          params: {
            'communityId': ParameterDescription(
              name: 'communityId',
              type: getType<int>(),
              nullable: false,
            ),
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint).leaveCommunity(
            session,
            params['communityId'],
            params['profileId'],
          ),
        ),
        'getMembers': MethodConnector(
          name: 'getMembers',
          params: {
            'communityId': ParameterDescription(
              name: 'communityId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint)
                  .getMembers(session, params['communityId']),
        ),
        'getJoinedCommunities': MethodConnector(
          name: 'getJoinedCommunities',
          params: {
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint)
                  .getJoinedCommunities(session, params['profileId']),
        ),
        'isMember': MethodConnector(
          name: 'isMember',
          params: {
            'communityId': ParameterDescription(
              name: 'communityId',
              type: getType<int>(),
              nullable: false,
            ),
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint).isMember(
            session,
            params['communityId'],
            params['profileId'],
          ),
        ),
        'deleteCommunity': MethodConnector(
          name: 'deleteCommunity',
          params: {
            'communityId': ParameterDescription(
              name: 'communityId',
              type: getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': ParameterDescription(
              name: 'requestingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['community'] as CommunityEndpoint).deleteCommunity(
            session,
            params['communityId'],
            params['requestingProfileId'],
          ),
        ),
      },
    );

    connectors['communityPost'] = EndpointConnector(
      name: 'communityPost',
      endpoint: endpoints['communityPost']!,
      methodConnectors: {
        'createPost': MethodConnector(
          name: 'createPost',
          params: {
            'post': ParameterDescription(
              name: 'post',
              type: getType<CommunityPost>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['communityPost'] as CommunityPostEndpoint)
                  .createPost(session, params['post']),
        ),
        'listPosts': MethodConnector(
          name: 'listPosts',
          params: {
            'communityId': ParameterDescription(
              name: 'communityId',
              type: getType<int>(),
              nullable: false,
            ),
            'limit': ParameterDescription(
              name: 'limit',
              type: getType<int>(),
              nullable: false,
            ),
            'offset': ParameterDescription(
              name: 'offset',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['communityPost'] as CommunityPostEndpoint).listPosts(
            session,
            params['communityId'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'togglePin': MethodConnector(
          name: 'togglePin',
          params: {
            'postId': ParameterDescription(
              name: 'postId',
              type: getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': ParameterDescription(
              name: 'requestingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['communityPost'] as CommunityPostEndpoint).togglePin(
            session,
            params['postId'],
            params['requestingProfileId'],
          ),
        ),
        'deletePost': MethodConnector(
          name: 'deletePost',
          params: {
            'postId': ParameterDescription(
              name: 'postId',
              type: getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': ParameterDescription(
              name: 'requestingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['communityPost'] as CommunityPostEndpoint).deletePost(
            session,
            params['postId'],
            params['requestingProfileId'],
          ),
        ),
      },
    );

    connectors['event'] = EndpointConnector(
      name: 'event',
      endpoint: endpoints['event']!,
      methodConnectors: {
        'createEvent': MethodConnector(
          name: 'createEvent',
          params: {
            'event': ParameterDescription(
              name: 'event',
              type: getType<CampusEvent>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint)
                  .createEvent(session, params['event']),
        ),
        'getEvent': MethodConnector(
          name: 'getEvent',
          params: {
            'eventId': ParameterDescription(
              name: 'eventId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint)
                  .getEvent(session, params['eventId']),
        ),
        'listEvents': MethodConnector(
          name: 'listEvents',
          params: {
            'category': ParameterDescription(
              name: 'category',
              type: getType<String?>(),
              nullable: true,
            ),
            'limit': ParameterDescription(
              name: 'limit',
              type: getType<int>(),
              nullable: false,
            ),
            'offset': ParameterDescription(
              name: 'offset',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint).listEvents(
            session,
            category: params['category'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'listAllEvents': MethodConnector(
          name: 'listAllEvents',
          params: {
            'limit': ParameterDescription(
              name: 'limit',
              type: getType<int>(),
              nullable: false,
            ),
            'offset': ParameterDescription(
              name: 'offset',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint).listAllEvents(
            session,
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'searchEvents': MethodConnector(
          name: 'searchEvents',
          params: {
            'query': ParameterDescription(
              name: 'query',
              type: getType<String>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint)
                  .searchEvents(session, params['query']),
        ),
        'updateEvent': MethodConnector(
          name: 'updateEvent',
          params: {
            'event': ParameterDescription(
              name: 'event',
              type: getType<CampusEvent>(),
              nullable: false,
            ),
            'requestingProfileId': ParameterDescription(
              name: 'requestingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint).updateEvent(
            session,
            params['event'],
            params['requestingProfileId'],
          ),
        ),
        'deleteEvent': MethodConnector(
          name: 'deleteEvent',
          params: {
            'eventId': ParameterDescription(
              name: 'eventId',
              type: getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': ParameterDescription(
              name: 'requestingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint).deleteEvent(
            session,
            params['eventId'],
            params['requestingProfileId'],
          ),
        ),
        'getCategories': MethodConnector(
          name: 'getCategories',
          params: {},
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['event'] as EventEndpoint).getCategories(session),
        ),
      },
    );

    connectors['profile'] = EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'createProfile': MethodConnector(
          name: 'createProfile',
          params: {
            'profile': ParameterDescription(
              name: 'profile',
              type: getType<StudentProfile>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['profile'] as ProfileEndpoint)
                  .createProfile(session, params['profile']),
        ),
        'getProfile': MethodConnector(
          name: 'getProfile',
          params: {
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['profile'] as ProfileEndpoint)
                  .getProfile(session, params['profileId']),
        ),
        'getProfileByEmail': MethodConnector(
          name: 'getProfileByEmail',
          params: {
            'email': ParameterDescription(
              name: 'email',
              type: getType<String>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['profile'] as ProfileEndpoint)
                  .getProfileByEmail(session, params['email']),
        ),
        'updateProfile': MethodConnector(
          name: 'updateProfile',
          params: {
            'profile': ParameterDescription(
              name: 'profile',
              type: getType<StudentProfile>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['profile'] as ProfileEndpoint)
                  .updateProfile(session, params['profile']),
        ),
        'listProfiles': MethodConnector(
          name: 'listProfiles',
          params: {
            'limit': ParameterDescription(
              name: 'limit',
              type: getType<int>(),
              nullable: false,
            ),
            'offset': ParameterDescription(
              name: 'offset',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['profile'] as ProfileEndpoint).listProfiles(
            session,
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'findStudyPartners': MethodConnector(
          name: 'findStudyPartners',
          params: {
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['profile'] as ProfileEndpoint)
                  .findStudyPartners(session, params['profileId']),
        ),
      },
    );

    connectors['seed'] = EndpointConnector(
      name: 'seed',
      endpoint: endpoints['seed']!,
      methodConnectors: {
        'seedDevelopmentData': MethodConnector(
          name: 'seedDevelopmentData',
          params: {},
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['seed'] as SeedEndpoint).seedDevelopmentData(session),
        ),
      },
    );

    connectors['studyPartner'] = EndpointConnector(
      name: 'studyPartner',
      endpoint: endpoints['studyPartner']!,
      methodConnectors: {
        'sendRequest': MethodConnector(
          name: 'sendRequest',
          params: {
            'fromProfileId': ParameterDescription(
              name: 'fromProfileId',
              type: getType<int>(),
              nullable: false,
            ),
            'toProfileId': ParameterDescription(
              name: 'toProfileId',
              type: getType<int>(),
              nullable: false,
            ),
            'message': ParameterDescription(
              name: 'message',
              type: getType<String?>(),
              nullable: true,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['studyPartner'] as StudyPartnerEndpoint).sendRequest(
            session,
            params['fromProfileId'],
            params['toProfileId'],
            params['message'],
          ),
        ),
        'acceptRequest': MethodConnector(
          name: 'acceptRequest',
          params: {
            'requestId': ParameterDescription(
              name: 'requestId',
              type: getType<int>(),
              nullable: false,
            ),
            'acceptingProfileId': ParameterDescription(
              name: 'acceptingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['studyPartner'] as StudyPartnerEndpoint).acceptRequest(
            session,
            params['requestId'],
            params['acceptingProfileId'],
          ),
        ),
        'rejectRequest': MethodConnector(
          name: 'rejectRequest',
          params: {
            'requestId': ParameterDescription(
              name: 'requestId',
              type: getType<int>(),
              nullable: false,
            ),
            'rejectingProfileId': ParameterDescription(
              name: 'rejectingProfileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['studyPartner'] as StudyPartnerEndpoint).rejectRequest(
            session,
            params['requestId'],
            params['rejectingProfileId'],
          ),
        ),
        'getIncomingRequests': MethodConnector(
          name: 'getIncomingRequests',
          params: {
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['studyPartner'] as StudyPartnerEndpoint)
                  .getIncomingRequests(session, params['profileId']),
        ),
        'getOutgoingRequests': MethodConnector(
          name: 'getOutgoingRequests',
          params: {
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['studyPartner'] as StudyPartnerEndpoint)
                  .getOutgoingRequests(session, params['profileId']),
        ),
        'getConnections': MethodConnector(
          name: 'getConnections',
          params: {
            'profileId': ParameterDescription(
              name: 'profileId',
              type: getType<int>(),
              nullable: false,
            ),
          },
          call: (Session session, Map<String, dynamic> params) async =>
              (endpoints['studyPartner'] as StudyPartnerEndpoint)
                  .getConnections(session, params['profileId']),
        ),
      },
    );
  }
}
