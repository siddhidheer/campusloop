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

abstract class StudentProfile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StudentProfile._({
    this.id,
    required this.displayName,
    required this.email,
    this.department,
    this.year,
    this.bio,
    required this.studySubjects,
    required this.interests,
    this.role,
    this.canCreateCommunity,
    this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentProfile({
    int? id,
    required String displayName,
    required String email,
    String? department,
    int? year,
    String? bio,
    required List<String> studySubjects,
    required List<String> interests,
    String? role,
    bool? canCreateCommunity,
    bool? isEmailVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudentProfileImpl;

  factory StudentProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentProfile(
      id: jsonSerialization['id'] as int?,
      displayName: jsonSerialization['displayName'] as String,
      email: jsonSerialization['email'] as String,
      department: jsonSerialization['department'] as String?,
      year: jsonSerialization['year'] as int?,
      bio: jsonSerialization['bio'] as String?,
      studySubjects: _isg3825n.Protocol()
          .deserialize<List<String>>(jsonSerialization['studySubjects']),
      interests: _isg3825n.Protocol()
          .deserialize<List<String>>(jsonSerialization['interests']),
      role: jsonSerialization['role'] as String?,
      canCreateCommunity: jsonSerialization['canCreateCommunity'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['canCreateCommunity']),
      isEmailVerified: jsonSerialization['isEmailVerified'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isEmailVerified']),
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = StudentProfileTable();

  static const db = StudentProfileRepository._();

  @override
  int? id;

  String displayName;

  String email;

  String? department;

  int? year;

  String? bio;

  List<String> studySubjects;

  List<String> interests;

  String? role;

  bool? canCreateCommunity;

  bool? isEmailVerified;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StudentProfile copyWith({
    int? id,
    String? displayName,
    String? email,
    String? department,
    int? year,
    String? bio,
    List<String>? studySubjects,
    List<String>? interests,
    String? role,
    bool? canCreateCommunity,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentProfile',
      if (id != null) 'id': id,
      'displayName': displayName,
      'email': email,
      if (department != null) 'department': department,
      if (year != null) 'year': year,
      if (bio != null) 'bio': bio,
      'studySubjects': studySubjects.toJson(),
      'interests': interests.toJson(),
      if (role != null) 'role': role,
      if (canCreateCommunity != null) 'canCreateCommunity': canCreateCommunity,
      if (isEmailVerified != null) 'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentProfile',
      if (id != null) 'id': id,
      'displayName': displayName,
      'email': email,
      if (department != null) 'department': department,
      if (year != null) 'year': year,
      if (bio != null) 'bio': bio,
      'studySubjects': studySubjects.toJson(),
      'interests': interests.toJson(),
      if (role != null) 'role': role,
      if (canCreateCommunity != null) 'canCreateCommunity': canCreateCommunity,
      if (isEmailVerified != null) 'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static StudentProfileInclude include() {
    return StudentProfileInclude._();
  }

  static StudentProfileIncludeList includeList({
    _is.WhereExpressionBuilder<StudentProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StudentProfileTable>? orderBy,
    _is.OrderByListBuilder<StudentProfileTable>? orderByList,
    StudentProfileInclude? include,
  }) {
    return StudentProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentProfileImpl extends StudentProfile {
  _StudentProfileImpl({
    int? id,
    required String displayName,
    required String email,
    String? department,
    int? year,
    String? bio,
    required List<String> studySubjects,
    required List<String> interests,
    String? role,
    bool? canCreateCommunity,
    bool? isEmailVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          displayName: displayName,
          email: email,
          department: department,
          year: year,
          bio: bio,
          studySubjects: studySubjects,
          interests: interests,
          role: role,
          canCreateCommunity: canCreateCommunity,
          isEmailVerified: isEmailVerified,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StudentProfile copyWith({
    Object? id = _Undefined,
    String? displayName,
    String? email,
    Object? department = _Undefined,
    Object? year = _Undefined,
    Object? bio = _Undefined,
    List<String>? studySubjects,
    List<String>? interests,
    Object? role = _Undefined,
    Object? canCreateCommunity = _Undefined,
    Object? isEmailVerified = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentProfile(
      id: id is int? ? id : this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      department: department is String? ? department : this.department,
      year: year is int? ? year : this.year,
      bio: bio is String? ? bio : this.bio,
      studySubjects:
          studySubjects ?? this.studySubjects.map((e0) => e0).toList(),
      interests: interests ?? this.interests.map((e0) => e0).toList(),
      role: role is String? ? role : this.role,
      canCreateCommunity: canCreateCommunity is bool?
          ? canCreateCommunity
          : this.canCreateCommunity,
      isEmailVerified:
          isEmailVerified is bool? ? isEmailVerified : this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class StudentProfileUpdateTable extends _is.UpdateTable<StudentProfileTable> {
  StudentProfileUpdateTable(super.table);

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
        table.displayName,
        value,
      );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
        table.email,
        value,
      );

  _is.ColumnValue<String, String> department(String? value) => _is.ColumnValue(
        table.department,
        value,
      );

  _is.ColumnValue<int, int> year(int? value) => _is.ColumnValue(
        table.year,
        value,
      );

  _is.ColumnValue<String, String> bio(String? value) => _is.ColumnValue(
        table.bio,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> studySubjects(
          List<String> value) =>
      _is.ColumnValue(
        table.studySubjects,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> interests(List<String> value) =>
      _is.ColumnValue(
        table.interests,
        value,
      );

  _is.ColumnValue<String, String> role(String? value) => _is.ColumnValue(
        table.role,
        value,
      );

  _is.ColumnValue<bool, bool> canCreateCommunity(bool? value) =>
      _is.ColumnValue(
        table.canCreateCommunity,
        value,
      );

  _is.ColumnValue<bool, bool> isEmailVerified(bool? value) => _is.ColumnValue(
        table.isEmailVerified,
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

class StudentProfileTable extends _is.Table<int?> {
  StudentProfileTable({super.tableRelation})
      : super(tableName: 'student_profile') {
    updateTable = StudentProfileUpdateTable(this);
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    department = _is.ColumnString(
      'department',
      this,
    );
    year = _is.ColumnInt(
      'year',
      this,
    );
    bio = _is.ColumnString(
      'bio',
      this,
    );
    studySubjects = _is.ColumnSerializable<List<String>>(
      'studySubjects',
      this,
    );
    interests = _is.ColumnSerializable<List<String>>(
      'interests',
      this,
    );
    role = _is.ColumnString(
      'role',
      this,
    );
    canCreateCommunity = _is.ColumnBool(
      'canCreateCommunity',
      this,
    );
    isEmailVerified = _is.ColumnBool(
      'isEmailVerified',
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

  late final StudentProfileUpdateTable updateTable;

  late final _is.ColumnString displayName;

  late final _is.ColumnString email;

  late final _is.ColumnString department;

  late final _is.ColumnInt year;

  late final _is.ColumnString bio;

  late final _is.ColumnSerializable<List<String>> studySubjects;

  late final _is.ColumnSerializable<List<String>> interests;

  late final _is.ColumnString role;

  late final _is.ColumnBool canCreateCommunity;

  late final _is.ColumnBool isEmailVerified;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
        id,
        displayName,
        email,
        department,
        year,
        bio,
        studySubjects,
        interests,
        role,
        canCreateCommunity,
        isEmailVerified,
        createdAt,
        updatedAt,
      ];
}

class StudentProfileInclude extends _is.IncludeObject {
  StudentProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StudentProfile.t;
}

class StudentProfileIncludeList extends _is.IncludeList {
  StudentProfileIncludeList._({
    _is.WhereExpressionBuilder<StudentProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StudentProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StudentProfile.t;
}

class StudentProfileRepository {
  const StudentProfileRepository._();

  /// Returns a list of [StudentProfile]s matching the given query parameters.
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
  Future<List<StudentProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StudentProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StudentProfileTable>? orderBy,
    _is.OrderByListBuilder<StudentProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StudentProfile>(
      where: where?.call(StudentProfile.t),
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StudentProfile] matching the given query parameters.
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
  Future<StudentProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StudentProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<StudentProfileTable>? orderBy,
    _is.OrderByListBuilder<StudentProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StudentProfile>(
      where: where?.call(StudentProfile.t),
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StudentProfile] by its [id] or null if no such row exists.
  Future<StudentProfile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StudentProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StudentProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [StudentProfile]s will have their `id` fields set.
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
  Future<List<StudentProfile>> insert(
    _is.DatabaseSession session,
    List<StudentProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StudentProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StudentProfile] and returns the inserted row.
  ///
  /// The returned [StudentProfile] will have its `id` field set.
  Future<StudentProfile> insertRow(
    _is.DatabaseSession session,
    StudentProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StudentProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StudentProfile]s in the list and returns the resulting rows.
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
  /// The returned [StudentProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudentProfile>> upsert(
    _is.DatabaseSession session,
    List<StudentProfile> rows, {
    required _is.ColumnSelections<StudentProfileTable> conflictColumns,
    _is.ColumnSelections<StudentProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<StudentProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StudentProfile>(
      rows,
      conflictColumns: conflictColumns(StudentProfile.t),
      updateColumns: updateColumns?.call(StudentProfile.t),
      updateWhere: updateWhere?.call(StudentProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StudentProfile] and returns the resulting row.
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
  /// The returned [StudentProfile] will have its `id` field set.
  Future<StudentProfile?> upsertRow(
    _is.DatabaseSession session,
    StudentProfile row, {
    required _is.ColumnSelections<StudentProfileTable> conflictColumns,
    _is.ColumnSelections<StudentProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<StudentProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StudentProfile>(
      row,
      conflictColumns: conflictColumns(StudentProfile.t),
      updateColumns: updateColumns?.call(StudentProfile.t),
      updateWhere: updateWhere?.call(StudentProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [StudentProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudentProfile>> update(
    _is.DatabaseSession session,
    List<StudentProfile> rows, {
    _is.ColumnSelections<StudentProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StudentProfile>(
      rows,
      columns: columns?.call(StudentProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StudentProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StudentProfile> updateRow(
    _is.DatabaseSession session,
    StudentProfile row, {
    _is.ColumnSelections<StudentProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StudentProfile>(
      row,
      columns: columns?.call(StudentProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StudentProfile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StudentProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StudentProfile>(
      id,
      columnValues: columnValues(StudentProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StudentProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StudentProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StudentProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StudentProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StudentProfileTable>? orderBy,
    _is.OrderByListBuilder<StudentProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StudentProfile>(
      columnValues: columnValues(StudentProfile.t.updateTable),
      where: where(StudentProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StudentProfile]s in the list and returns the deleted rows.
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
  Future<List<StudentProfile>> delete(
    _is.DatabaseSession session,
    List<StudentProfile> rows, {
    _is.OrderByBuilder<StudentProfileTable>? orderBy,
    _is.OrderByListBuilder<StudentProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StudentProfile>(
      rows,
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StudentProfile].
  Future<StudentProfile> deleteRow(
    _is.DatabaseSession session,
    StudentProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StudentProfile>(
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
  Future<List<StudentProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StudentProfileTable> where,
    _is.OrderByBuilder<StudentProfileTable>? orderBy,
    _is.OrderByListBuilder<StudentProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StudentProfile>(
      where: where(StudentProfile.t),
      orderBy: orderBy?.call(StudentProfile.t),
      orderByList: orderByList?.call(StudentProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StudentProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StudentProfile>(
      where: where?.call(StudentProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StudentProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StudentProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StudentProfile>(
      where: where(StudentProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
