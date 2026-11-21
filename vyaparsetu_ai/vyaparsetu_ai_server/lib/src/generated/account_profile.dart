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
import 'marketplace_role.dart' as _i1ko12if;

abstract class AccountProfile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AccountProfile._({
    this.id,
    required this.authUserId,
    required this.displayName,
    required this.role,
  });

  factory AccountProfile({
    int? id,
    required _is.UuidValue authUserId,
    required String displayName,
    required _i1ko12if.MarketplaceRole role,
  }) = _AccountProfileImpl;

  factory AccountProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountProfile(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      role: _i1ko12if.MarketplaceRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
    );
  }

  static final t = AccountProfileTable();

  static const db = AccountProfileRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String displayName;

  _i1ko12if.MarketplaceRole role;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountProfile copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? displayName,
    _i1ko12if.MarketplaceRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'role': role.toJson(),
    };
  }

  static AccountProfileInclude include() {
    return AccountProfileInclude._();
  }

  static AccountProfileIncludeList includeList({
    _is.WhereExpressionBuilder<AccountProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountProfileTable>? orderBy,
    _is.OrderByListBuilder<AccountProfileTable>? orderByList,
    AccountProfileInclude? include,
  }) {
    return AccountProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountProfile.t),
      orderByList: orderByList?.call(AccountProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountProfileImpl extends AccountProfile {
  _AccountProfileImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String displayName,
    required _i1ko12if.MarketplaceRole role,
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         role: role,
       );

  /// Returns a shallow copy of this [AccountProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountProfile copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? displayName,
    _i1ko12if.MarketplaceRole? role,
  }) {
    return AccountProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
    );
  }
}

class AccountProfileUpdateTable extends _is.UpdateTable<AccountProfileTable> {
  AccountProfileUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<_i1ko12if.MarketplaceRole, _i1ko12if.MarketplaceRole> role(
    _i1ko12if.MarketplaceRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );
}

class AccountProfileTable extends _is.Table<int?> {
  AccountProfileTable({super.tableRelation})
    : super(tableName: 'account_profile') {
    updateTable = AccountProfileUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
  }

  late final AccountProfileUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString displayName;

  late final _is.ColumnEnum<_i1ko12if.MarketplaceRole> role;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    displayName,
    role,
  ];
}

class AccountProfileInclude extends _is.IncludeObject {
  AccountProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AccountProfile.t;
}

class AccountProfileIncludeList extends _is.IncludeList {
  AccountProfileIncludeList._({
    _is.WhereExpressionBuilder<AccountProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AccountProfile.t;
}

class AccountProfileRepository {
  const AccountProfileRepository._();

  /// Returns a list of [AccountProfile]s matching the given query parameters.
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
  Future<List<AccountProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountProfileTable>? orderBy,
    _is.OrderByListBuilder<AccountProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountProfile>(
      where: where?.call(AccountProfile.t),
      orderBy: orderBy?.call(AccountProfile.t),
      orderByList: orderByList?.call(AccountProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AccountProfile]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AccountProfile.t`.
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
  _ida.Stream<List<AccountProfile>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountProfileTable>? orderBy,
    _is.OrderByListBuilder<AccountProfileTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AccountProfile>(
      where: where?.call(AccountProfile.t),
      orderBy: orderBy?.call(AccountProfile.t),
      orderByList: orderByList?.call(AccountProfile.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AccountProfile] matching the given query parameters.
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
  Future<AccountProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<AccountProfileTable>? orderBy,
    _is.OrderByListBuilder<AccountProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountProfile>(
      where: where?.call(AccountProfile.t),
      orderBy: orderBy?.call(AccountProfile.t),
      orderByList: orderByList?.call(AccountProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountProfile] by its [id] or null if no such row exists.
  Future<AccountProfile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountProfile]s will have their `id` fields set.
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
  Future<List<AccountProfile>> insert(
    _is.DatabaseSession session,
    List<AccountProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccountProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccountProfile] and returns the inserted row.
  ///
  /// The returned [AccountProfile] will have its `id` field set.
  Future<AccountProfile> insertRow(
    _is.DatabaseSession session,
    AccountProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccountProfile]s in the list and returns the resulting rows.
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
  /// The returned [AccountProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountProfile>> upsert(
    _is.DatabaseSession session,
    List<AccountProfile> rows, {
    required _is.ColumnSelections<AccountProfileTable> conflictColumns,
    _is.ColumnSelections<AccountProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccountProfile>(
      rows,
      conflictColumns: conflictColumns(AccountProfile.t),
      updateColumns: updateColumns?.call(AccountProfile.t),
      updateWhere: updateWhere?.call(AccountProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccountProfile] and returns the resulting row.
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
  /// The returned [AccountProfile] will have its `id` field set.
  Future<AccountProfile?> upsertRow(
    _is.DatabaseSession session,
    AccountProfile row, {
    required _is.ColumnSelections<AccountProfileTable> conflictColumns,
    _is.ColumnSelections<AccountProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccountProfile>(
      row,
      conflictColumns: conflictColumns(AccountProfile.t),
      updateColumns: updateColumns?.call(AccountProfile.t),
      updateWhere: updateWhere?.call(AccountProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccountProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountProfile>> update(
    _is.DatabaseSession session,
    List<AccountProfile> rows, {
    _is.ColumnSelections<AccountProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccountProfile>(
      rows,
      columns: columns?.call(AccountProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccountProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountProfile> updateRow(
    _is.DatabaseSession session,
    AccountProfile row, {
    _is.ColumnSelections<AccountProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountProfile>(
      row,
      columns: columns?.call(AccountProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountProfile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AccountProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountProfile>(
      id,
      columnValues: columnValues(AccountProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccountProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AccountProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountProfileTable>? orderBy,
    _is.OrderByListBuilder<AccountProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccountProfile>(
      columnValues: columnValues(AccountProfile.t.updateTable),
      where: where(AccountProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountProfile.t),
      orderByList: orderByList?.call(AccountProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccountProfile]s in the list and returns the deleted rows.
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
  Future<List<AccountProfile>> delete(
    _is.DatabaseSession session,
    List<AccountProfile> rows, {
    _is.OrderByBuilder<AccountProfileTable>? orderBy,
    _is.OrderByListBuilder<AccountProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccountProfile>(
      rows,
      orderBy: orderBy?.call(AccountProfile.t),
      orderByList: orderByList?.call(AccountProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccountProfile].
  Future<AccountProfile> deleteRow(
    _is.DatabaseSession session,
    AccountProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountProfile>(
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
  Future<List<AccountProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountProfileTable> where,
    _is.OrderByBuilder<AccountProfileTable>? orderBy,
    _is.OrderByListBuilder<AccountProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccountProfile>(
      where: where(AccountProfile.t),
      orderBy: orderBy?.call(AccountProfile.t),
      orderByList: orderByList?.call(AccountProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccountProfile>(
      where: where?.call(AccountProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountProfile>(
      where: where(AccountProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
