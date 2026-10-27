import 'package:serverpod/serverpod.dart';

class Community extends TableRow {
  Community({
    super.id,
    required this.name,
    required this.description,
    required this.category,
    required this.interests,
    required this.creatorProfileId,
    required this.memberCount,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  String name;
  String description;
  String category;
  List<String> interests;
  int creatorProfileId;
  int memberCount;
  String? imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  static final t = CommunityTable();
  static const db = CommunityRepository._();

  Community copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    List<String>? interests,
    int? creatorProfileId,
    int? memberCount,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      interests: interests ?? List.from(this.interests),
      creatorProfileId: creatorProfileId ?? this.creatorProfileId,
      memberCount: memberCount ?? this.memberCount,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Community.fromJson(Map<String, dynamic> jsonSerialization) {
    return Community(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      interests: (jsonSerialization['interests'] as List)
          .map((e) => e as String)
          .toList(),
      creatorProfileId: jsonSerialization['creatorProfileId'] as int,
      memberCount: jsonSerialization['memberCount'] as int,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'interests': interests,
      'creatorProfileId': creatorProfileId,
      'memberCount': memberCount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class CommunityTable extends Table {
  CommunityTable({super.tableRelation})
      : super(tableName: 'community') {
    name = ColumnString('name', this);
    description = ColumnString('description', this);
    category = ColumnString('category', this);
    interests = ColumnSerializable('interests', this);
    creatorProfileId = ColumnInt('creatorProfileId', this);
    memberCount = ColumnInt('memberCount', this);
    imageUrl = ColumnString('imageUrl', this);
    createdAt = ColumnDateTime('createdAt', this);
    updatedAt = ColumnDateTime('updatedAt', this);
  }

  late final ColumnString name;
  late final ColumnString description;
  late final ColumnString category;
  late final ColumnSerializable interests;
  late final ColumnInt creatorProfileId;
  late final ColumnInt memberCount;
  late final ColumnString imageUrl;
  late final ColumnDateTime createdAt;
  late final ColumnDateTime updatedAt;

  @override
  List<Column> get columns => [
        id,
        name,
        description,
        category,
        interests,
        creatorProfileId,
        memberCount,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}

class CommunityRepository {
  const CommunityRepository._();

  Future<Community?> findById(Session session, int id) async {
    return session.db.findById<Community>(id);
  }

  Future<List<Community>> find(
    Session session, {
    Expression Function(CommunityTable)? where,
    int? limit,
    int? offset,
    Column Function(CommunityTable)? orderBy,
    bool orderDescending = false,
  }) async {
    return session.db.find<Community>(
      where: where != null ? where(Community.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy != null ? orderBy(Community.t) : null,
      orderDescending: orderDescending,
    );
  }

  Future<Community> insertRow(Session session, Community row) async {
    return session.db.insertRow<Community>(row);
  }

  Future<Community> updateRow(Session session, Community row) async {
    return session.db.updateRow<Community>(row);
  }

  Future<List<Community>> deleteWhere(
    Session session, {
    required Expression Function(CommunityTable) where,
  }) async {
    return session.db.deleteWhere<Community>(
      where: where(Community.t),
    );
  }
}
