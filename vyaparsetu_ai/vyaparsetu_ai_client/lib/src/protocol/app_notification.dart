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

abstract class AppNotification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppNotification._({
    this.id,
    required this.profileId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    bool? isRead,
    required this.createdAt,
  }) : isRead = isRead ?? false;

  factory AppNotification({
    int? id,
    required int profileId,
    required String title,
    required String message,
    required String type,
    int? relatedId,
    bool? isRead,
    required DateTime createdAt,
  }) = _AppNotificationImpl;

  factory AppNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppNotification(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: jsonSerialization['type'] as String,
      relatedId: jsonSerialization['relatedId'] as int?,
      isRead: jsonSerialization['isRead'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int profileId;

  String title;

  String message;

  String type;

  int? relatedId;

  bool isRead;

  DateTime createdAt;

  /// Returns a shallow copy of this [AppNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppNotification copyWith({
    int? id,
    int? profileId,
    String? title,
    String? message,
    String? type,
    int? relatedId,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppNotification',
      if (id != null) 'id': id,
      'profileId': profileId,
      'title': title,
      'message': message,
      'type': type,
      if (relatedId != null) 'relatedId': relatedId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppNotification',
      if (id != null) 'id': id,
      'profileId': profileId,
      'title': title,
      'message': message,
      'type': type,
      if (relatedId != null) 'relatedId': relatedId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppNotificationImpl extends AppNotification {
  _AppNotificationImpl({
    int? id,
    required int profileId,
    required String title,
    required String message,
    required String type,
    int? relatedId,
    bool? isRead,
    required DateTime createdAt,
  }) : super._(
         id: id,
         profileId: profileId,
         title: title,
         message: message,
         type: type,
         relatedId: relatedId,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AppNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppNotification copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? title,
    String? message,
    String? type,
    Object? relatedId = _Undefined,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      relatedId: relatedId is int? ? relatedId : this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
