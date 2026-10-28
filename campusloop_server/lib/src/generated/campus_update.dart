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

abstract class CampusUpdate
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CampusUpdate._({
    this.id,
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

  factory CampusUpdate({
    int? id,
    required String title,
    required String content,
    required String category,
    required int authorProfileId,
    required String priority,
    required bool isPublished,
    DateTime? publishedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CampusUpdateImpl;

  factory CampusUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusUpdate(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      category: jsonSerialization['category'] as String,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      priority: jsonSerialization['priority'] as String,
      isPublished:
          _is.BoolJsonExtension.fromJson(jsonSerialization['isPublished']),
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedAt']),
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CampusUpdateTable();

  static const db = CampusUpdateRepository._();

  @override
  int? id;

  String title;

  String content;

  String category;

  int authorProfileId;

  String priority;

  bool isPublished;

  DateTime? publishedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CampusUpdate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampusUpdate',
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorProfileId': authorProfileId,
      'priority': priority,
      'isPublished': isPublished,
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampusUpdate',
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorProfileId': authorProfileId,
      'priority': priority,
      'isPublished': isPublished,
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CampusUpdateInclude include() {
    return CampusUpdateInclude._();
  }

  static CampusUpdateIncludeList includeList({
    _is.WhereExpressionBuilder<CampusUpdateTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusUpdateTable>? orderBy,
    _is.OrderByListBuilder<CampusUpdateTable>? orderByList,
    CampusUpdateInclude? include,
  }) {
    return CampusUpdateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampusUpdate.t),
      orderByList: orderByList?.call(CampusUpdate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampusUpdateImpl extends CampusUpdate {
  _CampusUpdateImpl({
    int? id,
    required String title,
    required String content,
    required String category,
    required int authorProfileId,
    required String priority,
    required bool isPublished,
    DateTime? publishedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          title: title,
          content: content,
          category: category,
          authorProfileId: authorProfileId,
          priority: priority,
          isPublished: isPublished,
          publishedAt: publishedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [CampusUpdate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CampusUpdate copyWith({
    Object? id = _Undefined,
    String? title,
    String? content,
    String? category,
    int? authorProfileId,
    String? priority,
    bool? isPublished,
    Object? publishedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampusUpdate(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      priority: priority ?? this.priority,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt is DateTime? ? publishedAt : this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CampusUpdateUpdateTable extends _is.UpdateTable<CampusUpdateTable> {
  CampusUpdateUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
        table.title,
        value,
      );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
        table.content,
        value,
      );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
        table.category,
        value,
      );

  _is.ColumnValue<int, int> authorProfileId(int value) => _is.ColumnValue(
        table.authorProfileId,
        value,
      );

  _is.ColumnValue<String, String> priority(String value) => _is.ColumnValue(
        table.priority,
        value,
      );

  _is.ColumnValue<bool, bool> isPublished(bool value) => _is.ColumnValue(
        table.isPublished,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> publishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.publishedAt,
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

class CampusUpdateTable extends _is.Table<int?> {
  CampusUpdateTable({super.tableRelation}) : super(tableName: 'campus_update') {
    updateTable = CampusUpdateUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    authorProfileId = _is.ColumnInt(
      'authorProfileId',
      this,
    );
    priority = _is.ColumnString(
      'priority',
      this,
    );
    isPublished = _is.ColumnBool(
      'isPublished',
      this,
    );
    publishedAt = _is.ColumnDateTime(
      'publishedAt',
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

  late final CampusUpdateUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnString content;

  late final _is.ColumnString category;

  late final _is.ColumnInt authorProfileId;

  late final _is.ColumnString priority;

  late final _is.ColumnBool isPublished;

  late final _is.ColumnDateTime publishedAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
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

class CampusUpdateInclude extends _is.IncludeObject {
  CampusUpdateInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CampusUpdate.t;
}

class CampusUpdateIncludeList extends _is.IncludeList {
  CampusUpdateIncludeList._({
    _is.WhereExpressionBuilder<CampusUpdateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CampusUpdate.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CampusUpdate.t;
}

class CampusUpdateRepository {
  const CampusUpdateRepository._();

  /// Returns a list of [CampusUpdate]s matching the given query parameters.
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
  Future<List<CampusUpdate>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusUpdateTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusUpdateTable>? orderBy,
    _is.OrderByListBuilder<CampusUpdateTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CampusUpdate>(
      where: where?.call(CampusUpdate.t),
      orderBy: orderBy?.call(CampusUpdate.t),
      orderByList: orderByList?.call(CampusUpdate.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CampusUpdate] matching the given query parameters.
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
  Future<CampusUpdate?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusUpdateTable>? where,
    int? offset,
    _is.OrderByBuilder<CampusUpdateTable>? orderBy,
    _is.OrderByListBuilder<CampusUpdateTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CampusUpdate>(
      where: where?.call(CampusUpdate.t),
      orderBy: orderBy?.call(CampusUpdate.t),
      orderByList: orderByList?.call(CampusUpdate.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CampusUpdate] by its [id] or null if no such row exists.
  Future<CampusUpdate?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CampusUpdate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CampusUpdate]s in the list and returns the inserted rows.
  ///
  /// The returned [CampusUpdate]s will have their `id` fields set.
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
  Future<List<CampusUpdate>> insert(
    _is.DatabaseSession session,
    List<CampusUpdate> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CampusUpdate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CampusUpdate] and returns the inserted row.
  ///
  /// The returned [CampusUpdate] will have its `id` field set.
  Future<CampusUpdate> insertRow(
    _is.DatabaseSession session,
    CampusUpdate row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CampusUpdate>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CampusUpdate]s in the list and returns the resulting rows.
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
  /// The returned [CampusUpdate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusUpdate>> upsert(
    _is.DatabaseSession session,
    List<CampusUpdate> rows, {
    required _is.ColumnSelections<CampusUpdateTable> conflictColumns,
    _is.ColumnSelections<CampusUpdateTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusUpdateTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CampusUpdate>(
      rows,
      conflictColumns: conflictColumns(CampusUpdate.t),
      updateColumns: updateColumns?.call(CampusUpdate.t),
      updateWhere: updateWhere?.call(CampusUpdate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CampusUpdate] and returns the resulting row.
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
  /// The returned [CampusUpdate] will have its `id` field set.
  Future<CampusUpdate?> upsertRow(
    _is.DatabaseSession session,
    CampusUpdate row, {
    required _is.ColumnSelections<CampusUpdateTable> conflictColumns,
    _is.ColumnSelections<CampusUpdateTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusUpdateTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CampusUpdate>(
      row,
      conflictColumns: conflictColumns(CampusUpdate.t),
      updateColumns: updateColumns?.call(CampusUpdate.t),
      updateWhere: updateWhere?.call(CampusUpdate.t),
      transaction: transaction,
    );
  }

  /// Updates all [CampusUpdate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusUpdate>> update(
    _is.DatabaseSession session,
    List<CampusUpdate> rows, {
    _is.ColumnSelections<CampusUpdateTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CampusUpdate>(
      rows,
      columns: columns?.call(CampusUpdate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CampusUpdate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CampusUpdate> updateRow(
    _is.DatabaseSession session,
    CampusUpdate row, {
    _is.ColumnSelections<CampusUpdateTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CampusUpdate>(
      row,
      columns: columns?.call(CampusUpdate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CampusUpdate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CampusUpdate?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CampusUpdateUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CampusUpdate>(
      id,
      columnValues: columnValues(CampusUpdate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CampusUpdate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusUpdate>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CampusUpdateUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CampusUpdateTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusUpdateTable>? orderBy,
    _is.OrderByListBuilder<CampusUpdateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CampusUpdate>(
      columnValues: columnValues(CampusUpdate.t.updateTable),
      where: where(CampusUpdate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampusUpdate.t),
      orderByList: orderByList?.call(CampusUpdate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CampusUpdate]s in the list and returns the deleted rows.
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
  Future<List<CampusUpdate>> delete(
    _is.DatabaseSession session,
    List<CampusUpdate> rows, {
    _is.OrderByBuilder<CampusUpdateTable>? orderBy,
    _is.OrderByListBuilder<CampusUpdateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CampusUpdate>(
      rows,
      orderBy: orderBy?.call(CampusUpdate.t),
      orderByList: orderByList?.call(CampusUpdate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CampusUpdate].
  Future<CampusUpdate> deleteRow(
    _is.DatabaseSession session,
    CampusUpdate row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CampusUpdate>(
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
  Future<List<CampusUpdate>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusUpdateTable> where,
    _is.OrderByBuilder<CampusUpdateTable>? orderBy,
    _is.OrderByListBuilder<CampusUpdateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CampusUpdate>(
      where: where(CampusUpdate.t),
      orderBy: orderBy?.call(CampusUpdate.t),
      orderByList: orderByList?.call(CampusUpdate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusUpdateTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CampusUpdate>(
      where: where?.call(CampusUpdate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CampusUpdate] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusUpdateTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CampusUpdate>(
      where: where(CampusUpdate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
