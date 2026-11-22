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

abstract class WishlistItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  WishlistItem._({
    this.id,
    required this.buyerProfileId,
    required this.productId,
    required this.createdAt,
  });

  factory WishlistItem({
    int? id,
    required int buyerProfileId,
    required int productId,
    required DateTime createdAt,
  }) = _WishlistItemImpl;

  factory WishlistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return WishlistItem(
      id: jsonSerialization['id'] as int?,
      buyerProfileId: jsonSerialization['buyerProfileId'] as int,
      productId: jsonSerialization['productId'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = WishlistItemTable();

  static const db = WishlistItemRepository._();

  @override
  int? id;

  int buyerProfileId;

  int productId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [WishlistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WishlistItem copyWith({
    int? id,
    int? buyerProfileId,
    int? productId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WishlistItem',
      if (id != null) 'id': id,
      'buyerProfileId': buyerProfileId,
      'productId': productId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WishlistItem',
      if (id != null) 'id': id,
      'buyerProfileId': buyerProfileId,
      'productId': productId,
      'createdAt': createdAt.toJson(),
    };
  }

  static WishlistItemInclude include() {
    return WishlistItemInclude._();
  }

  static WishlistItemIncludeList includeList({
    _is.WhereExpressionBuilder<WishlistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WishlistItemTable>? orderBy,
    _is.OrderByListBuilder<WishlistItemTable>? orderByList,
    WishlistItemInclude? include,
  }) {
    return WishlistItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WishlistItem.t),
      orderByList: orderByList?.call(WishlistItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WishlistItemImpl extends WishlistItem {
  _WishlistItemImpl({
    int? id,
    required int buyerProfileId,
    required int productId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         buyerProfileId: buyerProfileId,
         productId: productId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WishlistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WishlistItem copyWith({
    Object? id = _Undefined,
    int? buyerProfileId,
    int? productId,
    DateTime? createdAt,
  }) {
    return WishlistItem(
      id: id is int? ? id : this.id,
      buyerProfileId: buyerProfileId ?? this.buyerProfileId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WishlistItemUpdateTable extends _is.UpdateTable<WishlistItemTable> {
  WishlistItemUpdateTable(super.table);

  _is.ColumnValue<int, int> buyerProfileId(int value) => _is.ColumnValue(
    table.buyerProfileId,
    value,
  );

  _is.ColumnValue<int, int> productId(int value) => _is.ColumnValue(
    table.productId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class WishlistItemTable extends _is.Table<int?> {
  WishlistItemTable({super.tableRelation}) : super(tableName: 'wishlist_item') {
    updateTable = WishlistItemUpdateTable(this);
    buyerProfileId = _is.ColumnInt(
      'buyerProfileId',
      this,
    );
    productId = _is.ColumnInt(
      'productId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final WishlistItemUpdateTable updateTable;

  late final _is.ColumnInt buyerProfileId;

  late final _is.ColumnInt productId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    buyerProfileId,
    productId,
    createdAt,
  ];
}

class WishlistItemInclude extends _is.IncludeObject {
  WishlistItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => WishlistItem.t;
}

class WishlistItemIncludeList extends _is.IncludeList {
  WishlistItemIncludeList._({
    _is.WhereExpressionBuilder<WishlistItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WishlistItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => WishlistItem.t;
}

class WishlistItemRepository {
  const WishlistItemRepository._();

  /// Returns a list of [WishlistItem]s matching the given query parameters.
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
  Future<List<WishlistItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WishlistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WishlistItemTable>? orderBy,
    _is.OrderByListBuilder<WishlistItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WishlistItem>(
      where: where?.call(WishlistItem.t),
      orderBy: orderBy?.call(WishlistItem.t),
      orderByList: orderByList?.call(WishlistItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [WishlistItem]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `WishlistItem.t`.
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
  _ida.Stream<List<WishlistItem>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WishlistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WishlistItemTable>? orderBy,
    _is.OrderByListBuilder<WishlistItemTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<WishlistItem>(
      where: where?.call(WishlistItem.t),
      orderBy: orderBy?.call(WishlistItem.t),
      orderByList: orderByList?.call(WishlistItem.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [WishlistItem] matching the given query parameters.
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
  Future<WishlistItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WishlistItemTable>? where,
    int? offset,
    _is.OrderByBuilder<WishlistItemTable>? orderBy,
    _is.OrderByListBuilder<WishlistItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WishlistItem>(
      where: where?.call(WishlistItem.t),
      orderBy: orderBy?.call(WishlistItem.t),
      orderByList: orderByList?.call(WishlistItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WishlistItem] by its [id] or null if no such row exists.
  Future<WishlistItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WishlistItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WishlistItem]s in the list and returns the inserted rows.
  ///
  /// The returned [WishlistItem]s will have their `id` fields set.
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
  Future<List<WishlistItem>> insert(
    _is.DatabaseSession session,
    List<WishlistItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WishlistItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WishlistItem] and returns the inserted row.
  ///
  /// The returned [WishlistItem] will have its `id` field set.
  Future<WishlistItem> insertRow(
    _is.DatabaseSession session,
    WishlistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WishlistItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WishlistItem]s in the list and returns the resulting rows.
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
  /// The returned [WishlistItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WishlistItem>> upsert(
    _is.DatabaseSession session,
    List<WishlistItem> rows, {
    required _is.ColumnSelections<WishlistItemTable> conflictColumns,
    _is.ColumnSelections<WishlistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<WishlistItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WishlistItem>(
      rows,
      conflictColumns: conflictColumns(WishlistItem.t),
      updateColumns: updateColumns?.call(WishlistItem.t),
      updateWhere: updateWhere?.call(WishlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WishlistItem] and returns the resulting row.
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
  /// The returned [WishlistItem] will have its `id` field set.
  Future<WishlistItem?> upsertRow(
    _is.DatabaseSession session,
    WishlistItem row, {
    required _is.ColumnSelections<WishlistItemTable> conflictColumns,
    _is.ColumnSelections<WishlistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<WishlistItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WishlistItem>(
      row,
      conflictColumns: conflictColumns(WishlistItem.t),
      updateColumns: updateColumns?.call(WishlistItem.t),
      updateWhere: updateWhere?.call(WishlistItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [WishlistItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WishlistItem>> update(
    _is.DatabaseSession session,
    List<WishlistItem> rows, {
    _is.ColumnSelections<WishlistItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WishlistItem>(
      rows,
      columns: columns?.call(WishlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WishlistItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WishlistItem> updateRow(
    _is.DatabaseSession session,
    WishlistItem row, {
    _is.ColumnSelections<WishlistItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WishlistItem>(
      row,
      columns: columns?.call(WishlistItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WishlistItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WishlistItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WishlistItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WishlistItem>(
      id,
      columnValues: columnValues(WishlistItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WishlistItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WishlistItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WishlistItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WishlistItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WishlistItemTable>? orderBy,
    _is.OrderByListBuilder<WishlistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WishlistItem>(
      columnValues: columnValues(WishlistItem.t.updateTable),
      where: where(WishlistItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WishlistItem.t),
      orderByList: orderByList?.call(WishlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WishlistItem]s in the list and returns the deleted rows.
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
  Future<List<WishlistItem>> delete(
    _is.DatabaseSession session,
    List<WishlistItem> rows, {
    _is.OrderByBuilder<WishlistItemTable>? orderBy,
    _is.OrderByListBuilder<WishlistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WishlistItem>(
      rows,
      orderBy: orderBy?.call(WishlistItem.t),
      orderByList: orderByList?.call(WishlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WishlistItem].
  Future<WishlistItem> deleteRow(
    _is.DatabaseSession session,
    WishlistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WishlistItem>(
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
  Future<List<WishlistItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WishlistItemTable> where,
    _is.OrderByBuilder<WishlistItemTable>? orderBy,
    _is.OrderByListBuilder<WishlistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WishlistItem>(
      where: where(WishlistItem.t),
      orderBy: orderBy?.call(WishlistItem.t),
      orderByList: orderByList?.call(WishlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WishlistItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WishlistItem>(
      where: where?.call(WishlistItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WishlistItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WishlistItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WishlistItem>(
      where: where(WishlistItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
