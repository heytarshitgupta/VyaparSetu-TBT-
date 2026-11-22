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

abstract class WishlistItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int buyerProfileId;

  int productId;

  DateTime createdAt;

  /// Returns a shallow copy of this [WishlistItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
