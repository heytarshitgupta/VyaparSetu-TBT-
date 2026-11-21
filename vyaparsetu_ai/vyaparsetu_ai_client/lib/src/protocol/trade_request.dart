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
import 'trade_status.dart' as _ieevlvna;

abstract class TradeRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TradeRequest._({
    this.id,
    required this.productId,
    required this.buyerProfileId,
    required this.producerProfileId,
    required this.productName,
    required this.quantity,
    required this.requirements,
    _ieevlvna.TradeStatus? status,
    this.totalPaise,
    required this.createdAt,
  }) : status = status ?? _ieevlvna.TradeStatus.requested;

  factory TradeRequest({
    int? id,
    required int productId,
    required int buyerProfileId,
    required int producerProfileId,
    required String productName,
    required int quantity,
    required String requirements,
    _ieevlvna.TradeStatus? status,
    int? totalPaise,
    required DateTime createdAt,
  }) = _TradeRequestImpl;

  factory TradeRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return TradeRequest(
      id: jsonSerialization['id'] as int?,
      productId: jsonSerialization['productId'] as int,
      buyerProfileId: jsonSerialization['buyerProfileId'] as int,
      producerProfileId: jsonSerialization['producerProfileId'] as int,
      productName: jsonSerialization['productName'] as String,
      quantity: jsonSerialization['quantity'] as int,
      requirements: jsonSerialization['requirements'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _ieevlvna.TradeStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      totalPaise: jsonSerialization['totalPaise'] as int?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int productId;

  int buyerProfileId;

  int producerProfileId;

  String productName;

  int quantity;

  String requirements;

  _ieevlvna.TradeStatus status;

  int? totalPaise;

  DateTime createdAt;

  /// Returns a shallow copy of this [TradeRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TradeRequest copyWith({
    int? id,
    int? productId,
    int? buyerProfileId,
    int? producerProfileId,
    String? productName,
    int? quantity,
    String? requirements,
    _ieevlvna.TradeStatus? status,
    int? totalPaise,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TradeRequest',
      if (id != null) 'id': id,
      'productId': productId,
      'buyerProfileId': buyerProfileId,
      'producerProfileId': producerProfileId,
      'productName': productName,
      'quantity': quantity,
      'requirements': requirements,
      'status': status.toJson(),
      if (totalPaise != null) 'totalPaise': totalPaise,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TradeRequest',
      if (id != null) 'id': id,
      'productId': productId,
      'buyerProfileId': buyerProfileId,
      'producerProfileId': producerProfileId,
      'productName': productName,
      'quantity': quantity,
      'requirements': requirements,
      'status': status.toJson(),
      if (totalPaise != null) 'totalPaise': totalPaise,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TradeRequestImpl extends TradeRequest {
  _TradeRequestImpl({
    int? id,
    required int productId,
    required int buyerProfileId,
    required int producerProfileId,
    required String productName,
    required int quantity,
    required String requirements,
    _ieevlvna.TradeStatus? status,
    int? totalPaise,
    required DateTime createdAt,
  }) : super._(
         id: id,
         productId: productId,
         buyerProfileId: buyerProfileId,
         producerProfileId: producerProfileId,
         productName: productName,
         quantity: quantity,
         requirements: requirements,
         status: status,
         totalPaise: totalPaise,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TradeRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TradeRequest copyWith({
    Object? id = _Undefined,
    int? productId,
    int? buyerProfileId,
    int? producerProfileId,
    String? productName,
    int? quantity,
    String? requirements,
    _ieevlvna.TradeStatus? status,
    Object? totalPaise = _Undefined,
    DateTime? createdAt,
  }) {
    return TradeRequest(
      id: id is int? ? id : this.id,
      productId: productId ?? this.productId,
      buyerProfileId: buyerProfileId ?? this.buyerProfileId,
      producerProfileId: producerProfileId ?? this.producerProfileId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      requirements: requirements ?? this.requirements,
      status: status ?? this.status,
      totalPaise: totalPaise is int? ? totalPaise : this.totalPaise,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
