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
import 'package:campusloop_client/src/protocol/protocol.dart' as _ibp2gf5m;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class StudyPartnerRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudyPartnerRequest._({
    this.id,
    required this.fromProfileId,
    required this.toProfileId,
    required this.status,
    required this.matchingSubjects,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudyPartnerRequest({
    int? id,
    required int fromProfileId,
    required int toProfileId,
    required String status,
    required List<String> matchingSubjects,
    String? message,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyPartnerRequestImpl;

  factory StudyPartnerRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudyPartnerRequest(
      id: jsonSerialization['id'] as int?,
      fromProfileId: jsonSerialization['fromProfileId'] as int,
      toProfileId: jsonSerialization['toProfileId'] as int,
      status: jsonSerialization['status'] as String,
      matchingSubjects: _ibp2gf5m.Protocol()
          .deserialize<List<String>>(jsonSerialization['matchingSubjects']),
      message: jsonSerialization['message'] as String?,
      createdAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int fromProfileId;

  int toProfileId;

  String status;

  List<String> matchingSubjects;

  String? message;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [StudyPartnerRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudyPartnerRequest copyWith({
    int? id,
    int? fromProfileId,
    int? toProfileId,
    String? status,
    List<String>? matchingSubjects,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudyPartnerRequest',
      if (id != null) 'id': id,
      'fromProfileId': fromProfileId,
      'toProfileId': toProfileId,
      'status': status,
      'matchingSubjects': matchingSubjects.toJson(),
      if (message != null) 'message': message,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudyPartnerRequest',
      if (id != null) 'id': id,
      'fromProfileId': fromProfileId,
      'toProfileId': toProfileId,
      'status': status,
      'matchingSubjects': matchingSubjects.toJson(),
      if (message != null) 'message': message,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudyPartnerRequestImpl extends StudyPartnerRequest {
  _StudyPartnerRequestImpl({
    int? id,
    required int fromProfileId,
    required int toProfileId,
    required String status,
    required List<String> matchingSubjects,
    String? message,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          fromProfileId: fromProfileId,
          toProfileId: toProfileId,
          status: status,
          matchingSubjects: matchingSubjects,
          message: message,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [StudyPartnerRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudyPartnerRequest copyWith({
    Object? id = _Undefined,
    int? fromProfileId,
    int? toProfileId,
    String? status,
    List<String>? matchingSubjects,
    Object? message = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudyPartnerRequest(
      id: id is int? ? id : this.id,
      fromProfileId: fromProfileId ?? this.fromProfileId,
      toProfileId: toProfileId ?? this.toProfileId,
      status: status ?? this.status,
      matchingSubjects:
          matchingSubjects ?? this.matchingSubjects.map((e0) => e0).toList(),
      message: message is String? ? message : this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
