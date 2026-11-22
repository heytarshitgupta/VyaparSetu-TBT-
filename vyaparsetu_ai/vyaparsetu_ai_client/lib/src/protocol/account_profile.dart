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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'marketplace_role.dart' as _i1ko12if;

abstract class AccountProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AccountProfile._({
    this.id,
    required this.authUserId,
    required this.displayName,
    required this.role,
    this.businessName,
    this.craftCategory,
    this.city,
    this.state,
    this.address,
    bool? verified,
  }) : verified = verified ?? true;

  factory AccountProfile({
    int? id,
    required _isc.UuidValue authUserId,
    required String displayName,
    required _i1ko12if.MarketplaceRole role,
    String? businessName,
    String? craftCategory,
    String? city,
    String? state,
    String? address,
    bool? verified,
  }) = _AccountProfileImpl;

  factory AccountProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountProfile(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      role: _i1ko12if.MarketplaceRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      businessName: jsonSerialization['businessName'] as String?,
      craftCategory: jsonSerialization['craftCategory'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      address: jsonSerialization['address'] as String?,
      verified: jsonSerialization['verified'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['verified']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String displayName;

  _i1ko12if.MarketplaceRole role;

  String? businessName;

  String? craftCategory;

  String? city;

  String? state;

  String? address;

  bool verified;

  /// Returns a shallow copy of this [AccountProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountProfile copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? displayName,
    _i1ko12if.MarketplaceRole? role,
    String? businessName,
    String? craftCategory,
    String? city,
    String? state,
    String? address,
    bool? verified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      'role': role.toJson(),
      if (businessName != null) 'businessName': businessName,
      if (craftCategory != null) 'craftCategory': craftCategory,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (address != null) 'address': address,
      'verified': verified,
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
      if (businessName != null) 'businessName': businessName,
      if (craftCategory != null) 'craftCategory': craftCategory,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (address != null) 'address': address,
      'verified': verified,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountProfileImpl extends AccountProfile {
  _AccountProfileImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String displayName,
    required _i1ko12if.MarketplaceRole role,
    String? businessName,
    String? craftCategory,
    String? city,
    String? state,
    String? address,
    bool? verified,
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         role: role,
         businessName: businessName,
         craftCategory: craftCategory,
         city: city,
         state: state,
         address: address,
         verified: verified,
       );

  /// Returns a shallow copy of this [AccountProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccountProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? displayName,
    _i1ko12if.MarketplaceRole? role,
    Object? businessName = _Undefined,
    Object? craftCategory = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? address = _Undefined,
    bool? verified,
  }) {
    return AccountProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      businessName: businessName is String? ? businessName : this.businessName,
      craftCategory: craftCategory is String?
          ? craftCategory
          : this.craftCategory,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      address: address is String? ? address : this.address,
      verified: verified ?? this.verified,
    );
  }
}
