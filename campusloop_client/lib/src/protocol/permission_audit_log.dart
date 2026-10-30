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

abstract class PermissionAuditLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PermissionAuditLog._({
    this.id,
    required this.action,
    required this.adminEmail,
    required this.adminProfileId,
    required this.targetEmail,
    required this.targetProfileId,
    this.reason,
    required this.timestamp,
  });

  factory PermissionAuditLog({
    int? id,
    required String action,
    required String adminEmail,
    required int adminProfileId,
    required String targetEmail,
    required int targetProfileId,
    String? reason,
    required DateTime timestamp,
  }) = _PermissionAuditLogImpl;

  factory PermissionAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return PermissionAuditLog(
      id: jsonSerialization['id'] as int?,
      action: jsonSerialization['action'] as String,
      adminEmail: jsonSerialization['adminEmail'] as String,
      adminProfileId: jsonSerialization['adminProfileId'] as int,
      targetEmail: jsonSerialization['targetEmail'] as String,
      targetProfileId: jsonSerialization['targetProfileId'] as int,
      reason: jsonSerialization['reason'] as String?,
      timestamp:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String action;

  String adminEmail;

  int adminProfileId;

  String targetEmail;

  int targetProfileId;

  String? reason;

  DateTime timestamp;

  /// Returns a shallow copy of this [PermissionAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PermissionAuditLog copyWith({
    int? id,
    String? action,
    String? adminEmail,
    int? adminProfileId,
    String? targetEmail,
    int? targetProfileId,
    String? reason,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PermissionAuditLog',
      if (id != null) 'id': id,
      'action': action,
      'adminEmail': adminEmail,
      'adminProfileId': adminProfileId,
      'targetEmail': targetEmail,
      'targetProfileId': targetProfileId,
      if (reason != null) 'reason': reason,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PermissionAuditLog',
      if (id != null) 'id': id,
      'action': action,
      'adminEmail': adminEmail,
      'adminProfileId': adminProfileId,
      'targetEmail': targetEmail,
      'targetProfileId': targetProfileId,
      if (reason != null) 'reason': reason,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PermissionAuditLogImpl extends PermissionAuditLog {
  _PermissionAuditLogImpl({
    int? id,
    required String action,
    required String adminEmail,
    required int adminProfileId,
    required String targetEmail,
    required int targetProfileId,
    String? reason,
    required DateTime timestamp,
  }) : super._(
          id: id,
          action: action,
          adminEmail: adminEmail,
          adminProfileId: adminProfileId,
          targetEmail: targetEmail,
          targetProfileId: targetProfileId,
          reason: reason,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [PermissionAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PermissionAuditLog copyWith({
    Object? id = _Undefined,
    String? action,
    String? adminEmail,
    int? adminProfileId,
    String? targetEmail,
    int? targetProfileId,
    Object? reason = _Undefined,
    DateTime? timestamp,
  }) {
    return PermissionAuditLog(
      id: id is int? ? id : this.id,
      action: action ?? this.action,
      adminEmail: adminEmail ?? this.adminEmail,
      adminProfileId: adminProfileId ?? this.adminProfileId,
      targetEmail: targetEmail ?? this.targetEmail,
      targetProfileId: targetProfileId ?? this.targetProfileId,
      reason: reason is String? ? reason : this.reason,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
