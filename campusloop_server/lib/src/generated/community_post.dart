import 'package:serverpod/serverpod.dart';

class CommunityPost extends TableRow {
  CommunityPost({
    super.id,
    required this.communityId,
    required this.authorProfileId,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  int communityId;
  int authorProfileId;
  String title;
  String content;
  bool isPinned;
  DateTime createdAt;
  DateTime updatedAt;

  static final t = CommunityPostTable();
  static const db = CommunityPostRepository._();

  CommunityPost copyWith({
    int? id,
    int? communityId,
    int? authorProfileId,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CommunityPost.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityPost(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      isPinned: jsonSerialization['isPinned'] as bool,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class CommunityPostTable extends Table {
  CommunityPostTable({super.tableRelation})
      : super(tableName: 'community_post') {
    communityId = ColumnInt('communityId', this);
    authorProfileId = ColumnInt('authorProfileId', this);
    title = ColumnString('title', this);
    content = ColumnString('content', this);
    isPinned = ColumnBool('isPinned', this);
    createdAt = ColumnDateTime('createdAt', this);
    updatedAt = ColumnDateTime('updatedAt', this);
  }

  late final ColumnInt communityId;
  late final ColumnInt authorProfileId;
  late final ColumnString title;
  late final ColumnString content;
  late final ColumnBool isPinned;
  late final ColumnDateTime createdAt;
  late final ColumnDateTime updatedAt;

  @override
  List<Column> get columns => [
        id,
        communityId,
        authorProfileId,
        title,
        content,
        isPinned,
        createdAt,
        updatedAt,
      ];
}

class CommunityPostRepository {
  const CommunityPostRepository._();

  Future<CommunityPost?> findById(Session session, int id) async {
    return session.db.findById<CommunityPost>(id);
  }

  Future<List<CommunityPost>> find(
    Session session, {
    Expression Function(CommunityPostTable)? where,
    int? limit,
    int? offset,
    Column Function(CommunityPostTable)? orderBy,
    bool orderDescending = false,
  }) async {
    return session.db.find<CommunityPost>(
      where: where != null ? where(CommunityPost.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy != null ? orderBy(CommunityPost.t) : null,
      orderDescending: orderDescending,
    );
  }

  Future<CommunityPost> insertRow(
      Session session, CommunityPost row) async {
    return session.db.insertRow<CommunityPost>(row);
  }

  Future<CommunityPost> updateRow(
      Session session, CommunityPost row) async {
    return session.db.updateRow<CommunityPost>(row);
  }

  Future<List<CommunityPost>> deleteWhere(
    Session session, {
    required Expression Function(CommunityPostTable) where,
  }) async {
    return session.db.deleteWhere<CommunityPost>(
      where: where(CommunityPost.t),
    );
  }
}
