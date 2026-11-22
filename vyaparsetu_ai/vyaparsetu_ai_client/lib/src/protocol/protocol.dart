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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:vyaparsetu_ai_client/src/protocol/app_notification.dart'
    as _iyi705kw;
import 'package:vyaparsetu_ai_client/src/protocol/buyer_requirement.dart'
    as _izbpoeda;
import 'package:vyaparsetu_ai_client/src/protocol/product.dart' as _idm7l56a;
import 'package:vyaparsetu_ai_client/src/protocol/trade_request.dart'
    as _ir66x6wy;
import 'package:vyaparsetu_ai_client/src/protocol/wishlist_item.dart'
    as _i0vcfhnc;
import 'account_profile.dart' as _i9dsm4op;
import 'app_notification.dart' as _ip1vhxmg;
import 'buyer_requirement.dart' as _ivd72sic;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'marketplace_role.dart' as _i1ko12if;
import 'product.dart' as _i8ctgxfn;
import 'product_draft_exception.dart' as _i1druvxr;
import 'product_photo.dart' as _ihhflbx4;
import 'product_status.dart' as _izdy7rp7;
import 'profile_exception.dart' as _ip8pwhpv;
import 'requirement_response.dart' as _iue4ntea;
import 'trade_request.dart' as _ixjhwvo7;
import 'trade_status.dart' as _ieevlvna;
import 'wishlist_item.dart' as _iq96ht7h;
export 'account_profile.dart';
export 'app_notification.dart';
export 'buyer_requirement.dart';
export 'greetings/greeting.dart';
export 'marketplace_role.dart';
export 'product.dart';
export 'product_draft_exception.dart';
export 'product_photo.dart';
export 'product_status.dart';
export 'profile_exception.dart';
export 'requirement_response.dart';
export 'trade_request.dart';
export 'trade_status.dart';
export 'wishlist_item.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager
    implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata =>
      _isc.ProtocolDeserialization.cached(
        this,
        types: const [
          _isc.getType<_i9dsm4op.AccountProfile>,
          _isc.getType<_ip1vhxmg.AppNotification>,
          _isc.getType<_ivd72sic.BuyerRequirement>,
          _isc.getType<_izw8z7ou.Greeting>,
          _isc.getType<_i1ko12if.MarketplaceRole>,
          _isc.getType<_i8ctgxfn.Product>,
          _isc.getType<_i1druvxr.ProductDraftException>,
          _isc.getType<_ihhflbx4.ProductPhoto>,
          _isc.getType<_izdy7rp7.ProductStatus>,
          _isc.getType<_ip8pwhpv.ProfileException>,
          _isc.getType<_iue4ntea.RequirementResponse>,
          _isc.getType<_ixjhwvo7.TradeRequest>,
          _isc.getType<_ieevlvna.TradeStatus>,
          _isc.getType<_iq96ht7h.WishlistItem>,
          _isc.getType<_i9dsm4op.AccountProfile?>,
          _isc.getType<_ip1vhxmg.AppNotification?>,
          _isc.getType<_ivd72sic.BuyerRequirement?>,
          _isc.getType<_izw8z7ou.Greeting?>,
          _isc.getType<_i1ko12if.MarketplaceRole?>,
          _isc.getType<_i8ctgxfn.Product?>,
          _isc.getType<_i1druvxr.ProductDraftException?>,
          _isc.getType<_ihhflbx4.ProductPhoto?>,
          _isc.getType<_izdy7rp7.ProductStatus?>,
          _isc.getType<_ip8pwhpv.ProfileException?>,
          _isc.getType<_iue4ntea.RequirementResponse?>,
          _isc.getType<_ixjhwvo7.TradeRequest?>,
          _isc.getType<_ieevlvna.TradeStatus?>,
          _isc.getType<_iq96ht7h.WishlistItem?>,
          _isc.getType<List<_i0vcfhnc.WishlistItem>>,
          _isc.getType<List<_izbpoeda.BuyerRequirement>>,
          _isc.getType<List<_iyi705kw.AppNotification>>,
          _isc.getType<Map<String, int>>,
          _isc.getType<List<_idm7l56a.Product>>,
          _isc.getType<List<_ir66x6wy.TradeRequest>>,
          _isc.getType<Map<String, String>>,
        ],
        modules: const [
          _iaic.Protocol.new,
          _iacc.Protocol.new,
        ],
        classNames: const [
          'AccountProfile',
          'AppNotification',
          'BuyerRequirement',
          'Greeting',
          'MarketplaceRole',
          'Product',
          'ProductDraftException',
          'ProductPhoto',
          'ProductStatus',
          'ProfileException',
          'RequirementResponse',
          'TradeRequest',
          'TradeStatus',
          'WishlistItem',
        ],
      );

  static String? getClassNameFromObjectJson(dynamic data) =>
      _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i9dsm4op.AccountProfile) {
      return _i9dsm4op.AccountProfile.fromJson(data) as T;
    }
    if (t == _ip1vhxmg.AppNotification) {
      return _ip1vhxmg.AppNotification.fromJson(data) as T;
    }
    if (t == _ivd72sic.BuyerRequirement) {
      return _ivd72sic.BuyerRequirement.fromJson(data) as T;
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
    if (t == _iue4ntea.RequirementResponse) {
      return _iue4ntea.RequirementResponse.fromJson(data) as T;
    }
    if (t == _ixjhwvo7.TradeRequest) {
      return _ixjhwvo7.TradeRequest.fromJson(data) as T;
    }
    if (t == _ieevlvna.TradeStatus) {
      return _ieevlvna.TradeStatus.fromJson(data) as T;
    }
    if (t == _iq96ht7h.WishlistItem) {
      return _iq96ht7h.WishlistItem.fromJson(data) as T;
    }
    if (t == _isc.getType<_i9dsm4op.AccountProfile?>()) {
      return (data != null ? _i9dsm4op.AccountProfile.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip1vhxmg.AppNotification?>()) {
      return (data != null ? _ip1vhxmg.AppNotification.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivd72sic.BuyerRequirement?>()) {
      return (data != null ? _ivd72sic.BuyerRequirement.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1ko12if.MarketplaceRole?>()) {
      return (data != null ? _i1ko12if.MarketplaceRole.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8ctgxfn.Product?>()) {
      return (data != null ? _i8ctgxfn.Product.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1druvxr.ProductDraftException?>()) {
      return (data != null
              ? _i1druvxr.ProductDraftException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihhflbx4.ProductPhoto?>()) {
      return (data != null ? _ihhflbx4.ProductPhoto.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izdy7rp7.ProductStatus?>()) {
      return (data != null ? _izdy7rp7.ProductStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip8pwhpv.ProfileException?>()) {
      return (data != null ? _ip8pwhpv.ProfileException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iue4ntea.RequirementResponse?>()) {
      return (data != null
              ? _iue4ntea.RequirementResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ixjhwvo7.TradeRequest?>()) {
      return (data != null ? _ixjhwvo7.TradeRequest.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ieevlvna.TradeStatus?>()) {
      return (data != null ? _ieevlvna.TradeStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iq96ht7h.WishlistItem?>()) {
      return (data != null ? _iq96ht7h.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == List<_i0vcfhnc.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i0vcfhnc.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == List<_izbpoeda.BuyerRequirement>) {
      return (data as List)
              .map((e) => deserialize<_izbpoeda.BuyerRequirement>(e))
              .toList()
          as T;
    }
    if (t == List<_iyi705kw.AppNotification>) {
      return (data as List)
              .map((e) => deserialize<_iyi705kw.AppNotification>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_idm7l56a.Product>) {
      return (data as List)
              .map((e) => deserialize<_idm7l56a.Product>(e))
              .toList()
          as T;
    }
    if (t == List<_ir66x6wy.TradeRequest>) {
      return (data as List)
              .map((e) => deserialize<_ir66x6wy.TradeRequest>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _isc.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i9dsm4op.AccountProfile => 'AccountProfile',
      _ip1vhxmg.AppNotification => 'AppNotification',
      _ivd72sic.BuyerRequirement => 'BuyerRequirement',
      _izw8z7ou.Greeting => 'Greeting',
      _i1ko12if.MarketplaceRole => 'MarketplaceRole',
      _i8ctgxfn.Product => 'Product',
      _i1druvxr.ProductDraftException => 'ProductDraftException',
      _ihhflbx4.ProductPhoto => 'ProductPhoto',
      _izdy7rp7.ProductStatus => 'ProductStatus',
      _ip8pwhpv.ProfileException => 'ProfileException',
      _iue4ntea.RequirementResponse => 'RequirementResponse',
      _ixjhwvo7.TradeRequest => 'TradeRequest',
      _ieevlvna.TradeStatus => 'TradeStatus',
      _iq96ht7h.WishlistItem => 'WishlistItem',
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
      case _ip1vhxmg.AppNotification():
        return 'AppNotification';
      case _ivd72sic.BuyerRequirement():
        return 'BuyerRequirement';
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
      case _iue4ntea.RequirementResponse():
        return 'RequirementResponse';
      case _ixjhwvo7.TradeRequest():
        return 'TradeRequest';
      case _ieevlvna.TradeStatus():
        return 'TradeStatus';
      case _iq96ht7h.WishlistItem():
        return 'WishlistItem';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
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
    if (dataClassName == 'AppNotification') {
      return deserialize<_ip1vhxmg.AppNotification>(data['data']);
    }
    if (dataClassName == 'BuyerRequirement') {
      return deserialize<_ivd72sic.BuyerRequirement>(data['data']);
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
    if (dataClassName == 'RequirementResponse') {
      return deserialize<_iue4ntea.RequirementResponse>(data['data']);
    }
    if (dataClassName == 'TradeRequest') {
      return deserialize<_ixjhwvo7.TradeRequest>(data['data']);
    }
    if (dataClassName == 'TradeStatus') {
      return deserialize<_ieevlvna.TradeStatus>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_iq96ht7h.WishlistItem>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iaic.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacc.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('vyaparsetu_ai', this);
    _iacc.Protocol().registerHostProtocol('vyaparsetu_ai', this);
  }

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
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
