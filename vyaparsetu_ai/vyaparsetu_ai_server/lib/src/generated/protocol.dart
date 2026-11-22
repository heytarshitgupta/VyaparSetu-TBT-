/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:vyaparsetu_ai_server/src/generated/product.dart' as _iiz32gqo;
import 'package:vyaparsetu_ai_server/src/generated/trade_request.dart'
    as _ij7yvnp4;
import 'account_profile.dart' as _i9dsm4op;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'marketplace_role.dart' as _i1ko12if;
import 'product.dart' as _i8ctgxfn;
import 'product_draft_exception.dart' as _i1druvxr;
import 'product_photo.dart' as _ihhflbx4;
import 'product_status.dart' as _izdy7rp7;
import 'profile_exception.dart' as _ip8pwhpv;
import 'trade_request.dart' as _ixjhwvo7;
import 'trade_status.dart' as _ieevlvna;
export 'account_profile.dart';
export 'greetings/greeting.dart';
export 'marketplace_role.dart';
export 'product.dart';
export 'product_draft_exception.dart';
export 'product_photo.dart';
export 'product_status.dart';
export 'profile_exception.dart';
export 'trade_request.dart';
export 'trade_status.dart';

class Protocol extends _is.DatabaseSerializationManager
    implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _is.ProtocolDeserialization get deserializationMetadata =>
      _is.ProtocolDeserialization.cached(
        this,
        types: const [
          _is.getType<_i9dsm4op.AccountProfile>,
          _is.getType<_izw8z7ou.Greeting>,
          _is.getType<_i1ko12if.MarketplaceRole>,
          _is.getType<_i8ctgxfn.Product>,
          _is.getType<_i1druvxr.ProductDraftException>,
          _is.getType<_ihhflbx4.ProductPhoto>,
          _is.getType<_izdy7rp7.ProductStatus>,
          _is.getType<_ip8pwhpv.ProfileException>,
          _is.getType<_ixjhwvo7.TradeRequest>,
          _is.getType<_ieevlvna.TradeStatus>,
          _is.getType<_i9dsm4op.AccountProfile?>,
          _is.getType<_izw8z7ou.Greeting?>,
          _is.getType<_i1ko12if.MarketplaceRole?>,
          _is.getType<_i8ctgxfn.Product?>,
          _is.getType<_i1druvxr.ProductDraftException?>,
          _is.getType<_ihhflbx4.ProductPhoto?>,
          _is.getType<_izdy7rp7.ProductStatus?>,
          _is.getType<_ip8pwhpv.ProfileException?>,
          _is.getType<_ixjhwvo7.TradeRequest?>,
          _is.getType<_ieevlvna.TradeStatus?>,
          _is.getType<List<_iiz32gqo.Product>>,
          _is.getType<List<_ij7yvnp4.TradeRequest>>,
        ],
        modules: const [
          _iais.Protocol.new,
          _iacs.Protocol.new,
          _isp.Protocol.new,
        ],
        classNames: const [
          'AccountProfile',
          'Greeting',
          'MarketplaceRole',
          'Product',
          'ProductDraftException',
          'ProductPhoto',
          'ProductStatus',
          'ProfileException',
          'TradeRequest',
          'TradeStatus',
        ],
      );

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    ..._ownTableDefinitions,
    ..._iais.Protocol().getOwnTableDefinitions(),
    ..._iacs.Protocol().getOwnTableDefinitions(),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static List<_isp.TableDefinition> get _ownTableDefinitions => [
    _isp.TableDefinition(
      name: 'account_profile',
      dartName: 'AccountProfile',
      schema: 'public',
      module: 'vyaparsetu_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MarketplaceRole',
        ),
        _isp.ColumnDefinition(
          name: 'businessName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'craftCategory',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'city',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'verified',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'account_profile_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'account_profile_auth_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'product',
      dartName: 'Product',
      schema: 'public',
      module: 'vyaparsetu_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'producerProfileId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'pricePaise',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'unit',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'piece\'',
        ),
        _isp.ColumnDefinition(
          name: 'minimumOrderQuantity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'city',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'craft',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ProductStatus',
          columnDefault: '\'draft\'',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'product_fk_0',
          columns: ['producerProfileId'],
          referenceTable: 'account_profile',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'product_producer_profile_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'producerProfileId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'product_photo',
      dartName: 'ProductPhoto',
      schema: 'public',
      module: 'vyaparsetu_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'productId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'bytes',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'product_photo_fk_0',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'product_photo_product_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'trade_request',
      dartName: 'TradeRequest',
      schema: 'public',
      module: 'vyaparsetu_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'productId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'buyerProfileId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'producerProfileId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'productName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'quantity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'requirements',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TradeStatus',
          columnDefault: '\'requested\'',
        ),
        _isp.ColumnDefinition(
          name: 'totalPaise',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'trade_request_fk_0',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'trade_request_fk_1',
          columns: ['buyerProfileId'],
          referenceTable: 'account_profile',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'trade_request_fk_2',
          columns: ['producerProfileId'],
          referenceTable: 'account_profile',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'trade_request_buyer_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'buyerProfileId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'trade_request_producer_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'producerProfileId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  static String? getClassNameFromObjectJson(dynamic data) =>
      _is.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i9dsm4op.AccountProfile) {
      return _i9dsm4op.AccountProfile.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _i1ko12if.MarketplaceRole) {
      return _i1ko12if.MarketplaceRole.fromJson(data) as T;
    }
    if (t == _i8ctgxfn.Product) {
      return _i8ctgxfn.Product.fromJson(data) as T;
    }
    if (t == _i1druvxr.ProductDraftException) {
      return _i1druvxr.ProductDraftException.fromJson(data) as T;
    }
    if (t == _ihhflbx4.ProductPhoto) {
      return _ihhflbx4.ProductPhoto.fromJson(data) as T;
    }
    if (t == _izdy7rp7.ProductStatus) {
      return _izdy7rp7.ProductStatus.fromJson(data) as T;
    }
    if (t == _ip8pwhpv.ProfileException) {
      return _ip8pwhpv.ProfileException.fromJson(data) as T;
    }
    if (t == _ixjhwvo7.TradeRequest) {
      return _ixjhwvo7.TradeRequest.fromJson(data) as T;
    }
    if (t == _ieevlvna.TradeStatus) {
      return _ieevlvna.TradeStatus.fromJson(data) as T;
    }
    if (t == _is.getType<_i9dsm4op.AccountProfile?>()) {
      return (data != null ? _i9dsm4op.AccountProfile.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1ko12if.MarketplaceRole?>()) {
      return (data != null ? _i1ko12if.MarketplaceRole.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8ctgxfn.Product?>()) {
      return (data != null ? _i8ctgxfn.Product.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1druvxr.ProductDraftException?>()) {
      return (data != null
              ? _i1druvxr.ProductDraftException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihhflbx4.ProductPhoto?>()) {
      return (data != null ? _ihhflbx4.ProductPhoto.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izdy7rp7.ProductStatus?>()) {
      return (data != null ? _izdy7rp7.ProductStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ip8pwhpv.ProfileException?>()) {
      return (data != null ? _ip8pwhpv.ProfileException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixjhwvo7.TradeRequest?>()) {
      return (data != null ? _ixjhwvo7.TradeRequest.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ieevlvna.TradeStatus?>()) {
      return (data != null ? _ieevlvna.TradeStatus.fromJson(data) : null) as T;
    }
    if (t == List<_iiz32gqo.Product>) {
      return (data as List)
              .map((e) => deserialize<_iiz32gqo.Product>(e))
              .toList()
          as T;
    }
    if (t == List<_ij7yvnp4.TradeRequest>) {
      return (data as List)
              .map((e) => deserialize<_ij7yvnp4.TradeRequest>(e))
              .toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _is.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i9dsm4op.AccountProfile => 'AccountProfile',
      _izw8z7ou.Greeting => 'Greeting',
      _i1ko12if.MarketplaceRole => 'MarketplaceRole',
      _i8ctgxfn.Product => 'Product',
      _i1druvxr.ProductDraftException => 'ProductDraftException',
      _ihhflbx4.ProductPhoto => 'ProductPhoto',
      _izdy7rp7.ProductStatus => 'ProductStatus',
      _ip8pwhpv.ProfileException => 'ProfileException',
      _ixjhwvo7.TradeRequest => 'TradeRequest',
      _ieevlvna.TradeStatus => 'TradeStatus',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'vyaparsetu_ai.',
        '',
      );
    }

    switch (data) {
      case _i9dsm4op.AccountProfile():
        return 'AccountProfile';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i1ko12if.MarketplaceRole():
        return 'MarketplaceRole';
      case _i8ctgxfn.Product():
        return 'Product';
      case _i1druvxr.ProductDraftException():
        return 'ProductDraftException';
      case _ihhflbx4.ProductPhoto():
        return 'ProductPhoto';
      case _izdy7rp7.ProductStatus():
        return 'ProductStatus';
      case _ip8pwhpv.ProfileException():
        return 'ProfileException';
      case _ixjhwvo7.TradeRequest():
        return 'TradeRequest';
      case _ieevlvna.TradeStatus():
        return 'TradeStatus';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccountProfile') {
      return deserialize<_i9dsm4op.AccountProfile>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'MarketplaceRole') {
      return deserialize<_i1ko12if.MarketplaceRole>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i8ctgxfn.Product>(data['data']);
    }
    if (dataClassName == 'ProductDraftException') {
      return deserialize<_i1druvxr.ProductDraftException>(data['data']);
    }
    if (dataClassName == 'ProductPhoto') {
      return deserialize<_ihhflbx4.ProductPhoto>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_izdy7rp7.ProductStatus>(data['data']);
    }
    if (dataClassName == 'ProfileException') {
      return deserialize<_ip8pwhpv.ProfileException>(data['data']);
    }
    if (dataClassName == 'TradeRequest') {
      return deserialize<_ixjhwvo7.TradeRequest>(data['data']);
    }
    if (dataClassName == 'TradeStatus') {
      return deserialize<_ieevlvna.TradeStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iais.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacs.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('vyaparsetu_ai', this);
    _iacs.Protocol().registerHostProtocol('vyaparsetu_ai', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i9dsm4op.AccountProfile:
        return _i9dsm4op.AccountProfile.t;
      case _i8ctgxfn.Product:
        return _i8ctgxfn.Product.t;
      case _ihhflbx4.ProductPhoto:
        return _ihhflbx4.ProductPhoto.t;
      case _ixjhwvo7.TradeRequest:
        return _ixjhwvo7.TradeRequest.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  List<_isp.TableDefinition> getOwnTableDefinitions() => _ownTableDefinitions;

  @override
  String getModuleName() => 'vyaparsetu_ai';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
