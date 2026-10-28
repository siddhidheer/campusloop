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

abstract class CampusEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CampusEvent._({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.venue,
    required this.organizer,
    required this.organizerProfileId,
    required this.dateTime,
    this.endDateTime,
    this.imageUrl,
    this.maxAttendees,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampusEvent({
    int? id,
    required String title,
    required String description,
    required String category,
    required String venue,
    required String organizer,
    required int organizerProfileId,
    required DateTime dateTime,
    DateTime? endDateTime,
    String? imageUrl,
    int? maxAttendees,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CampusEventImpl;

  factory CampusEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusEvent(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      venue: jsonSerialization['venue'] as String,
      organizer: jsonSerialization['organizer'] as String,
      organizerProfileId: jsonSerialization['organizerProfileId'] as int,
      dateTime:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['dateTime']),
      endDateTime: jsonSerialization['endDateTime'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['endDateTime']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      maxAttendees: jsonSerialization['maxAttendees'] as int?,
      createdAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CampusEventTable();

  static const db = CampusEventRepository._();

  @override
  int? id;

  String title;

  String description;

  String category;

  String venue;

  String organizer;

  int organizerProfileId;

  DateTime dateTime;

  DateTime? endDateTime;

  String? imageUrl;

  int? maxAttendees;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CampusEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CampusEvent copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? venue,
    String? organizer,
    int? organizerProfileId,
    DateTime? dateTime,
    DateTime? endDateTime,
    String? imageUrl,
    int? maxAttendees,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampusEvent',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'organizer': organizer,
      'organizerProfileId': organizerProfileId,
      'dateTime': dateTime.toJson(),
      if (endDateTime != null) 'endDateTime': endDateTime?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (maxAttendees != null) 'maxAttendees': maxAttendees,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampusEvent',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'organizer': organizer,
      'organizerProfileId': organizerProfileId,
      'dateTime': dateTime.toJson(),
      if (endDateTime != null) 'endDateTime': endDateTime?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (maxAttendees != null) 'maxAttendees': maxAttendees,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CampusEventInclude include() {
    return CampusEventInclude._();
  }

  static CampusEventIncludeList includeList({
    _is.WhereExpressionBuilder<CampusEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusEventTable>? orderBy,
    _is.OrderByListBuilder<CampusEventTable>? orderByList,
    CampusEventInclude? include,
  }) {
    return CampusEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampusEvent.t),
      orderByList: orderByList?.call(CampusEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampusEventImpl extends CampusEvent {
  _CampusEventImpl({
    int? id,
    required String title,
    required String description,
    required String category,
    required String venue,
    required String organizer,
    required int organizerProfileId,
    required DateTime dateTime,
    DateTime? endDateTime,
    String? imageUrl,
    int? maxAttendees,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          title: title,
          description: description,
          category: category,
          venue: venue,
          organizer: organizer,
          organizerProfileId: organizerProfileId,
          dateTime: dateTime,
          endDateTime: endDateTime,
          imageUrl: imageUrl,
          maxAttendees: maxAttendees,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [CampusEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CampusEvent copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    String? category,
    String? venue,
    String? organizer,
    int? organizerProfileId,
    DateTime? dateTime,
    Object? endDateTime = _Undefined,
    Object? imageUrl = _Undefined,
    Object? maxAttendees = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampusEvent(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      venue: venue ?? this.venue,
      organizer: organizer ?? this.organizer,
      organizerProfileId: organizerProfileId ?? this.organizerProfileId,
      dateTime: dateTime ?? this.dateTime,
      endDateTime: endDateTime is DateTime? ? endDateTime : this.endDateTime,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      maxAttendees: maxAttendees is int? ? maxAttendees : this.maxAttendees,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CampusEventUpdateTable extends _is.UpdateTable<CampusEventTable> {
  CampusEventUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
        table.title,
        value,
      );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
        table.description,
        value,
      );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
        table.category,
        value,
      );

  _is.ColumnValue<String, String> venue(String value) => _is.ColumnValue(
        table.venue,
        value,
      );

  _is.ColumnValue<String, String> organizer(String value) => _is.ColumnValue(
        table.organizer,
        value,
      );

  _is.ColumnValue<int, int> organizerProfileId(int value) => _is.ColumnValue(
        table.organizerProfileId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> dateTime(DateTime value) =>
      _is.ColumnValue(
        table.dateTime,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endDateTime(DateTime? value) =>
      _is.ColumnValue(
        table.endDateTime,
        value,
      );

  _is.ColumnValue<String, String> imageUrl(String? value) => _is.ColumnValue(
        table.imageUrl,
        value,
      );

  _is.ColumnValue<int, int> maxAttendees(int? value) => _is.ColumnValue(
        table.maxAttendees,
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

class CampusEventTable extends _is.Table<int?> {
  CampusEventTable({super.tableRelation}) : super(tableName: 'campus_event') {
    updateTable = CampusEventUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    venue = _is.ColumnString(
      'venue',
      this,
    );
    organizer = _is.ColumnString(
      'organizer',
      this,
    );
    organizerProfileId = _is.ColumnInt(
      'organizerProfileId',
      this,
    );
    dateTime = _is.ColumnDateTime(
      'dateTime',
      this,
    );
    endDateTime = _is.ColumnDateTime(
      'endDateTime',
      this,
    );
    imageUrl = _is.ColumnString(
      'imageUrl',
      this,
    );
    maxAttendees = _is.ColumnInt(
      'maxAttendees',
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

  late final CampusEventUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnString category;

  late final _is.ColumnString venue;

  late final _is.ColumnString organizer;

  late final _is.ColumnInt organizerProfileId;

  late final _is.ColumnDateTime dateTime;

  late final _is.ColumnDateTime endDateTime;

  late final _is.ColumnString imageUrl;

  late final _is.ColumnInt maxAttendees;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
        id,
        title,
        description,
        category,
        venue,
        organizer,
        organizerProfileId,
        dateTime,
        endDateTime,
        imageUrl,
        maxAttendees,
        createdAt,
        updatedAt,
      ];
}

class CampusEventInclude extends _is.IncludeObject {
  CampusEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CampusEvent.t;
}

class CampusEventIncludeList extends _is.IncludeList {
  CampusEventIncludeList._({
    _is.WhereExpressionBuilder<CampusEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CampusEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CampusEvent.t;
}

class CampusEventRepository {
  const CampusEventRepository._();

  /// Returns a list of [CampusEvent]s matching the given query parameters.
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
  Future<List<CampusEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusEventTable>? orderBy,
    _is.OrderByListBuilder<CampusEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CampusEvent>(
      where: where?.call(CampusEvent.t),
      orderBy: orderBy?.call(CampusEvent.t),
      orderByList: orderByList?.call(CampusEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CampusEvent] matching the given query parameters.
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
  Future<CampusEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusEventTable>? where,
    int? offset,
    _is.OrderByBuilder<CampusEventTable>? orderBy,
    _is.OrderByListBuilder<CampusEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CampusEvent>(
      where: where?.call(CampusEvent.t),
      orderBy: orderBy?.call(CampusEvent.t),
      orderByList: orderByList?.call(CampusEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CampusEvent] by its [id] or null if no such row exists.
  Future<CampusEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CampusEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CampusEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [CampusEvent]s will have their `id` fields set.
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
  Future<List<CampusEvent>> insert(
    _is.DatabaseSession session,
    List<CampusEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CampusEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CampusEvent] and returns the inserted row.
  ///
  /// The returned [CampusEvent] will have its `id` field set.
  Future<CampusEvent> insertRow(
    _is.DatabaseSession session,
    CampusEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CampusEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CampusEvent]s in the list and returns the resulting rows.
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
  /// The returned [CampusEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusEvent>> upsert(
    _is.DatabaseSession session,
    List<CampusEvent> rows, {
    required _is.ColumnSelections<CampusEventTable> conflictColumns,
    _is.ColumnSelections<CampusEventTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CampusEvent>(
      rows,
      conflictColumns: conflictColumns(CampusEvent.t),
      updateColumns: updateColumns?.call(CampusEvent.t),
      updateWhere: updateWhere?.call(CampusEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CampusEvent] and returns the resulting row.
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
  /// The returned [CampusEvent] will have its `id` field set.
  Future<CampusEvent?> upsertRow(
    _is.DatabaseSession session,
    CampusEvent row, {
    required _is.ColumnSelections<CampusEventTable> conflictColumns,
    _is.ColumnSelections<CampusEventTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CampusEvent>(
      row,
      conflictColumns: conflictColumns(CampusEvent.t),
      updateColumns: updateColumns?.call(CampusEvent.t),
      updateWhere: updateWhere?.call(CampusEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [CampusEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusEvent>> update(
    _is.DatabaseSession session,
    List<CampusEvent> rows, {
    _is.ColumnSelections<CampusEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CampusEvent>(
      rows,
      columns: columns?.call(CampusEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CampusEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CampusEvent> updateRow(
    _is.DatabaseSession session,
    CampusEvent row, {
    _is.ColumnSelections<CampusEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CampusEvent>(
      row,
      columns: columns?.call(CampusEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CampusEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CampusEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CampusEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CampusEvent>(
      id,
      columnValues: columnValues(CampusEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CampusEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CampusEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CampusEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusEventTable>? orderBy,
    _is.OrderByListBuilder<CampusEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CampusEvent>(
      columnValues: columnValues(CampusEvent.t.updateTable),
      where: where(CampusEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampusEvent.t),
      orderByList: orderByList?.call(CampusEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CampusEvent]s in the list and returns the deleted rows.
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
  Future<List<CampusEvent>> delete(
    _is.DatabaseSession session,
    List<CampusEvent> rows, {
    _is.OrderByBuilder<CampusEventTable>? orderBy,
    _is.OrderByListBuilder<CampusEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CampusEvent>(
      rows,
      orderBy: orderBy?.call(CampusEvent.t),
      orderByList: orderByList?.call(CampusEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CampusEvent].
  Future<CampusEvent> deleteRow(
    _is.DatabaseSession session,
    CampusEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CampusEvent>(
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
  Future<List<CampusEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusEventTable> where,
    _is.OrderByBuilder<CampusEventTable>? orderBy,
    _is.OrderByListBuilder<CampusEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CampusEvent>(
      where: where(CampusEvent.t),
      orderBy: orderBy?.call(CampusEvent.t),
      orderByList: orderByList?.call(CampusEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CampusEvent>(
      where: where?.call(CampusEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CampusEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CampusEvent>(
      where: where(CampusEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
