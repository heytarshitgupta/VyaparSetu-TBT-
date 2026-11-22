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
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;

abstract class RequirementResponse
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RequirementResponse._({
    this.id,
    required this.requirementId,
    required this.producerProfileId,
    required this.message,
    this.quotedPaise,
    String? status,
    required this.createdAt,
  }) : status = status ?? 'responded';

  factory RequirementResponse({
    int? id,
    required int requirementId,
    required int producerProfileId,
    required String message,
    int? quotedPaise,
    String? status,
    required DateTime createdAt,
  }) = _RequirementResponseImpl;

  factory RequirementResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return RequirementResponse(
      id: jsonSerialization['id'] as int?,
      requirementId: jsonSerialization['requirementId'] as int,
      producerProfileId: jsonSerialization['producerProfileId'] as int,
      message: jsonSerialization['message'] as String,
      quotedPaise: jsonSerialization['quotedPaise'] as int?,
      status: jsonSerialization['status'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RequirementResponseTable();

  static const db = RequirementResponseRepository._();

  @override
  int? id;

  int requirementId;

  int producerProfileId;

  String message;

  int? quotedPaise;

  String status;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RequirementResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RequirementResponse copyWith({
    int? id,
    int? requirementId,
    int? producerProfileId,
    String? message,
    int? quotedPaise,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RequirementResponse',
      if (id != null) 'id': id,
      'requirementId': requirementId,
      'producerProfileId': producerProfileId,
      'message': message,
      if (quotedPaise != null) 'quotedPaise': quotedPaise,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RequirementResponse',
      if (id != null) 'id': id,
      'requirementId': requirementId,
      'producerProfileId': producerProfileId,
      'message': message,
      if (quotedPaise != null) 'quotedPaise': quotedPaise,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  static RequirementResponseInclude include() {
    return RequirementResponseInclude._();
  }

  static RequirementResponseIncludeList includeList({
    _is.WhereExpressionBuilder<RequirementResponseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RequirementResponseTable>? orderBy,
    _is.OrderByListBuilder<RequirementResponseTable>? orderByList,
    RequirementResponseInclude? include,
  }) {
    return RequirementResponseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RequirementResponse.t),
      orderByList: orderByList?.call(RequirementResponse.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RequirementResponseImpl extends RequirementResponse {
  _RequirementResponseImpl({
    int? id,
    required int requirementId,
    required int producerProfileId,
    required String message,
    int? quotedPaise,
    String? status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         requirementId: requirementId,
         producerProfileId: producerProfileId,
         message: message,
         quotedPaise: quotedPaise,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RequirementResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RequirementResponse copyWith({
    Object? id = _Undefined,
    int? requirementId,
    int? producerProfileId,
    String? message,
    Object? quotedPaise = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return RequirementResponse(
      id: id is int? ? id : this.id,
      requirementId: requirementId ?? this.requirementId,
      producerProfileId: producerProfileId ?? this.producerProfileId,
      message: message ?? this.message,
      quotedPaise: quotedPaise is int? ? quotedPaise : this.quotedPaise,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RequirementResponseUpdateTable
    extends _is.UpdateTable<RequirementResponseTable> {
  RequirementResponseUpdateTable(super.table);

  _is.ColumnValue<int, int> requirementId(int value) => _is.ColumnValue(
    table.requirementId,
    value,
  );

  _is.ColumnValue<int, int> producerProfileId(int value) => _is.ColumnValue(
    table.producerProfileId,
    value,
  );

  _is.ColumnValue<String, String> message(String value) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<int, int> quotedPaise(int? value) => _is.ColumnValue(
    table.quotedPaise,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RequirementResponseTable extends _is.Table<int?> {
  RequirementResponseTable({super.tableRelation})
    : super(tableName: 'requirement_response') {
    updateTable = RequirementResponseUpdateTable(this);
    requirementId = _is.ColumnInt(
      'requirementId',
      this,
    );
    producerProfileId = _is.ColumnInt(
      'producerProfileId',
      this,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    quotedPaise = _is.ColumnInt(
      'quotedPaise',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RequirementResponseUpdateTable updateTable;

  late final _is.ColumnInt requirementId;

  late final _is.ColumnInt producerProfileId;

  late final _is.ColumnString message;

  late final _is.ColumnInt quotedPaise;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    requirementId,
    producerProfileId,
    message,
    quotedPaise,
    status,
    createdAt,
  ];
}

class RequirementResponseInclude extends _is.IncludeObject {
  RequirementResponseInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RequirementResponse.t;
}

class RequirementResponseIncludeList extends _is.IncludeList {
  RequirementResponseIncludeList._({
    _is.WhereExpressionBuilder<RequirementResponseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RequirementResponse.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RequirementResponse.t;
}

class RequirementResponseRepository {
  const RequirementResponseRepository._();

  /// Returns a list of [RequirementResponse]s matching the given query parameters.
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
  Future<List<RequirementResponse>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RequirementResponseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RequirementResponseTable>? orderBy,
    _is.OrderByListBuilder<RequirementResponseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RequirementResponse>(
      where: where?.call(RequirementResponse.t),
      orderBy: orderBy?.call(RequirementResponse.t),
      orderByList: orderByList?.call(RequirementResponse.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [RequirementResponse]s matching the given query parameters every time the
  /// source tables are modified.
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
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `RequirementResponse.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<RequirementResponse>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RequirementResponseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RequirementResponseTable>? orderBy,
    _is.OrderByListBuilder<RequirementResponseTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<RequirementResponse>(
      where: where?.call(RequirementResponse.t),
      orderBy: orderBy?.call(RequirementResponse.t),
      orderByList: orderByList?.call(RequirementResponse.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [RequirementResponse] matching the given query parameters.
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
  Future<RequirementResponse?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RequirementResponseTable>? where,
    int? offset,
    _is.OrderByBuilder<RequirementResponseTable>? orderBy,
    _is.OrderByListBuilder<RequirementResponseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RequirementResponse>(
      where: where?.call(RequirementResponse.t),
      orderBy: orderBy?.call(RequirementResponse.t),
      orderByList: orderByList?.call(RequirementResponse.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RequirementResponse] by its [id] or null if no such row exists.
  Future<RequirementResponse?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RequirementResponse>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RequirementResponse]s in the list and returns the inserted rows.
  ///
  /// The returned [RequirementResponse]s will have their `id` fields set.
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
  Future<List<RequirementResponse>> insert(
    _is.DatabaseSession session,
    List<RequirementResponse> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RequirementResponse>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RequirementResponse] and returns the inserted row.
  ///
  /// The returned [RequirementResponse] will have its `id` field set.
  Future<RequirementResponse> insertRow(
    _is.DatabaseSession session,
    RequirementResponse row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RequirementResponse>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RequirementResponse]s in the list and returns the resulting rows.
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
  /// The returned [RequirementResponse]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RequirementResponse>> upsert(
    _is.DatabaseSession session,
    List<RequirementResponse> rows, {
    required _is.ColumnSelections<RequirementResponseTable> conflictColumns,
    _is.ColumnSelections<RequirementResponseTable>? updateColumns,
    _is.WhereExpressionBuilder<RequirementResponseTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RequirementResponse>(
      rows,
      conflictColumns: conflictColumns(RequirementResponse.t),
      updateColumns: updateColumns?.call(RequirementResponse.t),
      updateWhere: updateWhere?.call(RequirementResponse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RequirementResponse] and returns the resulting row.
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
  /// The returned [RequirementResponse] will have its `id` field set.
  Future<RequirementResponse?> upsertRow(
    _is.DatabaseSession session,
    RequirementResponse row, {
    required _is.ColumnSelections<RequirementResponseTable> conflictColumns,
    _is.ColumnSelections<RequirementResponseTable>? updateColumns,
    _is.WhereExpressionBuilder<RequirementResponseTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RequirementResponse>(
      row,
      conflictColumns: conflictColumns(RequirementResponse.t),
      updateColumns: updateColumns?.call(RequirementResponse.t),
      updateWhere: updateWhere?.call(RequirementResponse.t),
      transaction: transaction,
    );
  }

  /// Updates all [RequirementResponse]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RequirementResponse>> update(
    _is.DatabaseSession session,
    List<RequirementResponse> rows, {
    _is.ColumnSelections<RequirementResponseTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RequirementResponse>(
      rows,
      columns: columns?.call(RequirementResponse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RequirementResponse]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RequirementResponse> updateRow(
    _is.DatabaseSession session,
    RequirementResponse row, {
    _is.ColumnSelections<RequirementResponseTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RequirementResponse>(
      row,
      columns: columns?.call(RequirementResponse.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RequirementResponse] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RequirementResponse?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RequirementResponseUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RequirementResponse>(
      id,
      columnValues: columnValues(RequirementResponse.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RequirementResponse]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RequirementResponse>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RequirementResponseUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<RequirementResponseTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RequirementResponseTable>? orderBy,
    _is.OrderByListBuilder<RequirementResponseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RequirementResponse>(
      columnValues: columnValues(RequirementResponse.t.updateTable),
      where: where(RequirementResponse.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RequirementResponse.t),
      orderByList: orderByList?.call(RequirementResponse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RequirementResponse]s in the list and returns the deleted rows.
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
  Future<List<RequirementResponse>> delete(
    _is.DatabaseSession session,
    List<RequirementResponse> rows, {
    _is.OrderByBuilder<RequirementResponseTable>? orderBy,
    _is.OrderByListBuilder<RequirementResponseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RequirementResponse>(
      rows,
      orderBy: orderBy?.call(RequirementResponse.t),
      orderByList: orderByList?.call(RequirementResponse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RequirementResponse].
  Future<RequirementResponse> deleteRow(
    _is.DatabaseSession session,
    RequirementResponse row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RequirementResponse>(
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
  Future<List<RequirementResponse>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RequirementResponseTable> where,
    _is.OrderByBuilder<RequirementResponseTable>? orderBy,
    _is.OrderByListBuilder<RequirementResponseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RequirementResponse>(
      where: where(RequirementResponse.t),
      orderBy: orderBy?.call(RequirementResponse.t),
      orderByList: orderByList?.call(RequirementResponse.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RequirementResponseTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RequirementResponse>(
      where: where?.call(RequirementResponse.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RequirementResponse] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RequirementResponseTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RequirementResponse>(
      where: where(RequirementResponse.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
