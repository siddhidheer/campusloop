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

abstract class EmailVerificationOtp
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EmailVerificationOtp._({
    this.id,
    required this.email,
    required this.otpHash,
    required this.salt,
    required this.attempts,
    required this.isUsed,
    required this.createdAt,
    required this.expiresAt,
    required this.lastSentAt,
  });

  factory EmailVerificationOtp({
    int? id,
    required String email,
    required String otpHash,
    required String salt,
    required int attempts,
    required bool isUsed,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSentAt,
  }) = _EmailVerificationOtpImpl;

  factory EmailVerificationOtp.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailVerificationOtp(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      otpHash: jsonSerialization['otpHash'] as String,
      salt: jsonSerialization['salt'] as String,
      attempts: jsonSerialization['attempts'] as int,
      isUsed: _is.BoolJsonExtension.fromJson(jsonSerialization['isUsed']),
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      lastSentAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSentAt']),
    );
  }

  static final t = EmailVerificationOtpTable();

  static const db = EmailVerificationOtpRepository._();

  @override
  int? id;

  String email;

  String otpHash;

  String salt;

  int attempts;

  bool isUsed;

  DateTime createdAt;

  DateTime expiresAt;

  DateTime lastSentAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmailVerificationOtp]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmailVerificationOtp copyWith({
    int? id,
    String? email,
    String? otpHash,
    String? salt,
    int? attempts,
    bool? isUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSentAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailVerificationOtp',
      if (id != null) 'id': id,
      'email': email,
      'otpHash': otpHash,
      'salt': salt,
      'attempts': attempts,
      'isUsed': isUsed,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSentAt': lastSentAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmailVerificationOtp',
      if (id != null) 'id': id,
      'email': email,
      'otpHash': otpHash,
      'salt': salt,
      'attempts': attempts,
      'isUsed': isUsed,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSentAt': lastSentAt.toJson(),
    };
  }

  static EmailVerificationOtpInclude include() {
    return EmailVerificationOtpInclude._();
  }

  static EmailVerificationOtpIncludeList includeList({
    _is.WhereExpressionBuilder<EmailVerificationOtpTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailVerificationOtpTable>? orderBy,
    _is.OrderByListBuilder<EmailVerificationOtpTable>? orderByList,
    EmailVerificationOtpInclude? include,
  }) {
    return EmailVerificationOtpIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailVerificationOtp.t),
      orderByList: orderByList?.call(EmailVerificationOtp.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailVerificationOtpImpl extends EmailVerificationOtp {
  _EmailVerificationOtpImpl({
    int? id,
    required String email,
    required String otpHash,
    required String salt,
    required int attempts,
    required bool isUsed,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSentAt,
  }) : super._(
          id: id,
          email: email,
          otpHash: otpHash,
          salt: salt,
          attempts: attempts,
          isUsed: isUsed,
          createdAt: createdAt,
          expiresAt: expiresAt,
          lastSentAt: lastSentAt,
        );

  /// Returns a shallow copy of this [EmailVerificationOtp]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmailVerificationOtp copyWith({
    Object? id = _Undefined,
    String? email,
    String? otpHash,
    String? salt,
    int? attempts,
    bool? isUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSentAt,
  }) {
    return EmailVerificationOtp(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      otpHash: otpHash ?? this.otpHash,
      salt: salt ?? this.salt,
      attempts: attempts ?? this.attempts,
      isUsed: isUsed ?? this.isUsed,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastSentAt: lastSentAt ?? this.lastSentAt,
    );
  }
}

class EmailVerificationOtpUpdateTable
    extends _is.UpdateTable<EmailVerificationOtpTable> {
  EmailVerificationOtpUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
        table.email,
        value,
      );

  _is.ColumnValue<String, String> otpHash(String value) => _is.ColumnValue(
        table.otpHash,
        value,
      );

  _is.ColumnValue<String, String> salt(String value) => _is.ColumnValue(
        table.salt,
        value,
      );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
        table.attempts,
        value,
      );

  _is.ColumnValue<bool, bool> isUsed(bool value) => _is.ColumnValue(
        table.isUsed,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastSentAt(DateTime value) =>
      _is.ColumnValue(
        table.lastSentAt,
        value,
      );
}

