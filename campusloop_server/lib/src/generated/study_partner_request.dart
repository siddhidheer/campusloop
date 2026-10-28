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
import 'package:campusloop_server/src/generated/protocol.dart' as _isg3825n;
import 'package:serverpod/serverpod.dart' as _is;

abstract class StudyPartnerRequest
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StudyPartnerRequest._({
    this.id,
    required this.fromProfileId,
    required this.toProfileId,
    required this.status,
    required this.matchingSubjects,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudyPartnerRequest({
    int? id,
    required int fromProfileId,
    required int toProfileId,
    required String status,
    required List<String> matchingSubjects,
    String? message,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyPartnerRequestImpl;

  factory StudyPartnerRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudyPartnerRequest(
      id: jsonSerialization['id'] as int?,
      fromProfileId: jsonSerialization['fromProfileId'] as int,
      toProfileId: jsonSerialization['toProfileId'] as int,
      status: jsonSerialization['status'] as String,
      matchingSubjects: _isg3825n.Protocol()
          .deserialize<List<String>>(jsonSerialization['matchingSubjects']),
      message: jsonSerialization['message'] as String?,
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = StudyPartnerRequestTable();

  static const db = StudyPartnerRequestRepository._();

  @override
  int? id;

  int fromProfileId;

  int toProfileId;

  String status;

  List<String> matchingSubjects;

  String? message;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StudyPartnerRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StudyPartnerRequest copyWith({
    int? id,
    int? fromProfileId,
    int? toProfileId,
    String? status,
    List<String>? matchingSubjects,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudyPartnerRequest',
      if (id != null) 'id': id,
      'fromProfileId': fromProfileId,
      'toProfileId': toProfileId,
      'status': status,
      'matchingSubjects': matchingSubjects.toJson(),
      if (message != null) 'message': message,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudyPartnerRequest',
      if (id != null) 'id': id,
      'fromProfileId': fromProfileId,
      'toProfileId': toProfileId,
      'status': status,
      'matchingSubjects': matchingSubjects.toJson(),
      if (message != null) 'message': message,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static StudyPartnerRequestInclude include() {
    return StudyPartnerRequestInclude._();
  }

  static StudyPartnerRequestIncludeList includeList({
    _is.WhereExpressionBuilder<StudyPartnerRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StudyPartnerRequestTable>? orderBy,
    _is.OrderByListBuilder<StudyPartnerRequestTable>? orderByList,
    StudyPartnerRequestInclude? include,
  }) {
    return StudyPartnerRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudyPartnerRequest.t),
      orderByList: orderByList?.call(StudyPartnerRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudyPartnerRequestImpl extends StudyPartnerRequest {
  _StudyPartnerRequestImpl({
    int? id,
    required int fromProfileId,
    required int toProfileId,
    required String status,
    required List<String> matchingSubjects,
    String? message,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          fromProfileId: fromProfileId,
          toProfileId: toProfileId,
          status: status,
          matchingSubjects: matchingSubjects,
          message: message,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [StudyPartnerRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StudyPartnerRequest copyWith({
    Object? id = _Undefined,
    int? fromProfileId,
    int? toProfileId,
    String? status,
    List<String>? matchingSubjects,
    Object? message = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudyPartnerRequest(
      id: id is int? ? id : this.id,
      fromProfileId: fromProfileId ?? this.fromProfileId,
      toProfileId: toProfileId ?? this.toProfileId,
      status: status ?? this.status,
      matchingSubjects:
          matchingSubjects ?? this.matchingSubjects.map((e0) => e0).toList(),
      message: message is String? ? message : this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class StudyPartnerRequestUpdateTable
    extends _is.UpdateTable<StudyPartnerRequestTable> {
  StudyPartnerRequestUpdateTable(super.table);

  _is.ColumnValue<int, int> fromProfileId(int value) => _is.ColumnValue(
        table.fromProfileId,
        value,
      );

  _is.ColumnValue<int, int> toProfileId(int value) => _is.ColumnValue(
        table.toProfileId,
        value,
      );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
        table.status,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> matchingSubjects(
          List<String> value) =>
      _is.ColumnValue(
        table.matchingSubjects,
        value,
      );

  _is.ColumnValue<String, String> message(String? value) => _is.ColumnValue(
        table.message,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class StudyPartnerRequestTable extends _is.Table<int?> {
  StudyPartnerRequestTable({super.tableRelation})
      : super(tableName: 'study_partner_request') {
    updateTable = StudyPartnerRequestUpdateTable(this);
    fromProfileId = _is.ColumnInt(
      'fromProfileId',
      this,
    );
    toProfileId = _is.ColumnInt(
      'toProfileId',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    matchingSubjects = _is.ColumnSerializable<List<String>>(
      'matchingSubjects',
      this,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final StudyPartnerRequestUpdateTable updateTable;

  late final _is.ColumnInt fromProfileId;

  late final _is.ColumnInt toProfileId;

  late final _is.ColumnString status;

  late final _is.ColumnSerializable<List<String>> matchingSubjects;

  late final _is.ColumnString message;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
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

class StudyPartnerRequestInclude extends _is.IncludeObject {
  StudyPartnerRequestInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StudyPartnerRequest.t;
}

class StudyPartnerRequestIncludeList extends _is.IncludeList {
  StudyPartnerRequestIncludeList._({
    _is.WhereExpressionBuilder<StudyPartnerRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StudyPartnerRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StudyPartnerRequest.t;
}

class StudyPartnerRequestRepository {
  const StudyPartnerRequestRepository._();

  /// Returns a list of [StudyPartnerRequest]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<StudyPartnerRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StudyPartnerRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StudyPartnerRequestTable>? orderBy,
    _is.OrderByListBuilder<StudyPartnerRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StudyPartnerRequest>(
      where: where?.call(StudyPartnerRequest.t),
      orderBy: orderBy?.call(StudyPartnerRequest.t),
      orderByList: orderByList?.call(StudyPartnerRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StudyPartnerRequest] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<StudyPartnerRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StudyPartnerRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<StudyPartnerRequestTable>? orderBy,
    _is.OrderByListBuilder<StudyPartnerRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StudyPartnerRequest>(
      where: where?.call(StudyPartnerRequest.t),
      orderBy: orderBy?.call(StudyPartnerRequest.t),
      orderByList: orderByList?.call(StudyPartnerRequest.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StudyPartnerRequest] by its [id] or null if no such row exists.
  Future<StudyPartnerRequest?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StudyPartnerRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StudyPartnerRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [StudyPartnerRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudyPartnerRequest>> insert(
    _is.DatabaseSession session,
    List<StudyPartnerRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StudyPartnerRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StudyPartnerRequest] and returns the inserted row.
  ///
  /// The returned [StudyPartnerRequest] will have its `id` field set.
  Future<StudyPartnerRequest> insertRow(
    _is.DatabaseSession session,
    StudyPartnerRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StudyPartnerRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StudyPartnerRequest]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [StudyPartnerRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudyPartnerRequest>> upsert(
    _is.DatabaseSession session,
    List<StudyPartnerRequest> rows, {
    required _is.ColumnSelections<StudyPartnerRequestTable> conflictColumns,
    _is.ColumnSelections<StudyPartnerRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<StudyPartnerRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StudyPartnerRequest>(
      rows,
      conflictColumns: conflictColumns(StudyPartnerRequest.t),
      updateColumns: updateColumns?.call(StudyPartnerRequest.t),
      updateWhere: updateWhere?.call(StudyPartnerRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StudyPartnerRequest] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [StudyPartnerRequest] will have its `id` field set.
  Future<StudyPartnerRequest?> upsertRow(
    _is.DatabaseSession session,
    StudyPartnerRequest row, {
    required _is.ColumnSelections<StudyPartnerRequestTable> conflictColumns,
    _is.ColumnSelections<StudyPartnerRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<StudyPartnerRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StudyPartnerRequest>(
      row,
      conflictColumns: conflictColumns(StudyPartnerRequest.t),
      updateColumns: updateColumns?.call(StudyPartnerRequest.t),
      updateWhere: updateWhere?.call(StudyPartnerRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [StudyPartnerRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudyPartnerRequest>> update(
    _is.DatabaseSession session,
    List<StudyPartnerRequest> rows, {
    _is.ColumnSelections<StudyPartnerRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StudyPartnerRequest>(
      rows,
      columns: columns?.call(StudyPartnerRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StudyPartnerRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StudyPartnerRequest> updateRow(
    _is.DatabaseSession session,
    StudyPartnerRequest row, {
    _is.ColumnSelections<StudyPartnerRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StudyPartnerRequest>(
      row,
      columns: columns?.call(StudyPartnerRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudyPartnerRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StudyPartnerRequest?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StudyPartnerRequestUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StudyPartnerRequest>(
      id,
      columnValues: columnValues(StudyPartnerRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StudyPartnerRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudyPartnerRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StudyPartnerRequestUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<StudyPartnerRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StudyPartnerRequestTable>? orderBy,
    _is.OrderByListBuilder<StudyPartnerRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StudyPartnerRequest>(
      columnValues: columnValues(StudyPartnerRequest.t.updateTable),
      where: where(StudyPartnerRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudyPartnerRequest.t),
      orderByList: orderByList?.call(StudyPartnerRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StudyPartnerRequest]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudyPartnerRequest>> delete(
    _is.DatabaseSession session,
    List<StudyPartnerRequest> rows, {
    _is.OrderByBuilder<StudyPartnerRequestTable>? orderBy,
    _is.OrderByListBuilder<StudyPartnerRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StudyPartnerRequest>(
      rows,
      orderBy: orderBy?.call(StudyPartnerRequest.t),
      orderByList: orderByList?.call(StudyPartnerRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StudyPartnerRequest].
  Future<StudyPartnerRequest> deleteRow(
    _is.DatabaseSession session,
    StudyPartnerRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StudyPartnerRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudyPartnerRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StudyPartnerRequestTable> where,
    _is.OrderByBuilder<StudyPartnerRequestTable>? orderBy,
    _is.OrderByListBuilder<StudyPartnerRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StudyPartnerRequest>(
      where: where(StudyPartnerRequest.t),
      orderBy: orderBy?.call(StudyPartnerRequest.t),
      orderByList: orderByList?.call(StudyPartnerRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StudyPartnerRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StudyPartnerRequest>(
      where: where?.call(StudyPartnerRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StudyPartnerRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StudyPartnerRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StudyPartnerRequest>(
      where: where(StudyPartnerRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
