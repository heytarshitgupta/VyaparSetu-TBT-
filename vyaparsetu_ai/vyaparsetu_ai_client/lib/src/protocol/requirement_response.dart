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

abstract class RequirementResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RequirementResponse._({
    this.id,
    required this.requirementId,
    required this.producerProfileId,
    required this.message,
    this.quotedPaise,
    String? status,
    required this.createdAt,
  }) : status = status ?? 'responded';

  factory RequirementResponse({
    int? id,
    required int requirementId,
    required int producerProfileId,
    required String message,
    int? quotedPaise,
    String? status,
    required DateTime createdAt,
  }) = _RequirementResponseImpl;

  factory RequirementResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return RequirementResponse(
      id: jsonSerialization['id'] as int?,
      requirementId: jsonSerialization['requirementId'] as int,
      producerProfileId: jsonSerialization['producerProfileId'] as int,
      message: jsonSerialization['message'] as String,
      quotedPaise: jsonSerialization['quotedPaise'] as int?,
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

  int requirementId;

  int producerProfileId;

  String message;

  int? quotedPaise;

  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [RequirementResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RequirementResponse copyWith({
    int? id,
    int? requirementId,
    int? producerProfileId,
    String? message,
    int? quotedPaise,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RequirementResponse',
      if (id != null) 'id': id,
      'requirementId': requirementId,
      'producerProfileId': producerProfileId,
      'message': message,
      if (quotedPaise != null) 'quotedPaise': quotedPaise,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RequirementResponse',
      if (id != null) 'id': id,
      'requirementId': requirementId,
      'producerProfileId': producerProfileId,
      'message': message,
      if (quotedPaise != null) 'quotedPaise': quotedPaise,
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

class _RequirementResponseImpl extends RequirementResponse {
  _RequirementResponseImpl({
    int? id,
    required int requirementId,
    required int producerProfileId,
    required String message,
    int? quotedPaise,
    String? status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         requirementId: requirementId,
         producerProfileId: producerProfileId,
         message: message,
         quotedPaise: quotedPaise,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RequirementResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RequirementResponse copyWith({
    Object? id = _Undefined,
    int? requirementId,
    int? producerProfileId,
    String? message,
    Object? quotedPaise = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return RequirementResponse(
      id: id is int? ? id : this.id,
      requirementId: requirementId ?? this.requirementId,
      producerProfileId: producerProfileId ?? this.producerProfileId,
      message: message ?? this.message,
      quotedPaise: quotedPaise is int? ? quotedPaise : this.quotedPaise,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
