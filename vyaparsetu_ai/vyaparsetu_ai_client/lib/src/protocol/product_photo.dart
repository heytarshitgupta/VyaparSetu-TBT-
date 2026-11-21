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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ProductPhoto
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      bytes: _isc.ByteDataJsonExtension.fromJson(jsonSerialization['bytes']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int productId;

  _idt.ByteData bytes;

  /// Returns a shallow copy of this [ProductPhoto]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
