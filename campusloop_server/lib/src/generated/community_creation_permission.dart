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

abstract class CommunityCreationPermission
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CommunityCreationPermission._({
    this.id,
    required this.email,
    required this.profileId,
    required this.grantedByEmail,
    required this.grantedByProfileId,
    required this.grantedAt,
    this.revokedAt,
    required this.isActive,
  });

  factory CommunityCreationPermission({
    int? id,
    required String email,
    required int profileId,
    required String grantedByEmail,
    required int grantedByProfileId,
    required DateTime grantedAt,
    DateTime? revokedAt,
    required bool isActive,
  }) = _CommunityCreationPermissionImpl;

  factory CommunityCreationPermission.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CommunityCreationPermission(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      profileId: jsonSerialization['profileId'] as int,
      grantedByEmail: jsonSerialization['grantedByEmail'] as String,
      grantedByProfileId: jsonSerialization['grantedByProfileId'] as int,
      grantedAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['grantedAt']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  static final t = CommunityCreationPermissionTable();

  static const db = CommunityCreationPermissionRepository._();

  @override
  int? id;

  String email;

  int profileId;

  String grantedByEmail;

  int grantedByProfileId;

  DateTime grantedAt;

  DateTime? revokedAt;

  bool isActive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CommunityCreationPermission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CommunityCreationPermission copyWith({
    int? id,
    String? email,
    int? profileId,
    String? grantedByEmail,
    int? grantedByProfileId,
    DateTime? grantedAt,
    DateTime? revokedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommunityCreationPermission',
      if (id != null) 'id': id,
      'email': email,
      'profileId': profileId,
      'grantedByEmail': grantedByEmail,
      'grantedByProfileId': grantedByProfileId,
      'grantedAt': grantedAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommunityCreationPermission',
      if (id != null) 'id': id,
      'email': email,
      'profileId': profileId,
      'grantedByEmail': grantedByEmail,
      'grantedByProfileId': grantedByProfileId,
      'grantedAt': grantedAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'isActive': isActive,
    };
  }

  static CommunityCreationPermissionInclude include() {
    return CommunityCreationPermissionInclude._();
  }

  static CommunityCreationPermissionIncludeList includeList({
    _is.WhereExpressionBuilder<CommunityCreationPermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityCreationPermissionTable>? orderBy,
    _is.OrderByListBuilder<CommunityCreationPermissionTable>? orderByList,
    CommunityCreationPermissionInclude? include,
  }) {
    return CommunityCreationPermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommunityCreationPermission.t),
      orderByList: orderByList?.call(CommunityCreationPermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommunityCreationPermissionImpl extends CommunityCreationPermission {
  _CommunityCreationPermissionImpl({
    int? id,
    required String email,
    required int profileId,
    required String grantedByEmail,
    required int grantedByProfileId,
    required DateTime grantedAt,
    DateTime? revokedAt,
    required bool isActive,
  }) : super._(
          id: id,
          email: email,
          profileId: profileId,
          grantedByEmail: grantedByEmail,
          grantedByProfileId: grantedByProfileId,
          grantedAt: grantedAt,
          revokedAt: revokedAt,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [CommunityCreationPermission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CommunityCreationPermission copyWith({
    Object? id = _Undefined,
    String? email,
    int? profileId,
    String? grantedByEmail,
    int? grantedByProfileId,
    DateTime? grantedAt,
    Object? revokedAt = _Undefined,
    bool? isActive,
  }) {
    return CommunityCreationPermission(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      profileId: profileId ?? this.profileId,
      grantedByEmail: grantedByEmail ?? this.grantedByEmail,
      grantedByProfileId: grantedByProfileId ?? this.grantedByProfileId,
      grantedAt: grantedAt ?? this.grantedAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class CommunityCreationPermissionUpdateTable
    extends _is.UpdateTable<CommunityCreationPermissionTable> {
  CommunityCreationPermissionUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
        table.email,
        value,
      );

  _is.ColumnValue<int, int> profileId(int value) => _is.ColumnValue(
        table.profileId,
        value,
      );

  _is.ColumnValue<String, String> grantedByEmail(String value) =>
      _is.ColumnValue(
        table.grantedByEmail,
        value,
      );

  _is.ColumnValue<int, int> grantedByProfileId(int value) => _is.ColumnValue(
        table.grantedByProfileId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> grantedAt(DateTime value) =>
      _is.ColumnValue(
        table.grantedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> revokedAt(DateTime? value) =>
      _is.ColumnValue(
        table.revokedAt,
        value,
      );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
        table.isActive,
        value,
      );
}

class CommunityCreationPermissionTable extends _is.Table<int?> {
  CommunityCreationPermissionTable({super.tableRelation})
      : super(tableName: 'community_creation_permission') {
    updateTable = CommunityCreationPermissionUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    profileId = _is.ColumnInt(
      'profileId',
      this,
    );
    grantedByEmail = _is.ColumnString(
      'grantedByEmail',
      this,
    );
    grantedByProfileId = _is.ColumnInt(
      'grantedByProfileId',
      this,
    );
    grantedAt = _is.ColumnDateTime(
      'grantedAt',
      this,
    );
    revokedAt = _is.ColumnDateTime(
      'revokedAt',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
  }

  late final CommunityCreationPermissionUpdateTable updateTable;

  late final _is.ColumnString email;

  late final _is.ColumnInt profileId;

  late final _is.ColumnString grantedByEmail;

  late final _is.ColumnInt grantedByProfileId;

  late final _is.ColumnDateTime grantedAt;

  late final _is.ColumnDateTime revokedAt;

  late final _is.ColumnBool isActive;

  @override
  List<_is.Column> get columns => [
        id,
        email,
        profileId,
        grantedByEmail,
        grantedByProfileId,
        grantedAt,
        revokedAt,
        isActive,
      ];
}

class CommunityCreationPermissionInclude extends _is.IncludeObject {
  CommunityCreationPermissionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CommunityCreationPermission.t;
}

class CommunityCreationPermissionIncludeList extends _is.IncludeList {
  CommunityCreationPermissionIncludeList._({
    _is.WhereExpressionBuilder<CommunityCreationPermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CommunityCreationPermission.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CommunityCreationPermission.t;
}

class CommunityCreationPermissionRepository {
  const CommunityCreationPermissionRepository._();

  /// Returns a list of [CommunityCreationPermission]s matching the given query parameters.
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
  Future<List<CommunityCreationPermission>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityCreationPermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityCreationPermissionTable>? orderBy,
    _is.OrderByListBuilder<CommunityCreationPermissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CommunityCreationPermission>(
      where: where?.call(CommunityCreationPermission.t),
      orderBy: orderBy?.call(CommunityCreationPermission.t),
      orderByList: orderByList?.call(CommunityCreationPermission.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CommunityCreationPermission] matching the given query parameters.
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
  Future<CommunityCreationPermission?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityCreationPermissionTable>? where,
    int? offset,
    _is.OrderByBuilder<CommunityCreationPermissionTable>? orderBy,
    _is.OrderByListBuilder<CommunityCreationPermissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CommunityCreationPermission>(
      where: where?.call(CommunityCreationPermission.t),
      orderBy: orderBy?.call(CommunityCreationPermission.t),
      orderByList: orderByList?.call(CommunityCreationPermission.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CommunityCreationPermission] by its [id] or null if no such row exists.
  Future<CommunityCreationPermission?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CommunityCreationPermission>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CommunityCreationPermission]s in the list and returns the inserted rows.
  ///
  /// The returned [CommunityCreationPermission]s will have their `id` fields set.
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
  Future<List<CommunityCreationPermission>> insert(
    _is.DatabaseSession session,
    List<CommunityCreationPermission> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CommunityCreationPermission>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CommunityCreationPermission] and returns the inserted row.
  ///
  /// The returned [CommunityCreationPermission] will have its `id` field set.
  Future<CommunityCreationPermission> insertRow(
    _is.DatabaseSession session,
    CommunityCreationPermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CommunityCreationPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CommunityCreationPermission]s in the list and returns the resulting rows.
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
  /// The returned [CommunityCreationPermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityCreationPermission>> upsert(
    _is.DatabaseSession session,
    List<CommunityCreationPermission> rows, {
    required _is.ColumnSelections<CommunityCreationPermissionTable>
        conflictColumns,
    _is.ColumnSelections<CommunityCreationPermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<CommunityCreationPermissionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CommunityCreationPermission>(
      rows,
      conflictColumns: conflictColumns(CommunityCreationPermission.t),
      updateColumns: updateColumns?.call(CommunityCreationPermission.t),
      updateWhere: updateWhere?.call(CommunityCreationPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CommunityCreationPermission] and returns the resulting row.
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
  /// The returned [CommunityCreationPermission] will have its `id` field set.
  Future<CommunityCreationPermission?> upsertRow(
    _is.DatabaseSession session,
    CommunityCreationPermission row, {
    required _is.ColumnSelections<CommunityCreationPermissionTable>
        conflictColumns,
    _is.ColumnSelections<CommunityCreationPermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<CommunityCreationPermissionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CommunityCreationPermission>(
      row,
      conflictColumns: conflictColumns(CommunityCreationPermission.t),
      updateColumns: updateColumns?.call(CommunityCreationPermission.t),
      updateWhere: updateWhere?.call(CommunityCreationPermission.t),
      transaction: transaction,
    );
  }

  /// Updates all [CommunityCreationPermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityCreationPermission>> update(
    _is.DatabaseSession session,
    List<CommunityCreationPermission> rows, {
    _is.ColumnSelections<CommunityCreationPermissionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CommunityCreationPermission>(
      rows,
      columns: columns?.call(CommunityCreationPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CommunityCreationPermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CommunityCreationPermission> updateRow(
    _is.DatabaseSession session,
    CommunityCreationPermission row, {
    _is.ColumnSelections<CommunityCreationPermissionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CommunityCreationPermission>(
      row,
      columns: columns?.call(CommunityCreationPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CommunityCreationPermission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CommunityCreationPermission?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CommunityCreationPermissionUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CommunityCreationPermission>(
      id,
      columnValues: columnValues(CommunityCreationPermission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CommunityCreationPermission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityCreationPermission>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CommunityCreationPermissionUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<CommunityCreationPermissionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityCreationPermissionTable>? orderBy,
    _is.OrderByListBuilder<CommunityCreationPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CommunityCreationPermission>(
      columnValues: columnValues(CommunityCreationPermission.t.updateTable),
      where: where(CommunityCreationPermission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommunityCreationPermission.t),
      orderByList: orderByList?.call(CommunityCreationPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CommunityCreationPermission]s in the list and returns the deleted rows.
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
  Future<List<CommunityCreationPermission>> delete(
    _is.DatabaseSession session,
    List<CommunityCreationPermission> rows, {
    _is.OrderByBuilder<CommunityCreationPermissionTable>? orderBy,
    _is.OrderByListBuilder<CommunityCreationPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CommunityCreationPermission>(
      rows,
      orderBy: orderBy?.call(CommunityCreationPermission.t),
      orderByList: orderByList?.call(CommunityCreationPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CommunityCreationPermission].
  Future<CommunityCreationPermission> deleteRow(
    _is.DatabaseSession session,
    CommunityCreationPermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CommunityCreationPermission>(
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
  Future<List<CommunityCreationPermission>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommunityCreationPermissionTable> where,
    _is.OrderByBuilder<CommunityCreationPermissionTable>? orderBy,
    _is.OrderByListBuilder<CommunityCreationPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CommunityCreationPermission>(
      where: where(CommunityCreationPermission.t),
      orderBy: orderBy?.call(CommunityCreationPermission.t),
      orderByList: orderByList?.call(CommunityCreationPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityCreationPermissionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CommunityCreationPermission>(
      where: where?.call(CommunityCreationPermission.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CommunityCreationPermission] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommunityCreationPermissionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CommunityCreationPermission>(
      where: where(CommunityCreationPermission.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
