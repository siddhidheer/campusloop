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

abstract class EmailVerificationOtp
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EmailVerificationOtp._({
    this.id,
    required this.email,
    required this.otpHash,
    required this.salt,
    required this.attempts,
    required this.isUsed,
    required this.createdAt,
    required this.expiresAt,
    required this.lastSentAt,
  });

  factory EmailVerificationOtp({
    int? id,
    required String email,
    required String otpHash,
    required String salt,
    required int attempts,
    required bool isUsed,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSentAt,
  }) = _EmailVerificationOtpImpl;

  factory EmailVerificationOtp.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailVerificationOtp(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      otpHash: jsonSerialization['otpHash'] as String,
      salt: jsonSerialization['salt'] as String,
      attempts: jsonSerialization['attempts'] as int,
      isUsed: _isc.BoolJsonExtension.fromJson(jsonSerialization['isUsed']),
      createdAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      lastSentAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['lastSentAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String email;

  String otpHash;

  String salt;

  int attempts;

  bool isUsed;

  DateTime createdAt;

  DateTime expiresAt;

  DateTime lastSentAt;

  /// Returns a shallow copy of this [EmailVerificationOtp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EmailVerificationOtp copyWith({
    int? id,
    String? email,
    String? otpHash,
    String? salt,
    int? attempts,
    bool? isUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSentAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailVerificationOtp',
      if (id != null) 'id': id,
      'email': email,
      'otpHash': otpHash,
      'salt': salt,
      'attempts': attempts,
      'isUsed': isUsed,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSentAt': lastSentAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmailVerificationOtp',
      if (id != null) 'id': id,
      'email': email,
      'otpHash': otpHash,
      'salt': salt,
      'attempts': attempts,
      'isUsed': isUsed,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      'lastSentAt': lastSentAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailVerificationOtpImpl extends EmailVerificationOtp {
  _EmailVerificationOtpImpl({
    int? id,
    required String email,
    required String otpHash,
    required String salt,
    required int attempts,
    required bool isUsed,
    required DateTime createdAt,
    required DateTime expiresAt,
    required DateTime lastSentAt,
  }) : super._(
          id: id,
          email: email,
          otpHash: otpHash,
          salt: salt,
          attempts: attempts,
          isUsed: isUsed,
          createdAt: createdAt,
          expiresAt: expiresAt,
          lastSentAt: lastSentAt,
        );

  /// Returns a shallow copy of this [EmailVerificationOtp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EmailVerificationOtp copyWith({
    Object? id = _Undefined,
    String? email,
    String? otpHash,
    String? salt,
    int? attempts,
    bool? isUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSentAt,
  }) {
    return EmailVerificationOtp(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      otpHash: otpHash ?? this.otpHash,
      salt: salt ?? this.salt,
      attempts: attempts ?? this.attempts,
      isUsed: isUsed ?? this.isUsed,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastSentAt: lastSentAt ?? this.lastSentAt,
    );
  }
}
