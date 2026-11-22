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

abstract class BuyerRequirement
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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

  String title;

  String description;

  String category;

  int quantity;

  int? budgetPaise;

  String? city;

  String? state;

  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [BuyerRequirement]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
