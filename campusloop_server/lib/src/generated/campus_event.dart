import 'package:serverpod/serverpod.dart';

class CampusEvent extends TableRow {
  CampusEvent({
    super.id,
    required this.title,
    required this.description,
    required this.category,
    required this.venue,
    required this.organizer,
    required this.organizerProfileId,
    required this.dateTime,
    this.endDateTime,
    this.imageUrl,
    this.maxAttendees,
    required this.createdAt,
    required this.updatedAt,
  });

  String title;
  String description;
  String category;
  String venue;
  String organizer;
  int organizerProfileId;
  DateTime dateTime;
  DateTime? endDateTime;
  String? imageUrl;
  int? maxAttendees;
  DateTime createdAt;
  DateTime updatedAt;

  static final t = CampusEventTable();
  static const db = CampusEventRepository._();

  CampusEvent copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? venue,
    String? organizer,
    int? organizerProfileId,
    DateTime? dateTime,
    DateTime? endDateTime,
    String? imageUrl,
    int? maxAttendees,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampusEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      venue: venue ?? this.venue,
      organizer: organizer ?? this.organizer,
      organizerProfileId: organizerProfileId ?? this.organizerProfileId,
      dateTime: dateTime ?? this.dateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      imageUrl: imageUrl ?? this.imageUrl,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CampusEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusEvent(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      venue: jsonSerialization['venue'] as String,
      organizer: jsonSerialization['organizer'] as String,
      organizerProfileId: jsonSerialization['organizerProfileId'] as int,
      dateTime: DateTime.parse(jsonSerialization['dateTime'] as String),
      endDateTime: jsonSerialization['endDateTime'] != null
          ? DateTime.parse(jsonSerialization['endDateTime'] as String)
          : null,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      maxAttendees: jsonSerialization['maxAttendees'] as int?,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'organizer': organizer,
      'organizerProfileId': organizerProfileId,
      'dateTime': dateTime.toIso8601String(),
      if (endDateTime != null) 'endDateTime': endDateTime!.toIso8601String(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (maxAttendees != null) 'maxAttendees': maxAttendees,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class CampusEventTable extends Table {
  CampusEventTable({super.tableRelation})
      : super(tableName: 'campus_event') {
    title = ColumnString('title', this);
    description = ColumnString('description', this);
    category = ColumnString('category', this);
    venue = ColumnString('venue', this);
    organizer = ColumnString('organizer', this);
    organizerProfileId = ColumnInt('organizerProfileId', this);
    dateTime = ColumnDateTime('dateTime', this);
    endDateTime = ColumnDateTime('endDateTime', this);
    imageUrl = ColumnString('imageUrl', this);
    maxAttendees = ColumnInt('maxAttendees', this);
    createdAt = ColumnDateTime('createdAt', this);
    updatedAt = ColumnDateTime('updatedAt', this);
  }

  late final ColumnString title;
  late final ColumnString description;
  late final ColumnString category;
  late final ColumnString venue;
  late final ColumnString organizer;
  late final ColumnInt organizerProfileId;
  late final ColumnDateTime dateTime;
  late final ColumnDateTime endDateTime;
  late final ColumnString imageUrl;
  late final ColumnInt maxAttendees;
  late final ColumnDateTime createdAt;
  late final ColumnDateTime updatedAt;

  @override
  List<Column> get columns => [
        id,
        title,
        description,
        category,
        venue,
        organizer,
        organizerProfileId,
        dateTime,
        endDateTime,
        imageUrl,
        maxAttendees,
        createdAt,
        updatedAt,
      ];
}

class CampusEventRepository {
  const CampusEventRepository._();

  Future<CampusEvent?> findById(Session session, int id) async {
    return session.db.findById<CampusEvent>(id);
  }

  Future<List<CampusEvent>> find(
    Session session, {
    Expression Function(CampusEventTable)? where,
    int? limit,
    int? offset,
    Column Function(CampusEventTable)? orderBy,
    bool orderDescending = false,
  }) async {
    return session.db.find<CampusEvent>(
      where: where != null ? where(CampusEvent.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy != null ? orderBy(CampusEvent.t) : null,
      orderDescending: orderDescending,
    );
  }

  Future<CampusEvent> insertRow(Session session, CampusEvent row) async {
    return session.db.insertRow<CampusEvent>(row);
  }

  Future<CampusEvent> updateRow(Session session, CampusEvent row) async {
    return session.db.updateRow<CampusEvent>(row);
  }

  Future<List<CampusEvent>> deleteWhere(
    Session session, {
    required Expression Function(CampusEventTable) where,
  }) async {
    return session.db.deleteWhere<CampusEvent>(
      where: where(CampusEvent.t),
    );
  }
}
