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

abstract class ModerationLog
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ModerationLog._({
    this.id,
    required this.communityId,
    required this.authorProfileId,
    required this.authorEmail,
    required this.postTitle,
    required this.contentSnippet,
    required this.matchedRule,
    required this.reason,
    required this.isBlocked,
    required this.timestamp,
  });

  factory ModerationLog({
    int? id,
    required int communityId,
    required int authorProfileId,
    required String authorEmail,
    required String postTitle,
    required String contentSnippet,
    required String matchedRule,
    required String reason,
    required bool isBlocked,
    required DateTime timestamp,
  }) = _ModerationLogImpl;

  factory ModerationLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModerationLog(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      authorEmail: jsonSerialization['authorEmail'] as String,
      postTitle: jsonSerialization['postTitle'] as String,
      contentSnippet: jsonSerialization['contentSnippet'] as String,
      matchedRule: jsonSerialization['matchedRule'] as String,
      reason: jsonSerialization['reason'] as String,
      isBlocked: _is.BoolJsonExtension.fromJson(jsonSerialization['isBlocked']),
      timestamp:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  static final t = ModerationLogTable();

  static const db = ModerationLogRepository._();

  @override
  int? id;

  int communityId;

  int authorProfileId;

  String authorEmail;

  String postTitle;

  String contentSnippet;

  String matchedRule;

  String reason;

  bool isBlocked;

  DateTime timestamp;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ModerationLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ModerationLog copyWith({
    int? id,
    int? communityId,
    int? authorProfileId,
    String? authorEmail,
    String? postTitle,
    String? contentSnippet,
    String? matchedRule,
    String? reason,
    bool? isBlocked,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModerationLog',
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'authorEmail': authorEmail,
      'postTitle': postTitle,
      'contentSnippet': contentSnippet,
      'matchedRule': matchedRule,
      'reason': reason,
      'isBlocked': isBlocked,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModerationLog',
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'authorEmail': authorEmail,
      'postTitle': postTitle,
      'contentSnippet': contentSnippet,
      'matchedRule': matchedRule,
      'reason': reason,
      'isBlocked': isBlocked,
      'timestamp': timestamp.toJson(),
    };
  }

  static ModerationLogInclude include() {
    return ModerationLogInclude._();
  }

  static ModerationLogIncludeList includeList({
    _is.WhereExpressionBuilder<ModerationLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModerationLogTable>? orderBy,
    _is.OrderByListBuilder<ModerationLogTable>? orderByList,
    ModerationLogInclude? include,
  }) {
    return ModerationLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModerationLog.t),
      orderByList: orderByList?.call(ModerationLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModerationLogImpl extends ModerationLog {
  _ModerationLogImpl({
    int? id,
    required int communityId,
    required int authorProfileId,
    required String authorEmail,
    required String postTitle,
    required String contentSnippet,
    required String matchedRule,
    required String reason,
    required bool isBlocked,
    required DateTime timestamp,
  }) : super._(
          id: id,
          communityId: communityId,
          authorProfileId: authorProfileId,
          authorEmail: authorEmail,
          postTitle: postTitle,
          contentSnippet: contentSnippet,
          matchedRule: matchedRule,
          reason: reason,
          isBlocked: isBlocked,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [ModerationLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ModerationLog copyWith({
    Object? id = _Undefined,
    int? communityId,
    int? authorProfileId,
    String? authorEmail,
    String? postTitle,
    String? contentSnippet,
    String? matchedRule,
    String? reason,
    bool? isBlocked,
    DateTime? timestamp,
  }) {
    return ModerationLog(
      id: id is int? ? id : this.id,
      communityId: communityId ?? this.communityId,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      authorEmail: authorEmail ?? this.authorEmail,
      postTitle: postTitle ?? this.postTitle,
      contentSnippet: contentSnippet ?? this.contentSnippet,
      matchedRule: matchedRule ?? this.matchedRule,
      reason: reason ?? this.reason,
      isBlocked: isBlocked ?? this.isBlocked,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class ModerationLogUpdateTable extends _is.UpdateTable<ModerationLogTable> {
  ModerationLogUpdateTable(super.table);

  _is.ColumnValue<int, int> communityId(int value) => _is.ColumnValue(
        table.communityId,
        value,
      );

  _is.ColumnValue<int, int> authorProfileId(int value) => _is.ColumnValue(
        table.authorProfileId,
        value,
      );

  _is.ColumnValue<String, String> authorEmail(String value) => _is.ColumnValue(
        table.authorEmail,
        value,
      );

  _is.ColumnValue<String, String> postTitle(String value) => _is.ColumnValue(
        table.postTitle,
        value,
      );

  _is.ColumnValue<String, String> contentSnippet(String value) =>
      _is.ColumnValue(
        table.contentSnippet,
        value,
      );

  _is.ColumnValue<String, String> matchedRule(String value) => _is.ColumnValue(
        table.matchedRule,
        value,
      );

  _is.ColumnValue<String, String> reason(String value) => _is.ColumnValue(
        table.reason,
        value,
      );

  _is.ColumnValue<bool, bool> isBlocked(bool value) => _is.ColumnValue(
        table.isBlocked,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _is.ColumnValue(
        table.timestamp,
        value,
      );
}

class ModerationLogTable extends _is.Table<int?> {
  ModerationLogTable({super.tableRelation})
      : super(tableName: 'moderation_log') {
    updateTable = ModerationLogUpdateTable(this);
    communityId = _is.ColumnInt(
      'communityId',
      this,
    );
    authorProfileId = _is.ColumnInt(
      'authorProfileId',
      this,
    );
    authorEmail = _is.ColumnString(
      'authorEmail',
      this,
    );
    postTitle = _is.ColumnString(
      'postTitle',
      this,
    );
    contentSnippet = _is.ColumnString(
      'contentSnippet',
      this,
    );
    matchedRule = _is.ColumnString(
      'matchedRule',
      this,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    isBlocked = _is.ColumnBool(
      'isBlocked',
      this,
    );
    timestamp = _is.ColumnDateTime(
      'timestamp',
      this,
    );
  }

  late final ModerationLogUpdateTable updateTable;

  late final _is.ColumnInt communityId;

  late final _is.ColumnInt authorProfileId;

  late final _is.ColumnString authorEmail;

  late final _is.ColumnString postTitle;

  late final _is.ColumnString contentSnippet;

  late final _is.ColumnString matchedRule;

  late final _is.ColumnString reason;

  late final _is.ColumnBool isBlocked;

  late final _is.ColumnDateTime timestamp;

  @override
  List<_is.Column> get columns => [
        id,
        communityId,
        authorProfileId,
        authorEmail,
        postTitle,
        contentSnippet,
        matchedRule,
        reason,
        isBlocked,
        timestamp,
      ];
}

class ModerationLogInclude extends _is.IncludeObject {
  ModerationLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ModerationLog.t;
}

class ModerationLogIncludeList extends _is.IncludeList {
  ModerationLogIncludeList._({
    _is.WhereExpressionBuilder<ModerationLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ModerationLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ModerationLog.t;
}

class ModerationLogRepository {
  const ModerationLogRepository._();

  /// Returns a list of [ModerationLog]s matching the given query parameters.
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
  Future<List<ModerationLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModerationLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModerationLogTable>? orderBy,
    _is.OrderByListBuilder<ModerationLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ModerationLog>(
      where: where?.call(ModerationLog.t),
      orderBy: orderBy?.call(ModerationLog.t),
      orderByList: orderByList?.call(ModerationLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ModerationLog] matching the given query parameters.
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
  Future<ModerationLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModerationLogTable>? where,
    int? offset,
    _is.OrderByBuilder<ModerationLogTable>? orderBy,
    _is.OrderByListBuilder<ModerationLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ModerationLog>(
      where: where?.call(ModerationLog.t),
      orderBy: orderBy?.call(ModerationLog.t),
      orderByList: orderByList?.call(ModerationLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ModerationLog] by its [id] or null if no such row exists.
  Future<ModerationLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ModerationLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ModerationLog]s in the list and returns the inserted rows.
  ///
  /// The returned [ModerationLog]s will have their `id` fields set.
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
  Future<List<ModerationLog>> insert(
    _is.DatabaseSession session,
    List<ModerationLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ModerationLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ModerationLog] and returns the inserted row.
  ///
  /// The returned [ModerationLog] will have its `id` field set.
  Future<ModerationLog> insertRow(
    _is.DatabaseSession session,
    ModerationLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ModerationLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ModerationLog]s in the list and returns the resulting rows.
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
  /// The returned [ModerationLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModerationLog>> upsert(
    _is.DatabaseSession session,
    List<ModerationLog> rows, {
    required _is.ColumnSelections<ModerationLogTable> conflictColumns,
    _is.ColumnSelections<ModerationLogTable>? updateColumns,
    _is.WhereExpressionBuilder<ModerationLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ModerationLog>(
      rows,
      conflictColumns: conflictColumns(ModerationLog.t),
      updateColumns: updateColumns?.call(ModerationLog.t),
      updateWhere: updateWhere?.call(ModerationLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ModerationLog] and returns the resulting row.
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
  /// The returned [ModerationLog] will have its `id` field set.
  Future<ModerationLog?> upsertRow(
    _is.DatabaseSession session,
    ModerationLog row, {
    required _is.ColumnSelections<ModerationLogTable> conflictColumns,
    _is.ColumnSelections<ModerationLogTable>? updateColumns,
    _is.WhereExpressionBuilder<ModerationLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ModerationLog>(
      row,
      conflictColumns: conflictColumns(ModerationLog.t),
      updateColumns: updateColumns?.call(ModerationLog.t),
      updateWhere: updateWhere?.call(ModerationLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [ModerationLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModerationLog>> update(
    _is.DatabaseSession session,
    List<ModerationLog> rows, {
    _is.ColumnSelections<ModerationLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ModerationLog>(
      rows,
      columns: columns?.call(ModerationLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ModerationLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ModerationLog> updateRow(
    _is.DatabaseSession session,
    ModerationLog row, {
    _is.ColumnSelections<ModerationLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ModerationLog>(
      row,
      columns: columns?.call(ModerationLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ModerationLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ModerationLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ModerationLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ModerationLog>(
      id,
      columnValues: columnValues(ModerationLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ModerationLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModerationLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ModerationLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ModerationLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModerationLogTable>? orderBy,
    _is.OrderByListBuilder<ModerationLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ModerationLog>(
      columnValues: columnValues(ModerationLog.t.updateTable),
      where: where(ModerationLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModerationLog.t),
      orderByList: orderByList?.call(ModerationLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ModerationLog]s in the list and returns the deleted rows.
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
  Future<List<ModerationLog>> delete(
    _is.DatabaseSession session,
    List<ModerationLog> rows, {
    _is.OrderByBuilder<ModerationLogTable>? orderBy,
    _is.OrderByListBuilder<ModerationLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ModerationLog>(
      rows,
      orderBy: orderBy?.call(ModerationLog.t),
      orderByList: orderByList?.call(ModerationLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ModerationLog].
  Future<ModerationLog> deleteRow(
    _is.DatabaseSession session,
    ModerationLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ModerationLog>(
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
  Future<List<ModerationLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ModerationLogTable> where,
    _is.OrderByBuilder<ModerationLogTable>? orderBy,
    _is.OrderByListBuilder<ModerationLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ModerationLog>(
      where: where(ModerationLog.t),
      orderBy: orderBy?.call(ModerationLog.t),
      orderByList: orderByList?.call(ModerationLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModerationLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ModerationLog>(
      where: where?.call(ModerationLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ModerationLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ModerationLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ModerationLog>(
      where: where(ModerationLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
