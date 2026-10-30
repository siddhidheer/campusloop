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

abstract class SpamKeywordRule
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SpamKeywordRule._({
    this.id,
    required this.pattern,
    required this.category,
    required this.severity,
    required this.isEnabled,
    required this.createdAt,
  });

  factory SpamKeywordRule({
    int? id,
    required String pattern,
    required String category,
    required String severity,
    required bool isEnabled,
    required DateTime createdAt,
  }) = _SpamKeywordRuleImpl;

  factory SpamKeywordRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpamKeywordRule(
      id: jsonSerialization['id'] as int?,
      pattern: jsonSerialization['pattern'] as String,
      category: jsonSerialization['category'] as String,
      severity: jsonSerialization['severity'] as String,
      isEnabled: _is.BoolJsonExtension.fromJson(jsonSerialization['isEnabled']),
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SpamKeywordRuleTable();

  static const db = SpamKeywordRuleRepository._();

  @override
  int? id;

  String pattern;

  String category;

  String severity;

  bool isEnabled;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SpamKeywordRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SpamKeywordRule copyWith({
    int? id,
    String? pattern,
    String? category,
    String? severity,
    bool? isEnabled,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpamKeywordRule',
      if (id != null) 'id': id,
      'pattern': pattern,
      'category': category,
      'severity': severity,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SpamKeywordRule',
      if (id != null) 'id': id,
      'pattern': pattern,
      'category': category,
      'severity': severity,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toJson(),
    };
  }

  static SpamKeywordRuleInclude include() {
    return SpamKeywordRuleInclude._();
  }

  static SpamKeywordRuleIncludeList includeList({
    _is.WhereExpressionBuilder<SpamKeywordRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SpamKeywordRuleTable>? orderBy,
    _is.OrderByListBuilder<SpamKeywordRuleTable>? orderByList,
    SpamKeywordRuleInclude? include,
  }) {
    return SpamKeywordRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SpamKeywordRule.t),
      orderByList: orderByList?.call(SpamKeywordRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SpamKeywordRuleImpl extends SpamKeywordRule {
  _SpamKeywordRuleImpl({
    int? id,
    required String pattern,
    required String category,
    required String severity,
    required bool isEnabled,
    required DateTime createdAt,
  }) : super._(
          id: id,
          pattern: pattern,
          category: category,
          severity: severity,
          isEnabled: isEnabled,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [SpamKeywordRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SpamKeywordRule copyWith({
    Object? id = _Undefined,
    String? pattern,
    String? category,
    String? severity,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return SpamKeywordRule(
      id: id is int? ? id : this.id,
      pattern: pattern ?? this.pattern,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SpamKeywordRuleUpdateTable extends _is.UpdateTable<SpamKeywordRuleTable> {
  SpamKeywordRuleUpdateTable(super.table);

  _is.ColumnValue<String, String> pattern(String value) => _is.ColumnValue(
        table.pattern,
        value,
      );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
        table.category,
        value,
      );

  _is.ColumnValue<String, String> severity(String value) => _is.ColumnValue(
        table.severity,
        value,
      );

  _is.ColumnValue<bool, bool> isEnabled(bool value) => _is.ColumnValue(
        table.isEnabled,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SpamKeywordRuleTable extends _is.Table<int?> {
  SpamKeywordRuleTable({super.tableRelation})
      : super(tableName: 'spam_keyword_rule') {
    updateTable = SpamKeywordRuleUpdateTable(this);
    pattern = _is.ColumnString(
      'pattern',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    severity = _is.ColumnString(
      'severity',
      this,
    );
    isEnabled = _is.ColumnBool(
      'isEnabled',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final SpamKeywordRuleUpdateTable updateTable;

  late final _is.ColumnString pattern;

  late final _is.ColumnString category;

  late final _is.ColumnString severity;

  late final _is.ColumnBool isEnabled;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
        id,
        pattern,
        category,
        severity,
        isEnabled,
        createdAt,
      ];
}

class SpamKeywordRuleInclude extends _is.IncludeObject {
  SpamKeywordRuleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SpamKeywordRule.t;
}

class SpamKeywordRuleIncludeList extends _is.IncludeList {
  SpamKeywordRuleIncludeList._({
    _is.WhereExpressionBuilder<SpamKeywordRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SpamKeywordRule.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SpamKeywordRule.t;
}

class SpamKeywordRuleRepository {
  const SpamKeywordRuleRepository._();

  /// Returns a list of [SpamKeywordRule]s matching the given query parameters.
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
  Future<List<SpamKeywordRule>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SpamKeywordRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SpamKeywordRuleTable>? orderBy,
    _is.OrderByListBuilder<SpamKeywordRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SpamKeywordRule>(
      where: where?.call(SpamKeywordRule.t),
      orderBy: orderBy?.call(SpamKeywordRule.t),
      orderByList: orderByList?.call(SpamKeywordRule.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SpamKeywordRule] matching the given query parameters.
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
  Future<SpamKeywordRule?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SpamKeywordRuleTable>? where,
    int? offset,
    _is.OrderByBuilder<SpamKeywordRuleTable>? orderBy,
    _is.OrderByListBuilder<SpamKeywordRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SpamKeywordRule>(
      where: where?.call(SpamKeywordRule.t),
      orderBy: orderBy?.call(SpamKeywordRule.t),
      orderByList: orderByList?.call(SpamKeywordRule.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SpamKeywordRule] by its [id] or null if no such row exists.
  Future<SpamKeywordRule?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SpamKeywordRule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SpamKeywordRule]s in the list and returns the inserted rows.
  ///
  /// The returned [SpamKeywordRule]s will have their `id` fields set.
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
  Future<List<SpamKeywordRule>> insert(
    _is.DatabaseSession session,
    List<SpamKeywordRule> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SpamKeywordRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SpamKeywordRule] and returns the inserted row.
  ///
  /// The returned [SpamKeywordRule] will have its `id` field set.
  Future<SpamKeywordRule> insertRow(
    _is.DatabaseSession session,
    SpamKeywordRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SpamKeywordRule>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SpamKeywordRule]s in the list and returns the resulting rows.
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
  /// The returned [SpamKeywordRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SpamKeywordRule>> upsert(
    _is.DatabaseSession session,
    List<SpamKeywordRule> rows, {
    required _is.ColumnSelections<SpamKeywordRuleTable> conflictColumns,
    _is.ColumnSelections<SpamKeywordRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<SpamKeywordRuleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SpamKeywordRule>(
      rows,
      conflictColumns: conflictColumns(SpamKeywordRule.t),
      updateColumns: updateColumns?.call(SpamKeywordRule.t),
      updateWhere: updateWhere?.call(SpamKeywordRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SpamKeywordRule] and returns the resulting row.
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
  /// The returned [SpamKeywordRule] will have its `id` field set.
  Future<SpamKeywordRule?> upsertRow(
    _is.DatabaseSession session,
    SpamKeywordRule row, {
    required _is.ColumnSelections<SpamKeywordRuleTable> conflictColumns,
    _is.ColumnSelections<SpamKeywordRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<SpamKeywordRuleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SpamKeywordRule>(
      row,
      conflictColumns: conflictColumns(SpamKeywordRule.t),
      updateColumns: updateColumns?.call(SpamKeywordRule.t),
      updateWhere: updateWhere?.call(SpamKeywordRule.t),
      transaction: transaction,
    );
  }

  /// Updates all [SpamKeywordRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SpamKeywordRule>> update(
    _is.DatabaseSession session,
    List<SpamKeywordRule> rows, {
    _is.ColumnSelections<SpamKeywordRuleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SpamKeywordRule>(
      rows,
      columns: columns?.call(SpamKeywordRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SpamKeywordRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SpamKeywordRule> updateRow(
    _is.DatabaseSession session,
    SpamKeywordRule row, {
    _is.ColumnSelections<SpamKeywordRuleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SpamKeywordRule>(
      row,
      columns: columns?.call(SpamKeywordRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SpamKeywordRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SpamKeywordRule?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SpamKeywordRuleUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SpamKeywordRule>(
      id,
      columnValues: columnValues(SpamKeywordRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SpamKeywordRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SpamKeywordRule>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SpamKeywordRuleUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<SpamKeywordRuleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SpamKeywordRuleTable>? orderBy,
    _is.OrderByListBuilder<SpamKeywordRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SpamKeywordRule>(
      columnValues: columnValues(SpamKeywordRule.t.updateTable),
      where: where(SpamKeywordRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SpamKeywordRule.t),
      orderByList: orderByList?.call(SpamKeywordRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SpamKeywordRule]s in the list and returns the deleted rows.
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
  Future<List<SpamKeywordRule>> delete(
    _is.DatabaseSession session,
    List<SpamKeywordRule> rows, {
    _is.OrderByBuilder<SpamKeywordRuleTable>? orderBy,
    _is.OrderByListBuilder<SpamKeywordRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SpamKeywordRule>(
      rows,
      orderBy: orderBy?.call(SpamKeywordRule.t),
      orderByList: orderByList?.call(SpamKeywordRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SpamKeywordRule].
  Future<SpamKeywordRule> deleteRow(
    _is.DatabaseSession session,
    SpamKeywordRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SpamKeywordRule>(
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
  Future<List<SpamKeywordRule>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SpamKeywordRuleTable> where,
    _is.OrderByBuilder<SpamKeywordRuleTable>? orderBy,
    _is.OrderByListBuilder<SpamKeywordRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SpamKeywordRule>(
      where: where(SpamKeywordRule.t),
      orderBy: orderBy?.call(SpamKeywordRule.t),
      orderByList: orderByList?.call(SpamKeywordRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SpamKeywordRuleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SpamKeywordRule>(
      where: where?.call(SpamKeywordRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SpamKeywordRule] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SpamKeywordRuleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SpamKeywordRule>(
      where: where(SpamKeywordRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
