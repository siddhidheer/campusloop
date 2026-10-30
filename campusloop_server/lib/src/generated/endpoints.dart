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
import 'package:campusloop_server/src/generated/campus_event.dart' as _i1c7au20;
import 'package:campusloop_server/src/generated/campus_update.dart'
    as _igo1fi26;
import 'package:campusloop_server/src/generated/community.dart' as _iojnz86y;
import 'package:campusloop_server/src/generated/community_post.dart'
    as _iqq9fi66;
import 'package:campusloop_server/src/generated/student_profile.dart'
    as _icxrszas;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../endpoints/auth_endpoint.dart' as _iyggisn2;
import '../endpoints/campus_update_endpoint.dart' as _icibaipm;
import '../endpoints/community_admin_endpoint.dart' as _i2mp4fp9;
import '../endpoints/community_endpoint.dart' as _ijv9oep2;
import '../endpoints/community_post_endpoint.dart' as _iv2ugp3r;
import '../endpoints/event_endpoint.dart' as _icw8lb6p;
import '../endpoints/profile_endpoint.dart' as _i2cx2pww;
import '../endpoints/seed_endpoint.dart' as _i8h1zywb;
import '../endpoints/study_partner_endpoint.dart' as _ih25xh5o;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'auth': _iyggisn2.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'campusUpdate': _icibaipm.CampusUpdateEndpoint()
        ..initialize(
          server,
          'campusUpdate',
          null,
        ),
      'communityAdmin': _i2mp4fp9.CommunityAdminEndpoint()
        ..initialize(
          server,
          'communityAdmin',
          null,
        ),
      'community': _ijv9oep2.CommunityEndpoint()
        ..initialize(
          server,
          'community',
          null,
        ),
      'communityPost': _iv2ugp3r.CommunityPostEndpoint()
        ..initialize(
          server,
          'communityPost',
          null,
        ),
      'event': _icw8lb6p.EventEndpoint()
        ..initialize(
          server,
          'event',
          null,
        ),
      'profile': _i2cx2pww.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'seed': _i8h1zywb.SeedEndpoint()
        ..initialize(
          server,
          'seed',
          null,
        ),
      'studyPartner': _ih25xh5o.StudyPartnerEndpoint()
        ..initialize(
          server,
          'studyPartner',
          null,
        ),
    };
    connectors['auth'] = _is.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'requestRegistrationOtp': _is.MethodConnector(
          name: 'requestRegistrationOtp',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _iyggisn2.AuthEndpoint)
                  .requestRegistrationOtp(
            session,
            params['email'],
          ),
        ),
        'verifyOtp': _is.MethodConnector(
          name: 'verifyOtp',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'enteredOtp': _is.ParameterDescription(
              name: 'enteredOtp',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _iyggisn2.AuthEndpoint).verifyOtp(
            session,
            params['email'],
            params['enteredOtp'],
          ),
        ),
        'completeRegistration': _is.MethodConnector(
          name: 'completeRegistration',
          params: {
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'otp': _is.ParameterDescription(
              name: 'otp',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'department': _is.ParameterDescription(
              name: 'department',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'year': _is.ParameterDescription(
              name: 'year',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'bio': _is.ParameterDescription(
              name: 'bio',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'studySubjects': _is.ParameterDescription(
              name: 'studySubjects',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
            'interests': _is.ParameterDescription(
              name: 'interests',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _iyggisn2.AuthEndpoint)
                  .completeRegistration(
            session,
            displayName: params['displayName'],
            email: params['email'],
            password: params['password'],
            otp: params['otp'],
            department: params['department'],
            year: params['year'],
            bio: params['bio'],
            studySubjects: params['studySubjects'],
            interests: params['interests'],
          ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _iyggisn2.AuthEndpoint).login(
            session,
            params['email'],
            params['password'],
          ),
        ),
      },
    );
    connectors['campusUpdate'] = _is.EndpointConnector(
      name: 'campusUpdate',
      endpoint: endpoints['campusUpdate']!,
      methodConnectors: {
        'createUpdate': _is.MethodConnector(
          name: 'createUpdate',
          params: {
            'update': _is.ParameterDescription(
              name: 'update',
              type: _is.getType<_igo1fi26.CampusUpdate>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['campusUpdate'] as _icibaipm.CampusUpdateEndpoint)
                  .createUpdate(
            session,
            params['update'],
          ),
        ),
        'getUpdate': _is.MethodConnector(
          name: 'getUpdate',
          params: {
            'updateId': _is.ParameterDescription(
              name: 'updateId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['campusUpdate'] as _icibaipm.CampusUpdateEndpoint)
                  .getUpdate(
            session,
            params['updateId'],
          ),
        ),
        'listUpdates': _is.MethodConnector(
          name: 'listUpdates',
          params: {
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['campusUpdate'] as _icibaipm.CampusUpdateEndpoint)
                  .listUpdates(
            session,
            category: params['category'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'updateUpdate': _is.MethodConnector(
          name: 'updateUpdate',
          params: {
            'update': _is.ParameterDescription(
              name: 'update',
              type: _is.getType<_igo1fi26.CampusUpdate>(),
              nullable: false,
            ),
            'requestingProfileId': _is.ParameterDescription(
              name: 'requestingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['campusUpdate'] as _icibaipm.CampusUpdateEndpoint)
                  .updateUpdate(
            session,
            params['update'],
            params['requestingProfileId'],
          ),
        ),
        'deleteUpdate': _is.MethodConnector(
          name: 'deleteUpdate',
          params: {
            'updateId': _is.ParameterDescription(
              name: 'updateId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': _is.ParameterDescription(
              name: 'requestingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['campusUpdate'] as _icibaipm.CampusUpdateEndpoint)
                  .deleteUpdate(
            session,
            params['updateId'],
            params['requestingProfileId'],
          ),
        ),
        'getCategories': _is.MethodConnector(
          name: 'getCategories',
          params: {},
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['campusUpdate'] as _icibaipm.CampusUpdateEndpoint)
                  .getCategories(session),
        ),
      },
    );
    connectors['communityAdmin'] = _is.EndpointConnector(
      name: 'communityAdmin',
      endpoint: endpoints['communityAdmin']!,
      methodConnectors: {
        'isAdministrator': _is.MethodConnector(
          name: 'isAdministrator',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .isAdministrator(
            session,
            params['profileId'],
          ),
        ),
        'canCreateCommunity': _is.MethodConnector(
          name: 'canCreateCommunity',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .canCreateCommunity(
            session,
            params['profileId'],
          ),
        ),
        'searchUserByEmail': _is.MethodConnector(
          name: 'searchUserByEmail',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .searchUserByEmail(
            session,
            params['adminProfileId'],
            params['email'],
          ),
        ),
        'grantPermission': _is.MethodConnector(
          name: 'grantPermission',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'targetEmail': _is.ParameterDescription(
              name: 'targetEmail',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .grantPermission(
            session,
            params['adminProfileId'],
            params['targetEmail'],
            reason: params['reason'],
          ),
        ),
        'revokePermission': _is.MethodConnector(
          name: 'revokePermission',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'targetEmail': _is.ParameterDescription(
              name: 'targetEmail',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .revokePermission(
            session,
            params['adminProfileId'],
            params['targetEmail'],
            reason: params['reason'],
          ),
        ),
        'listAuthorizedUsers': _is.MethodConnector(
          name: 'listAuthorizedUsers',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .listAuthorizedUsers(
            session,
            params['adminProfileId'],
          ),
        ),
        'getAuditLogs': _is.MethodConnector(
          name: 'getAuditLogs',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .getAuditLogs(
            session,
            params['adminProfileId'],
            limit: params['limit'],
          ),
        ),
        'getSpamRules': _is.MethodConnector(
          name: 'getSpamRules',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .getSpamRules(
            session,
            params['adminProfileId'],
          ),
        ),
        'addSpamRule': _is.MethodConnector(
          name: 'addSpamRule',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pattern': _is.ParameterDescription(
              name: 'pattern',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .addSpamRule(
            session,
            params['adminProfileId'],
            params['pattern'],
            params['category'],
          ),
        ),
        'toggleSpamRule': _is.MethodConnector(
          name: 'toggleSpamRule',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'ruleId': _is.ParameterDescription(
              name: 'ruleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'isEnabled': _is.ParameterDescription(
              name: 'isEnabled',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .toggleSpamRule(
            session,
            params['adminProfileId'],
            params['ruleId'],
            params['isEnabled'],
          ),
        ),
        'getModerationLogs': _is.MethodConnector(
          name: 'getModerationLogs',
          params: {
            'adminProfileId': _is.ParameterDescription(
              name: 'adminProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityAdmin'] as _i2mp4fp9.CommunityAdminEndpoint)
                  .getModerationLogs(
            session,
            params['adminProfileId'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
      },
    );
    connectors['community'] = _is.EndpointConnector(
      name: 'community',
      endpoint: endpoints['community']!,
      methodConnectors: {
        'createCommunity': _is.MethodConnector(
          name: 'createCommunity',
          params: {
            'community': _is.ParameterDescription(
              name: 'community',
              type: _is.getType<_iojnz86y.Community>(),
              nullable: false,
            ),
            'creatorProfileId': _is.ParameterDescription(
              name: 'creatorProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .createCommunity(
            session,
            params['community'],
            params['creatorProfileId'],
          ),
        ),
        'getCommunity': _is.MethodConnector(
          name: 'getCommunity',
          params: {
            'communityId': _is.ParameterDescription(
              name: 'communityId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .getCommunity(
            session,
            params['communityId'],
          ),
        ),
        'getOrCreateGeneralDiscussion': _is.MethodConnector(
          name: 'getOrCreateGeneralDiscussion',
          params: {},
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .getOrCreateGeneralDiscussion(session),
        ),
        'listCommunities': _is.MethodConnector(
          name: 'listCommunities',
          params: {
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .listCommunities(
            session,
            category: params['category'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'searchCommunities': _is.MethodConnector(
          name: 'searchCommunities',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .searchCommunities(
            session,
            params['query'],
          ),
        ),
        'joinCommunity': _is.MethodConnector(
          name: 'joinCommunity',
          params: {
            'communityId': _is.ParameterDescription(
              name: 'communityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .joinCommunity(
            session,
            params['communityId'],
            params['profileId'],
          ),
        ),
        'leaveCommunity': _is.MethodConnector(
          name: 'leaveCommunity',
          params: {
            'communityId': _is.ParameterDescription(
              name: 'communityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .leaveCommunity(
            session,
            params['communityId'],
            params['profileId'],
          ),
        ),
        'getMembers': _is.MethodConnector(
          name: 'getMembers',
          params: {
            'communityId': _is.ParameterDescription(
              name: 'communityId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .getMembers(
            session,
            params['communityId'],
          ),
        ),
        'getJoinedCommunities': _is.MethodConnector(
          name: 'getJoinedCommunities',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .getJoinedCommunities(
            session,
            params['profileId'],
          ),
        ),
        'isMember': _is.MethodConnector(
          name: 'isMember',
          params: {
            'communityId': _is.ParameterDescription(
              name: 'communityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint).isMember(
            session,
            params['communityId'],
            params['profileId'],
          ),
        ),
        'deleteCommunity': _is.MethodConnector(
          name: 'deleteCommunity',
          params: {
            'communityId': _is.ParameterDescription(
              name: 'communityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': _is.ParameterDescription(
              name: 'requestingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['community'] as _ijv9oep2.CommunityEndpoint)
                  .deleteCommunity(
            session,
            params['communityId'],
            params['requestingProfileId'],
          ),
        ),
      },
    );
    connectors['communityPost'] = _is.EndpointConnector(
      name: 'communityPost',
      endpoint: endpoints['communityPost']!,
      methodConnectors: {
        'createPost': _is.MethodConnector(
          name: 'createPost',
          params: {
            'post': _is.ParameterDescription(
              name: 'post',
              type: _is.getType<_iqq9fi66.CommunityPost>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityPost'] as _iv2ugp3r.CommunityPostEndpoint)
                  .createPost(
            session,
            params['post'],
          ),
        ),
        'checkMessageForSpam': _is.MethodConnector(
          name: 'checkMessageForSpam',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityPost'] as _iv2ugp3r.CommunityPostEndpoint)
                  .checkMessageForSpam(
            session,
            params['title'],
            params['content'],
            profileId: params['profileId'],
            email: params['email'],
          ),
        ),
        'listPosts': _is.MethodConnector(
          name: 'listPosts',
          params: {
            'communityId': _is.ParameterDescription(
              name: 'communityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityPost'] as _iv2ugp3r.CommunityPostEndpoint)
                  .listPosts(
            session,
            params['communityId'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'togglePin': _is.MethodConnector(
          name: 'togglePin',
          params: {
            'postId': _is.ParameterDescription(
              name: 'postId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': _is.ParameterDescription(
              name: 'requestingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityPost'] as _iv2ugp3r.CommunityPostEndpoint)
                  .togglePin(
            session,
            params['postId'],
            params['requestingProfileId'],
          ),
        ),
        'deletePost': _is.MethodConnector(
          name: 'deletePost',
          params: {
            'postId': _is.ParameterDescription(
              name: 'postId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': _is.ParameterDescription(
              name: 'requestingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['communityPost'] as _iv2ugp3r.CommunityPostEndpoint)
                  .deletePost(
            session,
            params['postId'],
            params['requestingProfileId'],
          ),
        ),
      },
    );
    connectors['event'] = _is.EndpointConnector(
      name: 'event',
      endpoint: endpoints['event']!,
      methodConnectors: {
        'createEvent': _is.MethodConnector(
          name: 'createEvent',
          params: {
            'event': _is.ParameterDescription(
              name: 'event',
              type: _is.getType<_i1c7au20.CampusEvent>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint).createEvent(
            session,
            params['event'],
          ),
        ),
        'getEvent': _is.MethodConnector(
          name: 'getEvent',
          params: {
            'eventId': _is.ParameterDescription(
              name: 'eventId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint).getEvent(
            session,
            params['eventId'],
          ),
        ),
        'listEvents': _is.MethodConnector(
          name: 'listEvents',
          params: {
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint).listEvents(
            session,
            category: params['category'],
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'listAllEvents': _is.MethodConnector(
          name: 'listAllEvents',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint).listAllEvents(
            session,
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'searchEvents': _is.MethodConnector(
          name: 'searchEvents',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint).searchEvents(
            session,
            params['query'],
          ),
        ),
        'updateEvent': _is.MethodConnector(
          name: 'updateEvent',
          params: {
            'event': _is.ParameterDescription(
              name: 'event',
              type: _is.getType<_i1c7au20.CampusEvent>(),
              nullable: false,
            ),
            'requestingProfileId': _is.ParameterDescription(
              name: 'requestingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint).updateEvent(
            session,
            params['event'],
            params['requestingProfileId'],
          ),
        ),
        'deleteEvent': _is.MethodConnector(
          name: 'deleteEvent',
          params: {
            'eventId': _is.ParameterDescription(
              name: 'eventId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'requestingProfileId': _is.ParameterDescription(
              name: 'requestingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint).deleteEvent(
            session,
            params['eventId'],
            params['requestingProfileId'],
          ),
        ),
        'getCategories': _is.MethodConnector(
          name: 'getCategories',
          params: {},
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _icw8lb6p.EventEndpoint)
                  .getCategories(session),
        ),
      },
    );
    connectors['profile'] = _is.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'createProfile': _is.MethodConnector(
          name: 'createProfile',
          params: {
            'profile': _is.ParameterDescription(
              name: 'profile',
              type: _is.getType<_icxrszas.StudentProfile>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).createProfile(
            session,
            params['profile'],
          ),
        ),
        'getProfile': _is.MethodConnector(
          name: 'getProfile',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).getProfile(
            session,
            params['profileId'],
          ),
        ),
        'getProfileByEmail': _is.MethodConnector(
          name: 'getProfileByEmail',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['profile'] as _i2cx2pww.ProfileEndpoint)
                  .getProfileByEmail(
            session,
            params['email'],
          ),
        ),
        'updateProfile': _is.MethodConnector(
          name: 'updateProfile',
          params: {
            'profile': _is.ParameterDescription(
              name: 'profile',
              type: _is.getType<_icxrszas.StudentProfile>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).updateProfile(
            session,
            params['profile'],
          ),
        ),
        'listProfiles': _is.MethodConnector(
          name: 'listProfiles',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).listProfiles(
            session,
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'findStudyPartners': _is.MethodConnector(
          name: 'findStudyPartners',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['profile'] as _i2cx2pww.ProfileEndpoint)
                  .findStudyPartners(
            session,
            params['profileId'],
          ),
        ),
        'deleteAccount': _is.MethodConnector(
          name: 'deleteAccount',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).deleteAccount(
            session,
            params['profileId'],
          ),
        ),
      },
    );
    connectors['seed'] = _is.EndpointConnector(
      name: 'seed',
      endpoint: endpoints['seed']!,
      methodConnectors: {
        'seedDevelopmentData': _is.MethodConnector(
          name: 'seedDevelopmentData',
          params: {},
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['seed'] as _i8h1zywb.SeedEndpoint)
                  .seedDevelopmentData(session),
        )
      },
    );
    connectors['studyPartner'] = _is.EndpointConnector(
      name: 'studyPartner',
      endpoint: endpoints['studyPartner']!,
      methodConnectors: {
        'sendRequest': _is.MethodConnector(
          name: 'sendRequest',
          params: {
            'fromProfileId': _is.ParameterDescription(
              name: 'fromProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'toProfileId': _is.ParameterDescription(
              name: 'toProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['studyPartner'] as _ih25xh5o.StudyPartnerEndpoint)
                  .sendRequest(
            session,
            params['fromProfileId'],
            params['toProfileId'],
            params['message'],
          ),
        ),
        'acceptRequest': _is.MethodConnector(
          name: 'acceptRequest',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'acceptingProfileId': _is.ParameterDescription(
              name: 'acceptingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['studyPartner'] as _ih25xh5o.StudyPartnerEndpoint)
                  .acceptRequest(
            session,
            params['requestId'],
            params['acceptingProfileId'],
          ),
        ),
        'rejectRequest': _is.MethodConnector(
          name: 'rejectRequest',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'rejectingProfileId': _is.ParameterDescription(
              name: 'rejectingProfileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['studyPartner'] as _ih25xh5o.StudyPartnerEndpoint)
                  .rejectRequest(
            session,
            params['requestId'],
            params['rejectingProfileId'],
          ),
        ),
        'getIncomingRequests': _is.MethodConnector(
          name: 'getIncomingRequests',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['studyPartner'] as _ih25xh5o.StudyPartnerEndpoint)
                  .getIncomingRequests(
            session,
            params['profileId'],
          ),
        ),
        'getOutgoingRequests': _is.MethodConnector(
          name: 'getOutgoingRequests',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['studyPartner'] as _ih25xh5o.StudyPartnerEndpoint)
                  .getOutgoingRequests(
            session,
            params['profileId'],
          ),
        ),
        'getConnections': _is.MethodConnector(
          name: 'getConnections',
          params: {
            'profileId': _is.ParameterDescription(
              name: 'profileId',
              type: _is.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _is.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['studyPartner'] as _ih25xh5o.StudyPartnerEndpoint)
                  .getConnections(
            session,
            params['profileId'],
          ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
