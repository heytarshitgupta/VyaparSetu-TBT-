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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

abstract class ProductPhoto
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ProductPhoto._({
    this.id,
    required this.productId,
    required this.bytes,
  });

  factory ProductPhoto({
    int? id,
    required int productId,
    required _idt.ByteData bytes,
  }) = _ProductPhotoImpl;

  factory ProductPhoto.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductPhoto(
      id: jsonSerialization['id'] as int?,
      productId: jsonSerialization['productId'] as int,
      bytes: _is.ByteDataJsonExtension.fromJson(jsonSerialization['bytes']),
    );
  }

  static final t = ProductPhotoTable();

  static const db = ProductPhotoRepository._();

  @override
  int? id;

  int productId;

  _idt.ByteData bytes;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProductPhoto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductPhoto copyWith({
    int? id,
    int? productId,
    _idt.ByteData? bytes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductPhoto',
      if (id != null) 'id': id,
      'productId': productId,
      'bytes': bytes.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductPhoto',
      if (id != null) 'id': id,
      'productId': productId,
      'bytes': bytes.toJson(),
    };
  }

  static ProductPhotoInclude include() {
    return ProductPhotoInclude._();
  }

  static ProductPhotoIncludeList includeList({
    _is.WhereExpressionBuilder<ProductPhotoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductPhotoTable>? orderBy,
    _is.OrderByListBuilder<ProductPhotoTable>? orderByList,
    ProductPhotoInclude? include,
  }) {
    return ProductPhotoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductPhoto.t),
      orderByList: orderByList?.call(ProductPhoto.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductPhotoImpl extends ProductPhoto {
  _ProductPhotoImpl({
    int? id,
    required int productId,
    required _idt.ByteData bytes,
  }) : super._(
         id: id,
         productId: productId,
         bytes: bytes,
       );

  /// Returns a shallow copy of this [ProductPhoto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductPhoto copyWith({
    Object? id = _Undefined,
    int? productId,
    _idt.ByteData? bytes,
  }) {
    return ProductPhoto(
      id: id is int? ? id : this.id,
      productId: productId ?? this.productId,
      bytes: bytes ?? this.bytes.clone(),
    );
  }
}

class ProductPhotoUpdateTable extends _is.UpdateTable<ProductPhotoTable> {
  ProductPhotoUpdateTable(super.table);

  _is.ColumnValue<int, int> productId(int value) => _is.ColumnValue(
    table.productId,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> bytes(_idt.ByteData value) =>
      _is.ColumnValue(
        table.bytes,
        value,
      );
}

class ProductPhotoTable extends _is.Table<int?> {
  ProductPhotoTable({super.tableRelation}) : super(tableName: 'product_photo') {
    updateTable = ProductPhotoUpdateTable(this);
    productId = _is.ColumnInt(
      'productId',
      this,
    );
    bytes = _is.ColumnByteData(
      'bytes',
      this,
    );
  }

  late final ProductPhotoUpdateTable updateTable;

  late final _is.ColumnInt productId;

  late final _is.ColumnByteData bytes;

