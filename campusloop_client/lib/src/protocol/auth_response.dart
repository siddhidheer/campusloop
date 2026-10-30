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
import 'student_profile.dart' as _iovtxv26;

abstract class AuthResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuthResponse._({
    required this.success,
    required this.message,
    this.profile,
    this.requiresOtp,
    this.email,
    this.role,
    this.canCreateCommunity,
  });

  factory AuthResponse({
    required bool success,
    required String message,
    _iovtxv26.StudentProfile? profile,
    bool? requiresOtp,
    String? email,
    String? role,
    bool? canCreateCommunity,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      success: _isc.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String,
      profile: jsonSerialization['profile'] == null
          ? null
          : _ibp2gf5m.Protocol().deserialize<_iovtxv26.StudentProfile>(
              jsonSerialization['profile']),
      requiresOtp: jsonSerialization['requiresOtp'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['requiresOtp']),
      email: jsonSerialization['email'] as String?,
      role: jsonSerialization['role'] as String?,
      canCreateCommunity: jsonSerialization['canCreateCommunity'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['canCreateCommunity']),
    );
  }

  bool success;

  String message;

  _iovtxv26.StudentProfile? profile;

  bool? requiresOtp;

  String? email;

  String? role;

  bool? canCreateCommunity;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuthResponse copyWith({
    bool? success,
    String? message,
    _iovtxv26.StudentProfile? profile,
    bool? requiresOtp,
    String? email,
    String? role,
    bool? canCreateCommunity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      'message': message,
      if (profile != null) 'profile': profile?.toJson(),
      if (requiresOtp != null) 'requiresOtp': requiresOtp,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (canCreateCommunity != null) 'canCreateCommunity': canCreateCommunity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      'message': message,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      if (requiresOtp != null) 'requiresOtp': requiresOtp,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (canCreateCommunity != null) 'canCreateCommunity': canCreateCommunity,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required bool success,
    required String message,
    _iovtxv26.StudentProfile? profile,
    bool? requiresOtp,
    String? email,
    String? role,
    bool? canCreateCommunity,
  }) : super._(
          success: success,
          message: message,
          profile: profile,
          requiresOtp: requiresOtp,
          email: email,
          role: role,
          canCreateCommunity: canCreateCommunity,
        );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuthResponse copyWith({
    bool? success,
    String? message,
    Object? profile = _Undefined,
    Object? requiresOtp = _Undefined,
    Object? email = _Undefined,
    Object? role = _Undefined,
    Object? canCreateCommunity = _Undefined,
  }) {
    return AuthResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      profile: profile is _iovtxv26.StudentProfile?
          ? profile
          : this.profile?.copyWith(),
      requiresOtp: requiresOtp is bool? ? requiresOtp : this.requiresOtp,
      email: email is String? ? email : this.email,
      role: role is String? ? role : this.role,
      canCreateCommunity: canCreateCommunity is bool?
          ? canCreateCommunity
          : this.canCreateCommunity,
    );
  }
}
