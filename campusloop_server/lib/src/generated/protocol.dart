import 'package:serverpod/serverpod.dart';
import 'student_profile.dart';
import 'campus_event.dart';
import 'community.dart';
import 'community_membership.dart';
import 'community_post.dart';
import 'campus_update.dart';
import 'study_partner_request.dart';

export 'student_profile.dart';
export 'campus_event.dart';
export 'community.dart';
export 'community_membership.dart';
export 'community_post.dart';
export 'campus_update.dart';
export 'study_partner_request.dart';

class Protocol extends SerializationManagerServer {
  Protocol._();

  factory Protocol() => instance;

  static final Protocol instance = Protocol._();

  static final List<TableDefinition> targetTableDefinitions = [
    TableDefinition(
      name: 'student_profile',
      dartName: 'StudentProfile',
      schema: 'public',
      module: 'campusloop',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'displayName',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'email',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'department',
          columnType: ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        ColumnDefinition(
          name: 'year',
          columnType: ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'bio',
          columnType: ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        ColumnDefinition(
          name: 'studySubjects',
          columnType: ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        ColumnDefinition(
          name: 'interests',
          columnType: ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        ColumnDefinition(
          name: 'createdAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        ColumnDefinition(
          name: 'updatedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        IndexDefinition(
          indexName: 'student_profile_email_unique_idx',
          elementsDefinition: [
            IndexElementDefinition(type: IndexElementDefinitionType.column, definition: 'email'),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
    ),
    TableDefinition(
      name: 'campus_event',
      dartName: 'CampusEvent',
      schema: 'public',
      module: 'campusloop',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'title',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'description',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'category',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'venue',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'organizer',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'organizerProfileId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'dateTime',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        ColumnDefinition(
          name: 'endDateTime',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        ColumnDefinition(
          name: 'imageUrl',
          columnType: ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        ColumnDefinition(
          name: 'maxAttendees',
          columnType: ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'createdAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        ColumnDefinition(
          name: 'updatedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        IndexDefinition(
          indexName: 'campus_event_category_idx',
          elementsDefinition: [
            IndexElementDefinition(type: IndexElementDefinitionType.column, definition: 'category'),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        IndexDefinition(
          indexName: 'campus_event_datetime_idx',
          elementsDefinition: [
            IndexElementDefinition(type: IndexElementDefinitionType.column, definition: 'dateTime'),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
    ),
    TableDefinition(
      name: 'community',
      dartName: 'Community',
      schema: 'public',
      module: 'campusloop',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'name',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'description',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'category',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'interests',
          columnType: ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        ColumnDefinition(
          name: 'creatorProfileId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'memberCount',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'imageUrl',
          columnType: ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        ColumnDefinition(
          name: 'createdAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        ColumnDefinition(
          name: 'updatedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        IndexDefinition(
          indexName: 'community_name_unique_idx',
          elementsDefinition: [
            IndexElementDefinition(type: IndexElementDefinitionType.column, definition: 'name'),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
    ),
    TableDefinition(
      name: 'community_membership',
      dartName: 'CommunityMembership',
      schema: 'public',
      module: 'campusloop',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'communityId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'profileId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'role',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'joinedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        IndexDefinition(
          indexName: 'cm_community_profile_unique_idx',
          elementsDefinition: [
            IndexElementDefinition(type: IndexElementDefinitionType.column, definition: 'communityId'),
            IndexElementDefinition(type: IndexElementDefinitionType.column, definition: 'profileId'),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
    ),
    TableDefinition(
      name: 'community_post',
      dartName: 'CommunityPost',
      schema: 'public',
      module: 'campusloop',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'communityId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'authorProfileId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'title',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'content',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'isPinned',
          columnType: ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        ColumnDefinition(
          name: 'createdAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        ColumnDefinition(
          name: 'updatedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
    ),
    TableDefinition(
      name: 'campus_update',
      dartName: 'CampusUpdate',
      schema: 'public',
      module: 'campusloop',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'title',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'content',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'category',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'authorProfileId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'priority',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'isPublished',
          columnType: ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        ColumnDefinition(
          name: 'publishedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        ColumnDefinition(
          name: 'createdAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        ColumnDefinition(
          name: 'updatedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
    ),
    TableDefinition(
      name: 'study_partner_request',
      dartName: 'StudyPartnerRequest',
      schema: 'public',
      module: 'campusloop',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
        ),
        ColumnDefinition(
          name: 'fromProfileId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'toProfileId',
          columnType: ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'status',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        ColumnDefinition(
          name: 'matchingSubjects',
          columnType: ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        ColumnDefinition(
          name: 'message',
          columnType: ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        ColumnDefinition(
          name: 'createdAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        ColumnDefinition(
          name: 'updatedAt',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
    ),
  ];

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;
    if (t == StudentProfile) {
      return StudentProfile.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CampusEvent) {
      return CampusEvent.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == Community) {
      return Community.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CommunityMembership) {
      return CommunityMembership.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CommunityPost) {
      return CommunityPost.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CampusUpdate) {
      return CampusUpdate.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == StudyPartnerRequest) {
      return StudyPartnerRequest.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == getType<StudentProfile?>()) {
      return (data != null ? StudentProfile.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<CampusEvent?>()) {
      return (data != null ? CampusEvent.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<Community?>()) {
      return (data != null ? Community.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<CampusUpdate?>()) {
      return (data != null ? CampusUpdate.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<List<StudentProfile>>()) {
      return (data as List).map((e) => deserialize<StudentProfile>(e)).toList() as T;
    }
    if (t == getType<List<CampusEvent>>()) {
      return (data as List).map((e) => deserialize<CampusEvent>(e)).toList() as T;
    }
    if (t == getType<List<Community>>()) {
      return (data as List).map((e) => deserialize<Community>(e)).toList() as T;
    }
    if (t == getType<List<CommunityMembership>>()) {
      return (data as List).map((e) => deserialize<CommunityMembership>(e)).toList() as T;
    }
    if (t == getType<List<CommunityPost>>()) {
      return (data as List).map((e) => deserialize<CommunityPost>(e)).toList() as T;
    }
    if (t == getType<List<CampusUpdate>>()) {
      return (data as List).map((e) => deserialize<CampusUpdate>(e)).toList() as T;
    }
    if (t == getType<List<StudyPartnerRequest>>()) {
      return (data as List).map((e) => deserialize<StudyPartnerRequest>(e)).toList() as T;
    }
    if (t == getType<List<String>>()) {
      return (data as List).map((e) => e as String).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    if (data is StudentProfile) return 'StudentProfile';
    if (data is CampusEvent) return 'CampusEvent';
    if (data is Community) return 'Community';
    if (data is CommunityMembership) return 'CommunityMembership';
    if (data is CommunityPost) return 'CommunityPost';
    if (data is CampusUpdate) return 'CampusUpdate';
    if (data is StudyPartnerRequest) return 'StudyPartnerRequest';
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var className = data['className'];
    var dataObj = data['data'];
    if (className == 'StudentProfile') return deserialize<StudentProfile>(dataObj);
    if (className == 'CampusEvent') return deserialize<CampusEvent>(dataObj);
    if (className == 'Community') return deserialize<Community>(dataObj);
    if (className == 'CommunityMembership') return deserialize<CommunityMembership>(dataObj);
    if (className == 'CommunityPost') return deserialize<CommunityPost>(dataObj);
    if (className == 'CampusUpdate') return deserialize<CampusUpdate>(dataObj);
    if (className == 'StudyPartnerRequest') return deserialize<StudyPartnerRequest>(dataObj);
    return super.deserializeByClassName(data);
  }

  @override
  Table? getTableForType(Type t) {
    if (t == StudentProfile) return StudentProfile.t;
    if (t == CampusEvent) return CampusEvent.t;
    if (t == Community) return Community.t;
    if (t == CommunityMembership) return CommunityMembership.t;
    if (t == CommunityPost) return CommunityPost.t;
    if (t == CampusUpdate) return CampusUpdate.t;
    if (t == StudyPartnerRequest) return StudyPartnerRequest.t;
    return null;
  }

  @override
  List<TableDefinition> getTargetTableDefinitions() => targetTableDefinitions;
}
