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
import 'trade_status.dart' as _ieevlvna;

abstract class TradeRequest
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TradeRequest._({
    this.id,
    required this.productId,
    required this.buyerProfileId,
    required this.producerProfileId,
    required this.productName,
    required this.quantity,
    required this.requirements,
    _ieevlvna.TradeStatus? status,
    this.totalPaise,
    required this.createdAt,
  }) : status = status ?? _ieevlvna.TradeStatus.requested;

  factory TradeRequest({
    int? id,
    required int productId,
    required int buyerProfileId,
    required int producerProfileId,
    required String productName,
    required int quantity,
    required String requirements,
    _ieevlvna.TradeStatus? status,
    int? totalPaise,
    required DateTime createdAt,
  }) = _TradeRequestImpl;

  factory TradeRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return TradeRequest(
      id: jsonSerialization['id'] as int?,
      productId: jsonSerialization['productId'] as int,
      buyerProfileId: jsonSerialization['buyerProfileId'] as int,
      producerProfileId: jsonSerialization['producerProfileId'] as int,
      productName: jsonSerialization['productName'] as String,
      quantity: jsonSerialization['quantity'] as int,
      requirements: jsonSerialization['requirements'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _ieevlvna.TradeStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      totalPaise: jsonSerialization['totalPaise'] as int?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TradeRequestTable();

  static const db = TradeRequestRepository._();

  @override
  int? id;

  int productId;

  int buyerProfileId;

  int producerProfileId;

  String productName;

  int quantity;

  String requirements;

  _ieevlvna.TradeStatus status;

  int? totalPaise;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TradeRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TradeRequest copyWith({
    int? id,
    int? productId,
    int? buyerProfileId,
    int? producerProfileId,
    String? productName,
    int? quantity,
    String? requirements,
    _ieevlvna.TradeStatus? status,
    int? totalPaise,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TradeRequest',
      if (id != null) 'id': id,
      'productId': productId,
      'buyerProfileId': buyerProfileId,
      'producerProfileId': producerProfileId,
      'productName': productName,
      'quantity': quantity,
      'requirements': requirements,
      'status': status.toJson(),
      if (totalPaise != null) 'totalPaise': totalPaise,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TradeRequest',
      if (id != null) 'id': id,
      'productId': productId,
      'buyerProfileId': buyerProfileId,
      'producerProfileId': producerProfileId,
      'productName': productName,
      'quantity': quantity,
      'requirements': requirements,
      'status': status.toJson(),
      if (totalPaise != null) 'totalPaise': totalPaise,
      'createdAt': createdAt.toJson(),
    };
  }

  static TradeRequestInclude include() {
    return TradeRequestInclude._();
  }

  static TradeRequestIncludeList includeList({
    _is.WhereExpressionBuilder<TradeRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TradeRequestTable>? orderBy,
    _is.OrderByListBuilder<TradeRequestTable>? orderByList,
    TradeRequestInclude? include,
  }) {
    return TradeRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TradeRequest.t),
      orderByList: orderByList?.call(TradeRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TradeRequestImpl extends TradeRequest {
  _TradeRequestImpl({
    int? id,
    required int productId,
    required int buyerProfileId,
    required int producerProfileId,
    required String productName,
    required int quantity,
    required String requirements,
    _ieevlvna.TradeStatus? status,
    int? totalPaise,
    required DateTime createdAt,
  }) : super._(
         id: id,
         productId: productId,
         buyerProfileId: buyerProfileId,
         producerProfileId: producerProfileId,
         productName: productName,
         quantity: quantity,
         requirements: requirements,
         status: status,
         totalPaise: totalPaise,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TradeRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TradeRequest copyWith({
    Object? id = _Undefined,
    int? productId,
    int? buyerProfileId,
    int? producerProfileId,
    String? productName,
    int? quantity,
    String? requirements,
    _ieevlvna.TradeStatus? status,
    Object? totalPaise = _Undefined,
    DateTime? createdAt,
  }) {
    return TradeRequest(
      id: id is int? ? id : this.id,
      productId: productId ?? this.productId,
      buyerProfileId: buyerProfileId ?? this.buyerProfileId,
      producerProfileId: producerProfileId ?? this.producerProfileId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      requirements: requirements ?? this.requirements,
      status: status ?? this.status,
      totalPaise: totalPaise is int? ? totalPaise : this.totalPaise,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TradeRequestUpdateTable extends _is.UpdateTable<TradeRequestTable> {
  TradeRequestUpdateTable(super.table);

  _is.ColumnValue<int, int> productId(int value) => _is.ColumnValue(
    table.productId,
    value,
  );

  _is.ColumnValue<int, int> buyerProfileId(int value) => _is.ColumnValue(
    table.buyerProfileId,
    value,
  );

  _is.ColumnValue<int, int> producerProfileId(int value) => _is.ColumnValue(
    table.producerProfileId,
    value,
  );

  _is.ColumnValue<String, String> productName(String value) => _is.ColumnValue(
    table.productName,
    value,
  );

  _is.ColumnValue<int, int> quantity(int value) => _is.ColumnValue(
    table.quantity,
    value,
  );

  _is.ColumnValue<String, String> requirements(String value) => _is.ColumnValue(
    table.requirements,
    value,
  );

  _is.ColumnValue<_ieevlvna.TradeStatus, _ieevlvna.TradeStatus> status(
    _ieevlvna.TradeStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> totalPaise(int? value) => _is.ColumnValue(
    table.totalPaise,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class TradeRequestTable extends _is.Table<int?> {
  TradeRequestTable({super.tableRelation}) : super(tableName: 'trade_request') {
    updateTable = TradeRequestUpdateTable(this);
    productId = _is.ColumnInt(
      'productId',
      this,
    );
    buyerProfileId = _is.ColumnInt(
      'buyerProfileId',
      this,
    );
    producerProfileId = _is.ColumnInt(
      'producerProfileId',
      this,
    );
    productName = _is.ColumnString(
      'productName',
      this,
    );
    quantity = _is.ColumnInt(
      'quantity',
      this,
    );
    requirements = _is.ColumnString(
      'requirements',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    totalPaise = _is.ColumnInt(
      'totalPaise',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TradeRequestUpdateTable updateTable;

  late final _is.ColumnInt productId;

  late final _is.ColumnInt buyerProfileId;

  late final _is.ColumnInt producerProfileId;

  late final _is.ColumnString productName;

  late final _is.ColumnInt quantity;

  late final _is.ColumnString requirements;

  late final _is.ColumnEnum<_ieevlvna.TradeStatus> status;

  late final _is.ColumnInt totalPaise;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    productId,
    buyerProfileId,
    producerProfileId,
    productName,
    quantity,
    requirements,
    status,
    totalPaise,
    createdAt,
  ];
}

class TradeRequestInclude extends _is.IncludeObject {
  TradeRequestInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TradeRequest.t;
}

class TradeRequestIncludeList extends _is.IncludeList {
  TradeRequestIncludeList._({
    _is.WhereExpressionBuilder<TradeRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TradeRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TradeRequest.t;
}

class TradeRequestRepository {
  const TradeRequestRepository._();

  /// Returns a list of [TradeRequest]s matching the given query parameters.
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
  Future<List<TradeRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TradeRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TradeRequestTable>? orderBy,
    _is.OrderByListBuilder<TradeRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TradeRequest>(
      where: where?.call(TradeRequest.t),
      orderBy: orderBy?.call(TradeRequest.t),
      orderByList: orderByList?.call(TradeRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [TradeRequest]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `TradeRequest.t`.
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
  _ida.Stream<List<TradeRequest>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TradeRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TradeRequestTable>? orderBy,
    _is.OrderByListBuilder<TradeRequestTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<TradeRequest>(
      where: where?.call(TradeRequest.t),
      orderBy: orderBy?.call(TradeRequest.t),
      orderByList: orderByList?.call(TradeRequest.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [TradeRequest] matching the given query parameters.
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
  Future<TradeRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TradeRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<TradeRequestTable>? orderBy,
    _is.OrderByListBuilder<TradeRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TradeRequest>(
      where: where?.call(TradeRequest.t),
      orderBy: orderBy?.call(TradeRequest.t),
      orderByList: orderByList?.call(TradeRequest.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TradeRequest] by its [id] or null if no such row exists.
  Future<TradeRequest?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TradeRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TradeRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [TradeRequest]s will have their `id` fields set.
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
  Future<List<TradeRequest>> insert(
    _is.DatabaseSession session,
    List<TradeRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TradeRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TradeRequest] and returns the inserted row.
  ///
  /// The returned [TradeRequest] will have its `id` field set.
  Future<TradeRequest> insertRow(
    _is.DatabaseSession session,
    TradeRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TradeRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TradeRequest]s in the list and returns the resulting rows.
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
  /// The returned [TradeRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TradeRequest>> upsert(
    _is.DatabaseSession session,
    List<TradeRequest> rows, {
    required _is.ColumnSelections<TradeRequestTable> conflictColumns,
    _is.ColumnSelections<TradeRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<TradeRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TradeRequest>(
      rows,
      conflictColumns: conflictColumns(TradeRequest.t),
      updateColumns: updateColumns?.call(TradeRequest.t),
      updateWhere: updateWhere?.call(TradeRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TradeRequest] and returns the resulting row.
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
  /// The returned [TradeRequest] will have its `id` field set.
  Future<TradeRequest?> upsertRow(
    _is.DatabaseSession session,
    TradeRequest row, {
    required _is.ColumnSelections<TradeRequestTable> conflictColumns,
    _is.ColumnSelections<TradeRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<TradeRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TradeRequest>(
      row,
      conflictColumns: conflictColumns(TradeRequest.t),
      updateColumns: updateColumns?.call(TradeRequest.t),
      updateWhere: updateWhere?.call(TradeRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [TradeRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TradeRequest>> update(
    _is.DatabaseSession session,
    List<TradeRequest> rows, {
    _is.ColumnSelections<TradeRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TradeRequest>(
      rows,
      columns: columns?.call(TradeRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TradeRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TradeRequest> updateRow(
    _is.DatabaseSession session,
    TradeRequest row, {
    _is.ColumnSelections<TradeRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TradeRequest>(
      row,
      columns: columns?.call(TradeRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TradeRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TradeRequest?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TradeRequestUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TradeRequest>(
      id,
      columnValues: columnValues(TradeRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TradeRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TradeRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TradeRequestUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TradeRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TradeRequestTable>? orderBy,
    _is.OrderByListBuilder<TradeRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TradeRequest>(
      columnValues: columnValues(TradeRequest.t.updateTable),
      where: where(TradeRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TradeRequest.t),
      orderByList: orderByList?.call(TradeRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TradeRequest]s in the list and returns the deleted rows.
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
  Future<List<TradeRequest>> delete(
    _is.DatabaseSession session,
    List<TradeRequest> rows, {
    _is.OrderByBuilder<TradeRequestTable>? orderBy,
    _is.OrderByListBuilder<TradeRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TradeRequest>(
      rows,
      orderBy: orderBy?.call(TradeRequest.t),
      orderByList: orderByList?.call(TradeRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TradeRequest].
  Future<TradeRequest> deleteRow(
    _is.DatabaseSession session,
    TradeRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TradeRequest>(
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
  Future<List<TradeRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TradeRequestTable> where,
    _is.OrderByBuilder<TradeRequestTable>? orderBy,
    _is.OrderByListBuilder<TradeRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TradeRequest>(
      where: where(TradeRequest.t),
      orderBy: orderBy?.call(TradeRequest.t),
      orderByList: orderByList?.call(TradeRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TradeRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TradeRequest>(
      where: where?.call(TradeRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TradeRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TradeRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TradeRequest>(
      where: where(TradeRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
