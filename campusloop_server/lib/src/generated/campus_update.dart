import 'package:serverpod/serverpod.dart';

class CampusUpdate extends TableRow {
  CampusUpdate({
    super.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorProfileId,
    required this.priority,
    required this.isPublished,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String title;
  String content;
  String category;
  int authorProfileId;
  String priority;
  bool isPublished;
  DateTime? publishedAt;
  DateTime createdAt;
  DateTime updatedAt;

  static final t = CampusUpdateTable();
  static const db = CampusUpdateRepository._();

  CampusUpdate copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    int? authorProfileId,
    String? priority,
    bool? isPublished,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampusUpdate(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      priority: priority ?? this.priority,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CampusUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusUpdate(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      category: jsonSerialization['category'] as String,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      priority: jsonSerialization['priority'] as String,
      isPublished: jsonSerialization['isPublished'] as bool,
      publishedAt: jsonSerialization['publishedAt'] != null
          ? DateTime.parse(jsonSerialization['publishedAt'] as String)
          : null,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorProfileId': authorProfileId,
      'priority': priority,
      'isPublished': isPublished,
      if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class CampusUpdateTable extends Table {
  CampusUpdateTable({super.tableRelation})
      : super(tableName: 'campus_update') {
    title = ColumnString('title', this);
    content = ColumnString('content', this);
    category = ColumnString('category', this);
    authorProfileId = ColumnInt('authorProfileId', this);
    priority = ColumnString('priority', this);
    isPublished = ColumnBool('isPublished', this);
    publishedAt = ColumnDateTime('publishedAt', this);
    createdAt = ColumnDateTime('createdAt', this);
    updatedAt = ColumnDateTime('updatedAt', this);
  }

  late final ColumnString title;
  late final ColumnString content;
  late final ColumnString category;
  late final ColumnInt authorProfileId;
  late final ColumnString priority;
  late final ColumnBool isPublished;
  late final ColumnDateTime publishedAt;
  late final ColumnDateTime createdAt;
  late final ColumnDateTime updatedAt;

  @override
  List<Column> get columns => [
        id,
        title,
        content,
        category,
        authorProfileId,
        priority,
        isPublished,
        publishedAt,
        createdAt,
        updatedAt,
      ];
}

class CampusUpdateRepository {
  const CampusUpdateRepository._();

  Future<CampusUpdate?> findById(Session session, int id) async {
    return session.db.findById<CampusUpdate>(id);
  }

  Future<List<CampusUpdate>> find(
    Session session, {
    Expression Function(CampusUpdateTable)? where,
    int? limit,
    int? offset,
    Column Function(CampusUpdateTable)? orderBy,
    bool orderDescending = false,
  }) async {
    return session.db.find<CampusUpdate>(
      where: where != null ? where(CampusUpdate.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy != null ? orderBy(CampusUpdate.t) : null,
      orderDescending: orderDescending,
    );
  }

  Future<CampusUpdate> insertRow(
      Session session, CampusUpdate row) async {
    return session.db.insertRow<CampusUpdate>(row);
  }

  Future<CampusUpdate> updateRow(
      Session session, CampusUpdate row) async {
    return session.db.updateRow<CampusUpdate>(row);
  }

  Future<List<CampusUpdate>> deleteWhere(
    Session session, {
    required Expression Function(CampusUpdateTable) where,
  }) async {
    return session.db.deleteWhere<CampusUpdate>(
      where: where(CampusUpdate.t),
    );
  }
}
