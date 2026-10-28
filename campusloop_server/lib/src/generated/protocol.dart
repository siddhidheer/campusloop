/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:campusloop_server/src/generated/campus_event.dart' as _i1c7au20;
import 'package:campusloop_server/src/generated/campus_update.dart'
    as _igo1fi26;
import 'package:campusloop_server/src/generated/community.dart' as _iojnz86y;
import 'package:campusloop_server/src/generated/community_membership.dart'
    as _iwnejj4j;
import 'package:campusloop_server/src/generated/community_post.dart'
    as _iqq9fi66;
import 'package:campusloop_server/src/generated/student_profile.dart'
    as _icxrszas;
import 'package:campusloop_server/src/generated/study_partner_request.dart'
    as _ieluzm8w;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'campus_event.dart' as _ieh998j0;
import 'campus_update.dart' as _ikfbu05k;
import 'community.dart' as _i2q09qvg;
import 'community_membership.dart' as _ir33x8kn;
import 'community_post.dart' as _itvhuiq9;
import 'student_profile.dart' as _iovtxv26;
import 'study_partner_request.dart' as _idamz02b;
export 'campus_event.dart';
export 'campus_update.dart';
export 'community.dart';
export 'community_membership.dart';
export 'community_post.dart';
export 'student_profile.dart';
export 'study_partner_request.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
        _isp.TableDefinition(
          name: 'campus_event',
          dartName: 'CampusEvent',
          schema: 'public',
          module: 'campusloop',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'title',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'description',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'category',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'venue',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'organizer',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'organizerProfileId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'dateTime',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'endDateTime',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: true,
              dartType: 'DateTime?',
            ),
            _isp.ColumnDefinition(
              name: 'imageUrl',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'maxAttendees',
              columnType: _isp.ColumnType.bigint,
              isNullable: true,
              dartType: 'int?',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'updatedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [
            _isp.IndexDefinition(
              indexName: 'campus_event_category_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'category',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'campus_event_datetime_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'dateTime',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'campus_update',
          dartName: 'CampusUpdate',
          schema: 'public',
          module: 'campusloop',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'title',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'content',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'category',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'authorProfileId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'priority',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'isPublished',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
            _isp.ColumnDefinition(
              name: 'publishedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: true,
              dartType: 'DateTime?',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'updatedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [
            _isp.IndexDefinition(
              indexName: 'cu_category_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'category',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'cu_published_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'isPublished',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'cu_published_at_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'publishedAt',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'community',
          dartName: 'Community',
          schema: 'public',
          module: 'campusloop',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'name',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'description',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'category',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'interests',
              columnType: _isp.ColumnType.json,
              isNullable: false,
              dartType: 'List<String>',
            ),
            _isp.ColumnDefinition(
              name: 'creatorProfileId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'memberCount',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'imageUrl',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'updatedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [
            _isp.IndexDefinition(
              indexName: 'community_name_unique_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'name',
                )
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'community_category_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'category',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'community_membership',
          dartName: 'CommunityMembership',
          schema: 'public',
          module: 'campusloop',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'communityId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'profileId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'role',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'joinedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [
            _isp.IndexDefinition(
              indexName: 'cm_community_profile_unique_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'communityId',
                ),
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'profileId',
                ),
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'cm_profile_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'profileId',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'community_post',
          dartName: 'CommunityPost',
          schema: 'public',
          module: 'campusloop',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'communityId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'authorProfileId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'title',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'content',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'isPinned',
              columnType: _isp.ColumnType.boolean,
              isNullable: false,
              dartType: 'bool',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'updatedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [
            _isp.IndexDefinition(
              indexName: 'cp_community_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'communityId',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'cp_created_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'createdAt',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'student_profile',
          dartName: 'StudentProfile',
          schema: 'public',
          module: 'campusloop',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'displayName',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'email',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'department',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'year',
              columnType: _isp.ColumnType.bigint,
              isNullable: true,
              dartType: 'int?',
            ),
            _isp.ColumnDefinition(
              name: 'bio',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'studySubjects',
              columnType: _isp.ColumnType.json,
              isNullable: false,
              dartType: 'List<String>',
            ),
            _isp.ColumnDefinition(
              name: 'interests',
              columnType: _isp.ColumnType.json,
              isNullable: false,
              dartType: 'List<String>',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'updatedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [
            _isp.IndexDefinition(
              indexName: 'student_profile_email_unique_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'email',
                )
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: false,
            )
          ],
          managed: true,
        ),
        _isp.TableDefinition(
          name: 'study_partner_request',
          dartName: 'StudyPartnerRequest',
          schema: 'public',
          module: 'campusloop',
          columns: [
            _isp.ColumnDefinition(
              name: 'id',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int?',
              columnDefault: 'serial',
            ),
            _isp.ColumnDefinition(
              name: 'fromProfileId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'toProfileId',
              columnType: _isp.ColumnType.bigint,
              isNullable: false,
              dartType: 'int',
            ),
            _isp.ColumnDefinition(
              name: 'status',
              columnType: _isp.ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
            _isp.ColumnDefinition(
              name: 'matchingSubjects',
              columnType: _isp.ColumnType.json,
              isNullable: false,
              dartType: 'List<String>',
            ),
            _isp.ColumnDefinition(
              name: 'message',
              columnType: _isp.ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
            _isp.ColumnDefinition(
              name: 'createdAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
            _isp.ColumnDefinition(
              name: 'updatedAt',
              columnType: _isp.ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              dartType: 'DateTime',
            ),
          ],
          foreignKeys: [],
          indexes: [
            _isp.IndexDefinition(
              indexName: 'spr_from_to_unique_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'fromProfileId',
                ),
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'toProfileId',
                ),
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'spr_to_profile_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'toProfileId',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
            _isp.IndexDefinition(
              indexName: 'spr_status_idx',
              tableSpace: null,
              elements: [
                _isp.IndexElementDefinition(
                  type: _isp.IndexElementDefinitionType.column,
                  definition: 'status',
                )
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          managed: true,
        ),
        ..._iais.Protocol.targetTableDefinitions,
        ..._iacs.Protocol.targetTableDefinitions,
        ..._isp.Protocol.targetTableDefinitions,
      ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ieh998j0.CampusEvent) {
      return _ieh998j0.CampusEvent.fromJson(data) as T;
    }
    if (t == _ikfbu05k.CampusUpdate) {
      return _ikfbu05k.CampusUpdate.fromJson(data) as T;
    }
    if (t == _i2q09qvg.Community) {
      return _i2q09qvg.Community.fromJson(data) as T;
    }
    if (t == _ir33x8kn.CommunityMembership) {
      return _ir33x8kn.CommunityMembership.fromJson(data) as T;
    }
    if (t == _itvhuiq9.CommunityPost) {
      return _itvhuiq9.CommunityPost.fromJson(data) as T;
    }
    if (t == _iovtxv26.StudentProfile) {
      return _iovtxv26.StudentProfile.fromJson(data) as T;
    }
    if (t == _idamz02b.StudyPartnerRequest) {
      return _idamz02b.StudyPartnerRequest.fromJson(data) as T;
    }
    if (t == _is.getType<_ieh998j0.CampusEvent?>()) {
      return (data != null ? _ieh998j0.CampusEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikfbu05k.CampusUpdate?>()) {
      return (data != null ? _ikfbu05k.CampusUpdate.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2q09qvg.Community?>()) {
      return (data != null ? _i2q09qvg.Community.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ir33x8kn.CommunityMembership?>()) {
      return (data != null
          ? _ir33x8kn.CommunityMembership.fromJson(data)
          : null) as T;
    }
    if (t == _is.getType<_itvhuiq9.CommunityPost?>()) {
      return (data != null ? _itvhuiq9.CommunityPost.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iovtxv26.StudentProfile?>()) {
      return (data != null ? _iovtxv26.StudentProfile.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idamz02b.StudyPartnerRequest?>()) {
      return (data != null
          ? _idamz02b.StudyPartnerRequest.fromJson(data)
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_igo1fi26.CampusUpdate>) {
      return (data as List)
          .map((e) => deserialize<_igo1fi26.CampusUpdate>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iojnz86y.Community>) {
      return (data as List)
          .map((e) => deserialize<_iojnz86y.Community>(e))
          .toList() as T;
    }
    if (t == List<_iwnejj4j.CommunityMembership>) {
      return (data as List)
          .map((e) => deserialize<_iwnejj4j.CommunityMembership>(e))
          .toList() as T;
    }
    if (t == List<_iqq9fi66.CommunityPost>) {
      return (data as List)
          .map((e) => deserialize<_iqq9fi66.CommunityPost>(e))
          .toList() as T;
    }
    if (t == List<_i1c7au20.CampusEvent>) {
      return (data as List)
          .map((e) => deserialize<_i1c7au20.CampusEvent>(e))
          .toList() as T;
    }
    if (t == List<_icxrszas.StudentProfile>) {
      return (data as List)
          .map((e) => deserialize<_icxrszas.StudentProfile>(e))
          .toList() as T;
    }
    if (t == List<_ieluzm8w.StudyPartnerRequest>) {
      return (data as List)
          .map((e) => deserialize<_ieluzm8w.StudyPartnerRequest>(e))
          .toList() as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ieh998j0.CampusEvent => 'CampusEvent',
      _ikfbu05k.CampusUpdate => 'CampusUpdate',
      _i2q09qvg.Community => 'Community',
      _ir33x8kn.CommunityMembership => 'CommunityMembership',
      _itvhuiq9.CommunityPost => 'CommunityPost',
      _iovtxv26.StudentProfile => 'StudentProfile',
      _idamz02b.StudyPartnerRequest => 'StudyPartnerRequest',
      _ => null
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('campusloop.', '');
    }

    switch (data) {
      case _ieh998j0.CampusEvent():
        return 'CampusEvent';
      case _ikfbu05k.CampusUpdate():
        return 'CampusUpdate';
      case _i2q09qvg.Community():
        return 'Community';
      case _ir33x8kn.CommunityMembership():
        return 'CommunityMembership';
      case _itvhuiq9.CommunityPost():
        return 'CommunityPost';
      case _iovtxv26.StudentProfile():
        return 'StudentProfile';
      case _idamz02b.StudyPartnerRequest():
        return 'StudyPartnerRequest';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CampusEvent') {
      return deserialize<_ieh998j0.CampusEvent>(data['data']);
    }
    if (dataClassName == 'CampusUpdate') {
      return deserialize<_ikfbu05k.CampusUpdate>(data['data']);
    }
    if (dataClassName == 'Community') {
      return deserialize<_i2q09qvg.Community>(data['data']);
    }
    if (dataClassName == 'CommunityMembership') {
      return deserialize<_ir33x8kn.CommunityMembership>(data['data']);
    }
    if (dataClassName == 'CommunityPost') {
      return deserialize<_itvhuiq9.CommunityPost>(data['data']);
    }
    if (dataClassName == 'StudentProfile') {
      return deserialize<_iovtxv26.StudentProfile>(data['data']);
    }
    if (dataClassName == 'StudyPartnerRequest') {
      return deserialize<_idamz02b.StudyPartnerRequest>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('campusloop', this);
    _iacs.Protocol().registerHostProtocol('campusloop', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ieh998j0.CampusEvent:
        return _ieh998j0.CampusEvent.t;
      case _ikfbu05k.CampusUpdate:
        return _ikfbu05k.CampusUpdate.t;
      case _i2q09qvg.Community:
        return _i2q09qvg.Community.t;
      case _ir33x8kn.CommunityMembership:
        return _ir33x8kn.CommunityMembership.t;
      case _itvhuiq9.CommunityPost:
        return _itvhuiq9.CommunityPost.t;
      case _iovtxv26.StudentProfile:
        return _iovtxv26.StudentProfile.t;
      case _idamz02b.StudyPartnerRequest:
        return _idamz02b.StudyPartnerRequest.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'campusloop';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