class EmailVerificationOtpTable extends _is.Table<int?> {
  EmailVerificationOtpTable({super.tableRelation})
      : super(tableName: 'email_verification_otp') {
    updateTable = EmailVerificationOtpUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    otpHash = _is.ColumnString(
      'otpHash',
      this,
    );
    salt = _is.ColumnString(
      'salt',
      this,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
    );
    isUsed = _is.ColumnBool(
      'isUsed',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    lastSentAt = _is.ColumnDateTime(
      'lastSentAt',
      this,
    );
  }

  late final EmailVerificationOtpUpdateTable updateTable;

  late final _is.ColumnString email;

  late final _is.ColumnString otpHash;

  late final _is.ColumnString salt;

  late final _is.ColumnInt attempts;

  late final _is.ColumnBool isUsed;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime lastSentAt;

  @override
  List<_is.Column> get columns => [
        id,
        email,
        otpHash,
        salt,
        attempts,
        isUsed,
        createdAt,
        expiresAt,
        lastSentAt,
      ];
}

class EmailVerificationOtpInclude extends _is.IncludeObject {
  EmailVerificationOtpInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmailVerificationOtp.t;
}

class EmailVerificationOtpIncludeList extends _is.IncludeList {
  EmailVerificationOtpIncludeList._({
    _is.WhereExpressionBuilder<EmailVerificationOtpTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailVerificationOtp.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmailVerificationOtp.t;
}

class EmailVerificationOtpRepository {
  const EmailVerificationOtpRepository._();

  /// Returns a list of [EmailVerificationOtp]s matching the given query parameters.
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
  Future<List<EmailVerificationOtp>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailVerificationOtpTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailVerificationOtpTable>? orderBy,
    _is.OrderByListBuilder<EmailVerificationOtpTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmailVerificationOtp>(
      where: where?.call(EmailVerificationOtp.t),
      orderBy: orderBy?.call(EmailVerificationOtp.t),
      orderByList: orderByList?.call(EmailVerificationOtp.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmailVerificationOtp] matching the given query parameters.
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
  Future<EmailVerificationOtp?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailVerificationOtpTable>? where,
    int? offset,
    _is.OrderByBuilder<EmailVerificationOtpTable>? orderBy,
    _is.OrderByListBuilder<EmailVerificationOtpTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmailVerificationOtp>(
      where: where?.call(EmailVerificationOtp.t),
      orderBy: orderBy?.call(EmailVerificationOtp.t),
      orderByList: orderByList?.call(EmailVerificationOtp.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmailVerificationOtp] by its [id] or null if no such row exists.
  Future<EmailVerificationOtp?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmailVerificationOtp>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmailVerificationOtp]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailVerificationOtp]s will have their `id` fields set.
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
  Future<List<EmailVerificationOtp>> insert(
    _is.DatabaseSession session,
    List<EmailVerificationOtp> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmailVerificationOtp>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmailVerificationOtp] and returns the inserted row.
  ///
  /// The returned [EmailVerificationOtp] will have its `id` field set.
  Future<EmailVerificationOtp> insertRow(
    _is.DatabaseSession session,
    EmailVerificationOtp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailVerificationOtp>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmailVerificationOtp]s in the list and returns the resulting rows.
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
  /// The returned [EmailVerificationOtp]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailVerificationOtp>> upsert(
    _is.DatabaseSession session,
    List<EmailVerificationOtp> rows, {
    required _is.ColumnSelections<EmailVerificationOtpTable> conflictColumns,
    _is.ColumnSelections<EmailVerificationOtpTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailVerificationOtpTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmailVerificationOtp>(
      rows,
      conflictColumns: conflictColumns(EmailVerificationOtp.t),
      updateColumns: updateColumns?.call(EmailVerificationOtp.t),
      updateWhere: updateWhere?.call(EmailVerificationOtp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmailVerificationOtp] and returns the resulting row.
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
  /// The returned [EmailVerificationOtp] will have its `id` field set.
  Future<EmailVerificationOtp?> upsertRow(
    _is.DatabaseSession session,
    EmailVerificationOtp row, {
    required _is.ColumnSelections<EmailVerificationOtpTable> conflictColumns,
    _is.ColumnSelections<EmailVerificationOtpTable>? updateColumns,
    _is.WhereExpressionBuilder<EmailVerificationOtpTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmailVerificationOtp>(
      row,
      conflictColumns: conflictColumns(EmailVerificationOtp.t),
      updateColumns: updateColumns?.call(EmailVerificationOtp.t),
      updateWhere: updateWhere?.call(EmailVerificationOtp.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmailVerificationOtp]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailVerificationOtp>> update(
    _is.DatabaseSession session,
    List<EmailVerificationOtp> rows, {
    _is.ColumnSelections<EmailVerificationOtpTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmailVerificationOtp>(
      rows,
      columns: columns?.call(EmailVerificationOtp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmailVerificationOtp]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailVerificationOtp> updateRow(
    _is.DatabaseSession session,
    EmailVerificationOtp row, {
    _is.ColumnSelections<EmailVerificationOtpTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailVerificationOtp>(
      row,
      columns: columns?.call(EmailVerificationOtp.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailVerificationOtp] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailVerificationOtp?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EmailVerificationOtpUpdateTable>
        columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailVerificationOtp>(
      id,
      columnValues: columnValues(EmailVerificationOtp.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailVerificationOtp]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmailVerificationOtp>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmailVerificationOtpUpdateTable>
        columnValues,
    required _is.WhereExpressionBuilder<EmailVerificationOtpTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmailVerificationOtpTable>? orderBy,
    _is.OrderByListBuilder<EmailVerificationOtpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmailVerificationOtp>(
      columnValues: columnValues(EmailVerificationOtp.t.updateTable),
      where: where(EmailVerificationOtp.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailVerificationOtp.t),
      orderByList: orderByList?.call(EmailVerificationOtp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmailVerificationOtp]s in the list and returns the deleted rows.
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
  Future<List<EmailVerificationOtp>> delete(
    _is.DatabaseSession session,
    List<EmailVerificationOtp> rows, {
    _is.OrderByBuilder<EmailVerificationOtpTable>? orderBy,
    _is.OrderByListBuilder<EmailVerificationOtpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmailVerificationOtp>(
      rows,
      orderBy: orderBy?.call(EmailVerificationOtp.t),
      orderByList: orderByList?.call(EmailVerificationOtp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmailVerificationOtp].
  Future<EmailVerificationOtp> deleteRow(
    _is.DatabaseSession session,
    EmailVerificationOtp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailVerificationOtp>(
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
  Future<List<EmailVerificationOtp>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailVerificationOtpTable> where,
    _is.OrderByBuilder<EmailVerificationOtpTable>? orderBy,
    _is.OrderByListBuilder<EmailVerificationOtpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmailVerificationOtp>(
      where: where(EmailVerificationOtp.t),
      orderBy: orderBy?.call(EmailVerificationOtp.t),
      orderByList: orderByList?.call(EmailVerificationOtp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmailVerificationOtpTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmailVerificationOtp>(
      where: where?.call(EmailVerificationOtp.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmailVerificationOtp] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmailVerificationOtpTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmailVerificationOtp>(
      where: where(EmailVerificationOtp.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
