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

abstract class CommunityCreationPermission
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CommunityCreationPermission._({
    this.id,
    required this.email,
    required this.profileId,
    required this.grantedByEmail,
    required this.grantedByProfileId,
    required this.grantedAt,
    this.revokedAt,
    required this.isActive,
  });

  factory CommunityCreationPermission({
    int? id,
    required String email,
    required int profileId,
    required String grantedByEmail,
    required int grantedByProfileId,
    required DateTime grantedAt,
    DateTime? revokedAt,
    required bool isActive,
  }) = _CommunityCreationPermissionImpl;

  factory CommunityCreationPermission.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CommunityCreationPermission(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      profileId: jsonSerialization['profileId'] as int,
      grantedByEmail: jsonSerialization['grantedByEmail'] as String,
      grantedByProfileId: jsonSerialization['grantedByProfileId'] as int,
      grantedAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['grantedAt']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String email;

  int profileId;

  String grantedByEmail;

  int grantedByProfileId;

  DateTime grantedAt;

  DateTime? revokedAt;

  bool isActive;

  /// Returns a shallow copy of this [CommunityCreationPermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CommunityCreationPermission copyWith({
    int? id,
    String? email,
    int? profileId,
    String? grantedByEmail,
    int? grantedByProfileId,
    DateTime? grantedAt,
    DateTime? revokedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommunityCreationPermission',
      if (id != null) 'id': id,
      'email': email,
      'profileId': profileId,
      'grantedByEmail': grantedByEmail,
      'grantedByProfileId': grantedByProfileId,
      'grantedAt': grantedAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommunityCreationPermission',
      if (id != null) 'id': id,
      'email': email,
      'profileId': profileId,
      'grantedByEmail': grantedByEmail,
      'grantedByProfileId': grantedByProfileId,
      'grantedAt': grantedAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommunityCreationPermissionImpl extends CommunityCreationPermission {
  _CommunityCreationPermissionImpl({
    int? id,
    required String email,
    required int profileId,
    required String grantedByEmail,
    required int grantedByProfileId,
    required DateTime grantedAt,
    DateTime? revokedAt,
    required bool isActive,
  }) : super._(
          id: id,
          email: email,
          profileId: profileId,
          grantedByEmail: grantedByEmail,
          grantedByProfileId: grantedByProfileId,
          grantedAt: grantedAt,
          revokedAt: revokedAt,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [CommunityCreationPermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CommunityCreationPermission copyWith({
    Object? id = _Undefined,
    String? email,
    int? profileId,
    String? grantedByEmail,
    int? grantedByProfileId,
    DateTime? grantedAt,
    Object? revokedAt = _Undefined,
    bool? isActive,
  }) {
    return CommunityCreationPermission(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      profileId: profileId ?? this.profileId,
      grantedByEmail: grantedByEmail ?? this.grantedByEmail,
      grantedByProfileId: grantedByProfileId ?? this.grantedByProfileId,
      grantedAt: grantedAt ?? this.grantedAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
