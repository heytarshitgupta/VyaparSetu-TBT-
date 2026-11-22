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

abstract class BuyerRequirement
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BuyerRequirement._({
    this.id,
    required this.buyerProfileId,
    required this.title,
    required this.description,
    required this.category,
    required this.quantity,
    this.budgetPaise,
    this.city,
    this.state,
    String? status,
    required this.createdAt,
  }) : status = status ?? 'open';

  factory BuyerRequirement({
    int? id,
    required int buyerProfileId,
    required String title,
    required String description,
    required String category,
    required int quantity,
    int? budgetPaise,
    String? city,
    String? state,
    String? status,
    required DateTime createdAt,
  }) = _BuyerRequirementImpl;

  factory BuyerRequirement.fromJson(Map<String, dynamic> jsonSerialization) {
    return BuyerRequirement(
      id: jsonSerialization['id'] as int?,
      buyerProfileId: jsonSerialization['buyerProfileId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      quantity: jsonSerialization['quantity'] as int,
      budgetPaise: jsonSerialization['budgetPaise'] as int?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      status: jsonSerialization['status'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = BuyerRequirementTable();

  static const db = BuyerRequirementRepository._();

  @override
  int? id;

  int buyerProfileId;

  String title;

  String description;

  String category;

  int quantity;

  int? budgetPaise;

  String? city;

  String? state;

  String status;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BuyerRequirement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BuyerRequirement copyWith({
    int? id,
    int? buyerProfileId,
    String? title,
    String? description,
    String? category,
    int? quantity,
    int? budgetPaise,
    String? city,
    String? state,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BuyerRequirement',
      if (id != null) 'id': id,
      'buyerProfileId': buyerProfileId,
      'title': title,
      'description': description,
      'category': category,
      'quantity': quantity,
      if (budgetPaise != null) 'budgetPaise': budgetPaise,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BuyerRequirement',
      if (id != null) 'id': id,
      'buyerProfileId': buyerProfileId,
      'title': title,
      'description': description,
      'category': category,
      'quantity': quantity,
      if (budgetPaise != null) 'budgetPaise': budgetPaise,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  static BuyerRequirementInclude include() {
    return BuyerRequirementInclude._();
  }

  static BuyerRequirementIncludeList includeList({
    _is.WhereExpressionBuilder<BuyerRequirementTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BuyerRequirementTable>? orderBy,
    _is.OrderByListBuilder<BuyerRequirementTable>? orderByList,
    BuyerRequirementInclude? include,
  }) {
    return BuyerRequirementIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BuyerRequirement.t),
      orderByList: orderByList?.call(BuyerRequirement.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BuyerRequirementImpl extends BuyerRequirement {
  _BuyerRequirementImpl({
    int? id,
    required int buyerProfileId,
    required String title,
    required String description,
    required String category,
    required int quantity,
    int? budgetPaise,
    String? city,
    String? state,
    String? status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         buyerProfileId: buyerProfileId,
         title: title,
         description: description,
         category: category,
         quantity: quantity,
         budgetPaise: budgetPaise,
         city: city,
         state: state,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BuyerRequirement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BuyerRequirement copyWith({
    Object? id = _Undefined,
    int? buyerProfileId,
    String? title,
    String? description,
    String? category,
    int? quantity,
    Object? budgetPaise = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return BuyerRequirement(
      id: id is int? ? id : this.id,
      buyerProfileId: buyerProfileId ?? this.buyerProfileId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      budgetPaise: budgetPaise is int? ? budgetPaise : this.budgetPaise,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BuyerRequirementUpdateTable
    extends _is.UpdateTable<BuyerRequirementTable> {
  BuyerRequirementUpdateTable(super.table);

  _is.ColumnValue<int, int> buyerProfileId(int value) => _is.ColumnValue(
    table.buyerProfileId,
    value,
  );

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

  _is.ColumnValue<int, int> quantity(int value) => _is.ColumnValue(
    table.quantity,
    value,
  );

  _is.ColumnValue<int, int> budgetPaise(int? value) => _is.ColumnValue(
    table.budgetPaise,
    value,
  );

  _is.ColumnValue<String, String> city(String? value) => _is.ColumnValue(
    table.city,
    value,
  );

  _is.ColumnValue<String, String> state(String? value) => _is.ColumnValue(
    table.state,
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

class BuyerRequirementTable extends _is.Table<int?> {
  BuyerRequirementTable({super.tableRelation})
    : super(tableName: 'buyer_requirement') {
    updateTable = BuyerRequirementUpdateTable(this);
    buyerProfileId = _is.ColumnInt(
      'buyerProfileId',
      this,
    );
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
    quantity = _is.ColumnInt(
      'quantity',
      this,
    );
    budgetPaise = _is.ColumnInt(
      'budgetPaise',
      this,
    );
    city = _is.ColumnString(
      'city',
      this,
    );
    state = _is.ColumnString(
      'state',
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

  late final BuyerRequirementUpdateTable updateTable;

  late final _is.ColumnInt buyerProfileId;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnString category;

  late final _is.ColumnInt quantity;

  late final _is.ColumnInt budgetPaise;

  late final _is.ColumnString city;

  late final _is.ColumnString state;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    buyerProfileId,
    title,
    description,
    category,
    quantity,
    budgetPaise,
    city,
    state,
    status,
    createdAt,
  ];
}

class BuyerRequirementInclude extends _is.IncludeObject {
  BuyerRequirementInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BuyerRequirement.t;
}

class BuyerRequirementIncludeList extends _is.IncludeList {
  BuyerRequirementIncludeList._({
    _is.WhereExpressionBuilder<BuyerRequirementTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BuyerRequirement.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BuyerRequirement.t;
}

class BuyerRequirementRepository {
  const BuyerRequirementRepository._();

  /// Returns a list of [BuyerRequirement]s matching the given query parameters.
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
  Future<List<BuyerRequirement>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BuyerRequirementTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BuyerRequirementTable>? orderBy,
    _is.OrderByListBuilder<BuyerRequirementTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BuyerRequirement>(
      where: where?.call(BuyerRequirement.t),
      orderBy: orderBy?.call(BuyerRequirement.t),
      orderByList: orderByList?.call(BuyerRequirement.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [BuyerRequirement]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `BuyerRequirement.t`.
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
  _ida.Stream<List<BuyerRequirement>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BuyerRequirementTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BuyerRequirementTable>? orderBy,
    _is.OrderByListBuilder<BuyerRequirementTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<BuyerRequirement>(
      where: where?.call(BuyerRequirement.t),
      orderBy: orderBy?.call(BuyerRequirement.t),
      orderByList: orderByList?.call(BuyerRequirement.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [BuyerRequirement] matching the given query parameters.
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
  Future<BuyerRequirement?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BuyerRequirementTable>? where,
    int? offset,
    _is.OrderByBuilder<BuyerRequirementTable>? orderBy,
    _is.OrderByListBuilder<BuyerRequirementTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BuyerRequirement>(
      where: where?.call(BuyerRequirement.t),
      orderBy: orderBy?.call(BuyerRequirement.t),
      orderByList: orderByList?.call(BuyerRequirement.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BuyerRequirement] by its [id] or null if no such row exists.
  Future<BuyerRequirement?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BuyerRequirement>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BuyerRequirement]s in the list and returns the inserted rows.
  ///
  /// The returned [BuyerRequirement]s will have their `id` fields set.
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
  Future<List<BuyerRequirement>> insert(
    _is.DatabaseSession session,
    List<BuyerRequirement> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BuyerRequirement>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BuyerRequirement] and returns the inserted row.
  ///
  /// The returned [BuyerRequirement] will have its `id` field set.
  Future<BuyerRequirement> insertRow(
    _is.DatabaseSession session,
    BuyerRequirement row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BuyerRequirement>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BuyerRequirement]s in the list and returns the resulting rows.
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
  /// The returned [BuyerRequirement]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BuyerRequirement>> upsert(
    _is.DatabaseSession session,
    List<BuyerRequirement> rows, {
    required _is.ColumnSelections<BuyerRequirementTable> conflictColumns,
    _is.ColumnSelections<BuyerRequirementTable>? updateColumns,
    _is.WhereExpressionBuilder<BuyerRequirementTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BuyerRequirement>(
      rows,
      conflictColumns: conflictColumns(BuyerRequirement.t),
      updateColumns: updateColumns?.call(BuyerRequirement.t),
      updateWhere: updateWhere?.call(BuyerRequirement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BuyerRequirement] and returns the resulting row.
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
  /// The returned [BuyerRequirement] will have its `id` field set.
  Future<BuyerRequirement?> upsertRow(
    _is.DatabaseSession session,
    BuyerRequirement row, {
    required _is.ColumnSelections<BuyerRequirementTable> conflictColumns,
    _is.ColumnSelections<BuyerRequirementTable>? updateColumns,
    _is.WhereExpressionBuilder<BuyerRequirementTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BuyerRequirement>(
      row,
      conflictColumns: conflictColumns(BuyerRequirement.t),
      updateColumns: updateColumns?.call(BuyerRequirement.t),
      updateWhere: updateWhere?.call(BuyerRequirement.t),
      transaction: transaction,
    );
  }

  /// Updates all [BuyerRequirement]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BuyerRequirement>> update(
    _is.DatabaseSession session,
    List<BuyerRequirement> rows, {
    _is.ColumnSelections<BuyerRequirementTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BuyerRequirement>(
      rows,
      columns: columns?.call(BuyerRequirement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BuyerRequirement]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BuyerRequirement> updateRow(
    _is.DatabaseSession session,
    BuyerRequirement row, {
    _is.ColumnSelections<BuyerRequirementTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BuyerRequirement>(
      row,
      columns: columns?.call(BuyerRequirement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BuyerRequirement] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BuyerRequirement?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BuyerRequirementUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BuyerRequirement>(
      id,
      columnValues: columnValues(BuyerRequirement.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BuyerRequirement]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BuyerRequirement>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BuyerRequirementUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<BuyerRequirementTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BuyerRequirementTable>? orderBy,
    _is.OrderByListBuilder<BuyerRequirementTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BuyerRequirement>(
      columnValues: columnValues(BuyerRequirement.t.updateTable),
      where: where(BuyerRequirement.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BuyerRequirement.t),
      orderByList: orderByList?.call(BuyerRequirement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BuyerRequirement]s in the list and returns the deleted rows.
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
  Future<List<BuyerRequirement>> delete(
    _is.DatabaseSession session,
    List<BuyerRequirement> rows, {
    _is.OrderByBuilder<BuyerRequirementTable>? orderBy,
    _is.OrderByListBuilder<BuyerRequirementTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BuyerRequirement>(
      rows,
      orderBy: orderBy?.call(BuyerRequirement.t),
      orderByList: orderByList?.call(BuyerRequirement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BuyerRequirement].
  Future<BuyerRequirement> deleteRow(
    _is.DatabaseSession session,
    BuyerRequirement row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BuyerRequirement>(
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
  Future<List<BuyerRequirement>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BuyerRequirementTable> where,
    _is.OrderByBuilder<BuyerRequirementTable>? orderBy,
    _is.OrderByListBuilder<BuyerRequirementTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BuyerRequirement>(
      where: where(BuyerRequirement.t),
      orderBy: orderBy?.call(BuyerRequirement.t),
      orderByList: orderByList?.call(BuyerRequirement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BuyerRequirementTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BuyerRequirement>(
      where: where?.call(BuyerRequirement.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BuyerRequirement] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BuyerRequirementTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BuyerRequirement>(
      where: where(BuyerRequirement.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
