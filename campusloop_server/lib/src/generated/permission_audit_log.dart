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
import 'package:serverpod/serverpod.dart' as _is;

abstract class PermissionAuditLog
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PermissionAuditLog._({
    this.id,
    required this.action,
    required this.adminEmail,
    required this.adminProfileId,
    required this.targetEmail,
    required this.targetProfileId,
    this.reason,
    required this.timestamp,
  });

  factory PermissionAuditLog({
    int? id,
    required String action,
    required String adminEmail,
    required int adminProfileId,
    required String targetEmail,
    required int targetProfileId,
    String? reason,
    required DateTime timestamp,
  }) = _PermissionAuditLogImpl;

  factory PermissionAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return PermissionAuditLog(
      id: jsonSerialization['id'] as int?,
      action: jsonSerialization['action'] as String,
      adminEmail: jsonSerialization['adminEmail'] as String,
      adminProfileId: jsonSerialization['adminProfileId'] as int,
      targetEmail: jsonSerialization['targetEmail'] as String,
      targetProfileId: jsonSerialization['targetProfileId'] as int,
      reason: jsonSerialization['reason'] as String?,
      timestamp:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  static final t = PermissionAuditLogTable();

  static const db = PermissionAuditLogRepository._();

  @override
  int? id;

  String action;

  String adminEmail;

  int adminProfileId;

  String targetEmail;

  int targetProfileId;

  String? reason;

  DateTime timestamp;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PermissionAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PermissionAuditLog copyWith({
    int? id,
    String? action,
    String? adminEmail,
    int? adminProfileId,
    String? targetEmail,
    int? targetProfileId,
    String? reason,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PermissionAuditLog',
      if (id != null) 'id': id,
      'action': action,
      'adminEmail': adminEmail,
      'adminProfileId': adminProfileId,
      'targetEmail': targetEmail,
      'targetProfileId': targetProfileId,
      if (reason != null) 'reason': reason,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PermissionAuditLog',
      if (id != null) 'id': id,
      'action': action,
      'adminEmail': adminEmail,
      'adminProfileId': adminProfileId,
      'targetEmail': targetEmail,
      'targetProfileId': targetProfileId,
      if (reason != null) 'reason': reason,
      'timestamp': timestamp.toJson(),
    };
  }

  static PermissionAuditLogInclude include() {
    return PermissionAuditLogInclude._();
  }

  static PermissionAuditLogIncludeList includeList({
    _is.WhereExpressionBuilder<PermissionAuditLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PermissionAuditLogTable>? orderBy,
    _is.OrderByListBuilder<PermissionAuditLogTable>? orderByList,
    PermissionAuditLogInclude? include,
  }) {
    return PermissionAuditLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PermissionAuditLog.t),
      orderByList: orderByList?.call(PermissionAuditLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PermissionAuditLogImpl extends PermissionAuditLog {
  _PermissionAuditLogImpl({
    int? id,
    required String action,
    required String adminEmail,
    required int adminProfileId,
    required String targetEmail,
    required int targetProfileId,
    String? reason,
    required DateTime timestamp,
  }) : super._(
          id: id,
          action: action,
          adminEmail: adminEmail,
          adminProfileId: adminProfileId,
          targetEmail: targetEmail,
          targetProfileId: targetProfileId,
          reason: reason,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [PermissionAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PermissionAuditLog copyWith({
    Object? id = _Undefined,
    String? action,
    String? adminEmail,
    int? adminProfileId,
    String? targetEmail,
    int? targetProfileId,
    Object? reason = _Undefined,
    DateTime? timestamp,
  }) {
    return PermissionAuditLog(
      id: id is int? ? id : this.id,
      action: action ?? this.action,
      adminEmail: adminEmail ?? this.adminEmail,
      adminProfileId: adminProfileId ?? this.adminProfileId,
      targetEmail: targetEmail ?? this.targetEmail,
      targetProfileId: targetProfileId ?? this.targetProfileId,
      reason: reason is String? ? reason : this.reason,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class PermissionAuditLogUpdateTable
    extends _is.UpdateTable<PermissionAuditLogTable> {
  PermissionAuditLogUpdateTable(super.table);

  _is.ColumnValue<String, String> action(String value) => _is.ColumnValue(
        table.action,
        value,
      );

  _is.ColumnValue<String, String> adminEmail(String value) => _is.ColumnValue(
        table.adminEmail,
        value,
      );

  _is.ColumnValue<int, int> adminProfileId(int value) => _is.ColumnValue(
        table.adminProfileId,
        value,
      );

  _is.ColumnValue<String, String> targetEmail(String value) => _is.ColumnValue(
        table.targetEmail,
        value,
      );

  _is.ColumnValue<int, int> targetProfileId(int value) => _is.ColumnValue(
        table.targetProfileId,
        value,
      );

  _is.ColumnValue<String, String> reason(String? value) => _is.ColumnValue(
        table.reason,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _is.ColumnValue(
        table.timestamp,
        value,
      );
}

class PermissionAuditLogTable extends _is.Table<int?> {
  PermissionAuditLogTable({super.tableRelation})
      : super(tableName: 'permission_audit_log') {
    updateTable = PermissionAuditLogUpdateTable(this);
    action = _is.ColumnString(
      'action',
      this,
    );
    adminEmail = _is.ColumnString(
      'adminEmail',
      this,
    );
    adminProfileId = _is.ColumnInt(
      'adminProfileId',
      this,
    );
    targetEmail = _is.ColumnString(
      'targetEmail',
      this,
    );
    targetProfileId = _is.ColumnInt(
      'targetProfileId',
      this,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    timestamp = _is.ColumnDateTime(
      'timestamp',
      this,
    );
  }

  late final PermissionAuditLogUpdateTable updateTable;

  late final _is.ColumnString action;

  late final _is.ColumnString adminEmail;

  late final _is.ColumnInt adminProfileId;

  late final _is.ColumnString targetEmail;

  late final _is.ColumnInt targetProfileId;

  late final _is.ColumnString reason;

  late final _is.ColumnDateTime timestamp;

  @override
  List<_is.Column> get columns => [
        id,
        action,
        adminEmail,
        adminProfileId,
        targetEmail,
        targetProfileId,
        reason,
        timestamp,
      ];
}

class PermissionAuditLogInclude extends _is.IncludeObject {
  PermissionAuditLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PermissionAuditLog.t;
}

class PermissionAuditLogIncludeList extends _is.IncludeList {
  PermissionAuditLogIncludeList._({
    _is.WhereExpressionBuilder<PermissionAuditLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PermissionAuditLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PermissionAuditLog.t;
}

class PermissionAuditLogRepository {
  const PermissionAuditLogRepository._();

  /// Returns a list of [PermissionAuditLog]s matching the given query parameters.
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
  Future<List<PermissionAuditLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PermissionAuditLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PermissionAuditLogTable>? orderBy,
    _is.OrderByListBuilder<PermissionAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PermissionAuditLog>(
      where: where?.call(PermissionAuditLog.t),
      orderBy: orderBy?.call(PermissionAuditLog.t),
      orderByList: orderByList?.call(PermissionAuditLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PermissionAuditLog] matching the given query parameters.
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
  Future<PermissionAuditLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PermissionAuditLogTable>? where,
    int? offset,
    _is.OrderByBuilder<PermissionAuditLogTable>? orderBy,
    _is.OrderByListBuilder<PermissionAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PermissionAuditLog>(
      where: where?.call(PermissionAuditLog.t),
      orderBy: orderBy?.call(PermissionAuditLog.t),
      orderByList: orderByList?.call(PermissionAuditLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PermissionAuditLog] by its [id] or null if no such row exists.
  Future<PermissionAuditLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PermissionAuditLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PermissionAuditLog]s in the list and returns the inserted rows.
  ///
  /// The returned [PermissionAuditLog]s will have their `id` fields set.
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
  Future<List<PermissionAuditLog>> insert(
    _is.DatabaseSession session,
    List<PermissionAuditLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PermissionAuditLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PermissionAuditLog] and returns the inserted row.
  ///
  /// The returned [PermissionAuditLog] will have its `id` field set.
  Future<PermissionAuditLog> insertRow(
    _is.DatabaseSession session,
    PermissionAuditLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PermissionAuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PermissionAuditLog]s in the list and returns the resulting rows.
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
  /// The returned [PermissionAuditLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PermissionAuditLog>> upsert(
    _is.DatabaseSession session,
    List<PermissionAuditLog> rows, {
    required _is.ColumnSelections<PermissionAuditLogTable> conflictColumns,
    _is.ColumnSelections<PermissionAuditLogTable>? updateColumns,
    _is.WhereExpressionBuilder<PermissionAuditLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PermissionAuditLog>(
      rows,
      conflictColumns: conflictColumns(PermissionAuditLog.t),
      updateColumns: updateColumns?.call(PermissionAuditLog.t),
      updateWhere: updateWhere?.call(PermissionAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PermissionAuditLog] and returns the resulting row.
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
  /// The returned [PermissionAuditLog] will have its `id` field set.
  Future<PermissionAuditLog?> upsertRow(
    _is.DatabaseSession session,
    PermissionAuditLog row, {
    required _is.ColumnSelections<PermissionAuditLogTable> conflictColumns,
    _is.ColumnSelections<PermissionAuditLogTable>? updateColumns,
    _is.WhereExpressionBuilder<PermissionAuditLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PermissionAuditLog>(
      row,
      conflictColumns: conflictColumns(PermissionAuditLog.t),
      updateColumns: updateColumns?.call(PermissionAuditLog.t),
      updateWhere: updateWhere?.call(PermissionAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [PermissionAuditLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PermissionAuditLog>> update(
    _is.DatabaseSession session,
    List<PermissionAuditLog> rows, {
    _is.ColumnSelections<PermissionAuditLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PermissionAuditLog>(
      rows,
      columns: columns?.call(PermissionAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PermissionAuditLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PermissionAuditLog> updateRow(
    _is.DatabaseSession session,
    PermissionAuditLog row, {
    _is.ColumnSelections<PermissionAuditLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PermissionAuditLog>(
      row,
      columns: columns?.call(PermissionAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PermissionAuditLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PermissionAuditLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PermissionAuditLogUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PermissionAuditLog>(
      id,
      columnValues: columnValues(PermissionAuditLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PermissionAuditLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PermissionAuditLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PermissionAuditLogUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<PermissionAuditLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PermissionAuditLogTable>? orderBy,
    _is.OrderByListBuilder<PermissionAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PermissionAuditLog>(
      columnValues: columnValues(PermissionAuditLog.t.updateTable),
      where: where(PermissionAuditLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PermissionAuditLog.t),
      orderByList: orderByList?.call(PermissionAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PermissionAuditLog]s in the list and returns the deleted rows.
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
  Future<List<PermissionAuditLog>> delete(
    _is.DatabaseSession session,
    List<PermissionAuditLog> rows, {
    _is.OrderByBuilder<PermissionAuditLogTable>? orderBy,
    _is.OrderByListBuilder<PermissionAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PermissionAuditLog>(
      rows,
      orderBy: orderBy?.call(PermissionAuditLog.t),
      orderByList: orderByList?.call(PermissionAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PermissionAuditLog].
  Future<PermissionAuditLog> deleteRow(
    _is.DatabaseSession session,
    PermissionAuditLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PermissionAuditLog>(
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
  Future<List<PermissionAuditLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PermissionAuditLogTable> where,
    _is.OrderByBuilder<PermissionAuditLogTable>? orderBy,
    _is.OrderByListBuilder<PermissionAuditLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PermissionAuditLog>(
      where: where(PermissionAuditLog.t),
      orderBy: orderBy?.call(PermissionAuditLog.t),
      orderByList: orderByList?.call(PermissionAuditLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PermissionAuditLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PermissionAuditLog>(
      where: where?.call(PermissionAuditLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PermissionAuditLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PermissionAuditLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PermissionAuditLog>(
      where: where(PermissionAuditLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