  @override
  List<_is.Column> get columns => [
    id,
    productId,
    bytes,
  ];
}

class ProductPhotoInclude extends _is.IncludeObject {
  ProductPhotoInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ProductPhoto.t;
}

class ProductPhotoIncludeList extends _is.IncludeList {
  ProductPhotoIncludeList._({
    _is.WhereExpressionBuilder<ProductPhotoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductPhoto.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProductPhoto.t;
}

class ProductPhotoRepository {
  const ProductPhotoRepository._();

  /// Returns a list of [ProductPhoto]s matching the given query parameters.
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
  Future<List<ProductPhoto>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductPhotoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductPhotoTable>? orderBy,
    _is.OrderByListBuilder<ProductPhotoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductPhoto>(
      where: where?.call(ProductPhoto.t),
      orderBy: orderBy?.call(ProductPhoto.t),
      orderByList: orderByList?.call(ProductPhoto.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ProductPhoto]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ProductPhoto.t`.
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
  _ida.Stream<List<ProductPhoto>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductPhotoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductPhotoTable>? orderBy,
    _is.OrderByListBuilder<ProductPhotoTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ProductPhoto>(
      where: where?.call(ProductPhoto.t),
      orderBy: orderBy?.call(ProductPhoto.t),
      orderByList: orderByList?.call(ProductPhoto.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ProductPhoto] matching the given query parameters.
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
  Future<ProductPhoto?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductPhotoTable>? where,
    int? offset,
    _is.OrderByBuilder<ProductPhotoTable>? orderBy,
    _is.OrderByListBuilder<ProductPhotoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductPhoto>(
      where: where?.call(ProductPhoto.t),
      orderBy: orderBy?.call(ProductPhoto.t),
      orderByList: orderByList?.call(ProductPhoto.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductPhoto] by its [id] or null if no such row exists.
  Future<ProductPhoto?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductPhoto>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductPhoto]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductPhoto]s will have their `id` fields set.
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
  Future<List<ProductPhoto>> insert(
    _is.DatabaseSession session,
    List<ProductPhoto> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProductPhoto>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProductPhoto] and returns the inserted row.
  ///
  /// The returned [ProductPhoto] will have its `id` field set.
  Future<ProductPhoto> insertRow(
    _is.DatabaseSession session,
    ProductPhoto row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductPhoto>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProductPhoto]s in the list and returns the resulting rows.
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
  /// The returned [ProductPhoto]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductPhoto>> upsert(
    _is.DatabaseSession session,
    List<ProductPhoto> rows, {
    required _is.ColumnSelections<ProductPhotoTable> conflictColumns,
    _is.ColumnSelections<ProductPhotoTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductPhotoTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProductPhoto>(
      rows,
      conflictColumns: conflictColumns(ProductPhoto.t),
      updateColumns: updateColumns?.call(ProductPhoto.t),
      updateWhere: updateWhere?.call(ProductPhoto.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProductPhoto] and returns the resulting row.
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
  /// The returned [ProductPhoto] will have its `id` field set.
  Future<ProductPhoto?> upsertRow(
    _is.DatabaseSession session,
    ProductPhoto row, {
    required _is.ColumnSelections<ProductPhotoTable> conflictColumns,
    _is.ColumnSelections<ProductPhotoTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductPhotoTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProductPhoto>(
      row,
      conflictColumns: conflictColumns(ProductPhoto.t),
      updateColumns: updateColumns?.call(ProductPhoto.t),
      updateWhere: updateWhere?.call(ProductPhoto.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProductPhoto]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductPhoto>> update(
    _is.DatabaseSession session,
    List<ProductPhoto> rows, {
    _is.ColumnSelections<ProductPhotoTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProductPhoto>(
      rows,
      columns: columns?.call(ProductPhoto.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProductPhoto]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductPhoto> updateRow(
    _is.DatabaseSession session,
    ProductPhoto row, {
    _is.ColumnSelections<ProductPhotoTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductPhoto>(
      row,
      columns: columns?.call(ProductPhoto.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductPhoto] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductPhoto?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProductPhotoUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductPhoto>(
      id,
      columnValues: columnValues(ProductPhoto.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductPhoto]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductPhoto>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProductPhotoUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProductPhotoTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductPhotoTable>? orderBy,
    _is.OrderByListBuilder<ProductPhotoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProductPhoto>(
      columnValues: columnValues(ProductPhoto.t.updateTable),
      where: where(ProductPhoto.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductPhoto.t),
      orderByList: orderByList?.call(ProductPhoto.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProductPhoto]s in the list and returns the deleted rows.
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
  Future<List<ProductPhoto>> delete(
    _is.DatabaseSession session,
    List<ProductPhoto> rows, {
    _is.OrderByBuilder<ProductPhotoTable>? orderBy,
    _is.OrderByListBuilder<ProductPhotoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProductPhoto>(
      rows,
      orderBy: orderBy?.call(ProductPhoto.t),
      orderByList: orderByList?.call(ProductPhoto.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProductPhoto].
  Future<ProductPhoto> deleteRow(
    _is.DatabaseSession session,
    ProductPhoto row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductPhoto>(
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
  Future<List<ProductPhoto>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductPhotoTable> where,
    _is.OrderByBuilder<ProductPhotoTable>? orderBy,
    _is.OrderByListBuilder<ProductPhotoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProductPhoto>(
      where: where(ProductPhoto.t),
      orderBy: orderBy?.call(ProductPhoto.t),
      orderByList: orderByList?.call(ProductPhoto.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductPhotoTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProductPhoto>(
      where: where?.call(ProductPhoto.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductPhoto] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductPhotoTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductPhoto>(
      where: where(ProductPhoto.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
