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

abstract class CommunityMembership
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CommunityMembership._({
    this.id,
    required this.communityId,
    required this.profileId,
    required this.role,
    required this.joinedAt,
  });

  factory CommunityMembership({
    int? id,
    required int communityId,
    required int profileId,
    required String role,
    required DateTime joinedAt,
  }) = _CommunityMembershipImpl;

  factory CommunityMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityMembership(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      role: jsonSerialization['role'] as String,
      joinedAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = CommunityMembershipTable();

  static const db = CommunityMembershipRepository._();

  @override
  int? id;

  int communityId;

  int profileId;

  String role;

  DateTime joinedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CommunityMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CommunityMembership copyWith({
    int? id,
    int? communityId,
    int? profileId,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommunityMembership',
      if (id != null) 'id': id,
      'communityId': communityId,
      'profileId': profileId,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommunityMembership',
      if (id != null) 'id': id,
      'communityId': communityId,
      'profileId': profileId,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  static CommunityMembershipInclude include() {
    return CommunityMembershipInclude._();
  }

  static CommunityMembershipIncludeList includeList({
    _is.WhereExpressionBuilder<CommunityMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityMembershipTable>? orderBy,
    _is.OrderByListBuilder<CommunityMembershipTable>? orderByList,
    CommunityMembershipInclude? include,
  }) {
    return CommunityMembershipIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommunityMembership.t),
      orderByList: orderByList?.call(CommunityMembership.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommunityMembershipImpl extends CommunityMembership {
  _CommunityMembershipImpl({
    int? id,
    required int communityId,
    required int profileId,
    required String role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          communityId: communityId,
          profileId: profileId,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [CommunityMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CommunityMembership copyWith({
    Object? id = _Undefined,
    int? communityId,
    int? profileId,
    String? role,
    DateTime? joinedAt,
  }) {
    return CommunityMembership(
      id: id is int? ? id : this.id,
      communityId: communityId ?? this.communityId,
      profileId: profileId ?? this.profileId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class CommunityMembershipUpdateTable
    extends _is.UpdateTable<CommunityMembershipTable> {
  CommunityMembershipUpdateTable(super.table);

  _is.ColumnValue<int, int> communityId(int value) => _is.ColumnValue(
        table.communityId,
        value,
      );

  _is.ColumnValue<int, int> profileId(int value) => _is.ColumnValue(
        table.profileId,
        value,
      );

  _is.ColumnValue<String, String> role(String value) => _is.ColumnValue(
        table.role,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _is.ColumnValue(
        table.joinedAt,
        value,
      );
}

class CommunityMembershipTable extends _is.Table<int?> {
  CommunityMembershipTable({super.tableRelation})
      : super(tableName: 'community_membership') {
    updateTable = CommunityMembershipUpdateTable(this);
    communityId = _is.ColumnInt(
      'communityId',
      this,
    );
    profileId = _is.ColumnInt(
      'profileId',
      this,
    );
    role = _is.ColumnString(
      'role',
      this,
    );
    joinedAt = _is.ColumnDateTime(
      'joinedAt',
      this,
    );
  }

  late final CommunityMembershipUpdateTable updateTable;

  late final _is.ColumnInt communityId;

  late final _is.ColumnInt profileId;

  late final _is.ColumnString role;

  late final _is.ColumnDateTime joinedAt;

  @override
  List<_is.Column> get columns => [
        id,
        communityId,
        profileId,
        role,
        joinedAt,
      ];
}

class CommunityMembershipInclude extends _is.IncludeObject {
  CommunityMembershipInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CommunityMembership.t;
}

class CommunityMembershipIncludeList extends _is.IncludeList {
  CommunityMembershipIncludeList._({
    _is.WhereExpressionBuilder<CommunityMembershipTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CommunityMembership.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CommunityMembership.t;
}

class CommunityMembershipRepository {
  const CommunityMembershipRepository._();

  /// Returns a list of [CommunityMembership]s matching the given query parameters.
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
  Future<List<CommunityMembership>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityMembershipTable>? orderBy,
    _is.OrderByListBuilder<CommunityMembershipTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CommunityMembership>(
      where: where?.call(CommunityMembership.t),
      orderBy: orderBy?.call(CommunityMembership.t),
      orderByList: orderByList?.call(CommunityMembership.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CommunityMembership] matching the given query parameters.
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
  Future<CommunityMembership?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityMembershipTable>? where,
    int? offset,
    _is.OrderByBuilder<CommunityMembershipTable>? orderBy,
    _is.OrderByListBuilder<CommunityMembershipTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CommunityMembership>(
      where: where?.call(CommunityMembership.t),
      orderBy: orderBy?.call(CommunityMembership.t),
      orderByList: orderByList?.call(CommunityMembership.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CommunityMembership] by its [id] or null if no such row exists.
  Future<CommunityMembership?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CommunityMembership>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CommunityMembership]s in the list and returns the inserted rows.
  ///
  /// The returned [CommunityMembership]s will have their `id` fields set.
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
  Future<List<CommunityMembership>> insert(
    _is.DatabaseSession session,
    List<CommunityMembership> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CommunityMembership>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CommunityMembership] and returns the inserted row.
  ///
  /// The returned [CommunityMembership] will have its `id` field set.
  Future<CommunityMembership> insertRow(
    _is.DatabaseSession session,
    CommunityMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CommunityMembership>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CommunityMembership]s in the list and returns the resulting rows.
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
  /// The returned [CommunityMembership]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityMembership>> upsert(
    _is.DatabaseSession session,
    List<CommunityMembership> rows, {
    required _is.ColumnSelections<CommunityMembershipTable> conflictColumns,
    _is.ColumnSelections<CommunityMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<CommunityMembershipTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CommunityMembership>(
      rows,
      conflictColumns: conflictColumns(CommunityMembership.t),
      updateColumns: updateColumns?.call(CommunityMembership.t),
      updateWhere: updateWhere?.call(CommunityMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CommunityMembership] and returns the resulting row.
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
  /// The returned [CommunityMembership] will have its `id` field set.
  Future<CommunityMembership?> upsertRow(
    _is.DatabaseSession session,
    CommunityMembership row, {
    required _is.ColumnSelections<CommunityMembershipTable> conflictColumns,
    _is.ColumnSelections<CommunityMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<CommunityMembershipTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CommunityMembership>(
      row,
      conflictColumns: conflictColumns(CommunityMembership.t),
      updateColumns: updateColumns?.call(CommunityMembership.t),
      updateWhere: updateWhere?.call(CommunityMembership.t),
      transaction: transaction,
    );
  }

  /// Updates all [CommunityMembership]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityMembership>> update(
    _is.DatabaseSession session,
    List<CommunityMembership> rows, {
    _is.ColumnSelections<CommunityMembershipTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CommunityMembership>(
      rows,
      columns: columns?.call(CommunityMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CommunityMembership]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CommunityMembership> updateRow(
    _is.DatabaseSession session,
    CommunityMembership row, {
    _is.ColumnSelections<CommunityMembershipTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CommunityMembership>(
      row,
      columns: columns?.call(CommunityMembership.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CommunityMembership] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CommunityMembership?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CommunityMembershipUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CommunityMembership>(
      id,
      columnValues: columnValues(CommunityMembership.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CommunityMembership]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityMembership>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CommunityMembershipUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<CommunityMembershipTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityMembershipTable>? orderBy,
    _is.OrderByListBuilder<CommunityMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CommunityMembership>(
      columnValues: columnValues(CommunityMembership.t.updateTable),
      where: where(CommunityMembership.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommunityMembership.t),
      orderByList: orderByList?.call(CommunityMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CommunityMembership]s in the list and returns the deleted rows.
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
  Future<List<CommunityMembership>> delete(
    _is.DatabaseSession session,
    List<CommunityMembership> rows, {
    _is.OrderByBuilder<CommunityMembershipTable>? orderBy,
    _is.OrderByListBuilder<CommunityMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CommunityMembership>(
      rows,
      orderBy: orderBy?.call(CommunityMembership.t),
      orderByList: orderByList?.call(CommunityMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CommunityMembership].
  Future<CommunityMembership> deleteRow(
    _is.DatabaseSession session,
    CommunityMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CommunityMembership>(
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
  Future<List<CommunityMembership>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommunityMembershipTable> where,
    _is.OrderByBuilder<CommunityMembershipTable>? orderBy,
    _is.OrderByListBuilder<CommunityMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CommunityMembership>(
      where: where(CommunityMembership.t),
      orderBy: orderBy?.call(CommunityMembership.t),
      orderByList: orderByList?.call(CommunityMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityMembershipTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CommunityMembership>(
      where: where?.call(CommunityMembership.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CommunityMembership] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommunityMembershipTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CommunityMembership>(
      where: where(CommunityMembership.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
