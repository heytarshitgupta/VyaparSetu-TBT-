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
import 'product_status.dart' as _izdy7rp7;

abstract class Product
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Product._({
    this.id,
    required this.producerProfileId,
    required this.name,
    required this.description,
    _izdy7rp7.ProductStatus? status,
  }) : status = status ?? _izdy7rp7.ProductStatus.draft;

  factory Product({
    int? id,
    required int producerProfileId,
    required String name,
    required String description,
    _izdy7rp7.ProductStatus? status,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      producerProfileId: jsonSerialization['producerProfileId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _izdy7rp7.ProductStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int producerProfileId;

  String name;

  String description;

  _izdy7rp7.ProductStatus status;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Product copyWith({
    int? id,
    int? producerProfileId,
    String? name,
    String? description,
    _izdy7rp7.ProductStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'producerProfileId': producerProfileId,
      'name': name,
      'description': description,
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'producerProfileId': producerProfileId,
      'name': name,
      'description': description,
      'status': status.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    int? id,
    required int producerProfileId,
    required String name,
    required String description,
    _izdy7rp7.ProductStatus? status,
  }) : super._(
         id: id,
         producerProfileId: producerProfileId,
         name: name,
         description: description,
         status: status,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    int? producerProfileId,
    String? name,
    String? description,
    _izdy7rp7.ProductStatus? status,
  }) {
    return Product(
      id: id is int? ? id : this.id,
      producerProfileId: producerProfileId ?? this.producerProfileId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
