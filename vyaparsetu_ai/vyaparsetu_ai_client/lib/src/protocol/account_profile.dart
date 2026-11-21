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
  });

  factory AccountProfile({
    int? id,
    required _isc.UuidValue authUserId,
    required String displayName,
    required _i1ko12if.MarketplaceRole role,
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
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String displayName;

  _i1ko12if.MarketplaceRole role;

  /// Returns a shallow copy of this [AccountProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountProfile copyWith({
    int? id,
    _isc.UuidValue? authUserId,
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
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         role: role,
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
  }) {
    return AccountProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
    );
  }
}
