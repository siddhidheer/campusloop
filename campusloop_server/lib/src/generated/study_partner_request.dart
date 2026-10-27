import 'package:serverpod/serverpod.dart';

class StudyPartnerRequest extends TableRow {
  StudyPartnerRequest({
    super.id,
    required this.fromProfileId,
    required this.toProfileId,
    required this.status,
    required this.matchingSubjects,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  int fromProfileId;
  int toProfileId;
  String status;
  List<String> matchingSubjects;
  String? message;
  DateTime createdAt;
  DateTime updatedAt;

  static final t = StudyPartnerRequestTable();
  static const db = StudyPartnerRequestRepository._();

  StudyPartnerRequest copyWith({
    int? id,
    int? fromProfileId,
    int? toProfileId,
    String? status,
    List<String>? matchingSubjects,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudyPartnerRequest(
      id: id ?? this.id,
      fromProfileId: fromProfileId ?? this.fromProfileId,
      toProfileId: toProfileId ?? this.toProfileId,
      status: status ?? this.status,
      matchingSubjects: matchingSubjects ?? List.from(this.matchingSubjects),
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory StudyPartnerRequest.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StudyPartnerRequest(
      id: jsonSerialization['id'] as int?,
      fromProfileId: jsonSerialization['fromProfileId'] as int,
      toProfileId: jsonSerialization['toProfileId'] as int,
      status: jsonSerialization['status'] as String,
      matchingSubjects: (jsonSerialization['matchingSubjects'] as List)
          .map((e) => e as String)
          .toList(),
      message: jsonSerialization['message'] as String?,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fromProfileId': fromProfileId,
      'toProfileId': toProfileId,
      'status': status,
      'matchingSubjects': matchingSubjects,
      if (message != null) 'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class StudyPartnerRequestTable extends Table {
  StudyPartnerRequestTable({super.tableRelation})
      : super(tableName: 'study_partner_request') {
    fromProfileId = ColumnInt('fromProfileId', this);
    toProfileId = ColumnInt('toProfileId', this);
    status = ColumnString('status', this);
    matchingSubjects = ColumnSerializable('matchingSubjects', this);
    message = ColumnString('message', this);
    createdAt = ColumnDateTime('createdAt', this);
    updatedAt = ColumnDateTime('updatedAt', this);
  }

  late final ColumnInt fromProfileId;
  late final ColumnInt toProfileId;
  late final ColumnString status;
  late final ColumnSerializable matchingSubjects;
  late final ColumnString message;
  late final ColumnDateTime createdAt;
  late final ColumnDateTime updatedAt;

  @override
  List<Column> get columns => [
        id,
        fromProfileId,
        toProfileId,
        status,
        matchingSubjects,
        message,
        createdAt,
        updatedAt,
      ];
}

class StudyPartnerRequestRepository {
  const StudyPartnerRequestRepository._();

  Future<StudyPartnerRequest?> findById(Session session, int id) async {
    return session.db.findById<StudyPartnerRequest>(id);
  }

  Future<List<StudyPartnerRequest>> find(
    Session session, {
    Expression Function(StudyPartnerRequestTable)? where,
    int? limit,
    int? offset,
    Column Function(StudyPartnerRequestTable)? orderBy,
    bool orderDescending = false,
  }) async {
    return session.db.find<StudyPartnerRequest>(
      where: where != null ? where(StudyPartnerRequest.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy != null ? orderBy(StudyPartnerRequest.t) : null,
      orderDescending: orderDescending,
    );
  }

  Future<StudyPartnerRequest> insertRow(
      Session session, StudyPartnerRequest row) async {
    return session.db.insertRow<StudyPartnerRequest>(row);
  }

  Future<StudyPartnerRequest> updateRow(
      Session session, StudyPartnerRequest row) async {
    return session.db.updateRow<StudyPartnerRequest>(row);
  }

  Future<List<StudyPartnerRequest>> deleteWhere(
    Session session, {
    required Expression Function(StudyPartnerRequestTable) where,
  }) async {
    return session.db.deleteWhere<StudyPartnerRequest>(
      where: where(StudyPartnerRequest.t),
    );
  }
}
