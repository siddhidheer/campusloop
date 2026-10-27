import 'package:serverpod/serverpod.dart';

class CommunityMembership extends TableRow {
  CommunityMembership({
    super.id,
    required this.communityId,
    required this.profileId,
    required this.role,
    required this.joinedAt,
  });

  int communityId;
  int profileId;
  String role;
  DateTime joinedAt;

  static final t = CommunityMembershipTable();
  static const db = CommunityMembershipRepository._();

  CommunityMembership copyWith({
    int? id,
    int? communityId,
    int? profileId,
    String? role,
    DateTime? joinedAt,
  }) {
    return CommunityMembership(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      profileId: profileId ?? this.profileId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory CommunityMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityMembership(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      role: jsonSerialization['role'] as String,
      joinedAt: DateTime.parse(jsonSerialization['joinedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'communityId': communityId,
      'profileId': profileId,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class CommunityMembershipTable extends Table {
  CommunityMembershipTable({super.tableRelation})
      : super(tableName: 'community_membership') {
    communityId = ColumnInt('communityId', this);
    profileId = ColumnInt('profileId', this);
    role = ColumnString('role', this);
    joinedAt = ColumnDateTime('joinedAt', this);
  }

  late final ColumnInt communityId;
  late final ColumnInt profileId;
  late final ColumnString role;
  late final ColumnDateTime joinedAt;

  @override
  List<Column> get columns => [
        id,
        communityId,
        profileId,
        role,
        joinedAt,
      ];
}

class CommunityMembershipRepository {
  const CommunityMembershipRepository._();

  Future<CommunityMembership?> findById(Session session, int id) async {
    return session.db.findById<CommunityMembership>(id);
  }

  Future<List<CommunityMembership>> find(
    Session session, {
    Expression Function(CommunityMembershipTable)? where,
    int? limit,
    int? offset,
    Column Function(CommunityMembershipTable)? orderBy,
    bool orderDescending = false,
  }) async {
    return session.db.find<CommunityMembership>(
      where: where != null ? where(CommunityMembership.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy != null ? orderBy(CommunityMembership.t) : null,
      orderDescending: orderDescending,
    );
  }

  Future<CommunityMembership> insertRow(
      Session session, CommunityMembership row) async {
    return session.db.insertRow<CommunityMembership>(row);
  }

  Future<CommunityMembership> updateRow(
      Session session, CommunityMembership row) async {
    return session.db.updateRow<CommunityMembership>(row);
  }

  Future<List<CommunityMembership>> deleteWhere(
    Session session, {
    required Expression Function(CommunityMembershipTable) where,
  }) async {
    return session.db.deleteWhere<CommunityMembership>(
      where: where(CommunityMembership.t),
    );
  }
}
