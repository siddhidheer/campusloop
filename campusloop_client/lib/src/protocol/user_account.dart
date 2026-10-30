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

abstract class UserAccount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserAccount._({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.isEmailVerified,
    this.emailVerifiedAt,
    required this.role,
    required this.canCreateCommunity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAccount({
    int? id,
    required String email,
    required String passwordHash,
    required String salt,
    required bool isEmailVerified,
    DateTime? emailVerifiedAt,
    required String role,
    required bool canCreateCommunity,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserAccountImpl;

  factory UserAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAccount(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      salt: jsonSerialization['salt'] as String,
      isEmailVerified:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['isEmailVerified']),
      emailVerifiedAt: jsonSerialization['emailVerifiedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['emailVerifiedAt']),
      role: jsonSerialization['role'] as String,
      canCreateCommunity: _isc.BoolJsonExtension.fromJson(
          jsonSerialization['canCreateCommunity']),
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

  String email;

  String passwordHash;

  String salt;

  bool isEmailVerified;

  DateTime? emailVerifiedAt;

  String role;

  bool canCreateCommunity;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserAccount copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? salt,
    bool? isEmailVerified,
    DateTime? emailVerifiedAt,
    String? role,
    bool? canCreateCommunity,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAccount',
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
      'isEmailVerified': isEmailVerified,
      if (emailVerifiedAt != null) 'emailVerifiedAt': emailVerifiedAt?.toJson(),
      'role': role,
      'canCreateCommunity': canCreateCommunity,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserAccount',
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
      'isEmailVerified': isEmailVerified,
      if (emailVerifiedAt != null) 'emailVerifiedAt': emailVerifiedAt?.toJson(),
      'role': role,
      'canCreateCommunity': canCreateCommunity,
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

class _UserAccountImpl extends UserAccount {
  _UserAccountImpl({
    int? id,
    required String email,
    required String passwordHash,
    required String salt,
    required bool isEmailVerified,
    DateTime? emailVerifiedAt,
    required String role,
    required bool canCreateCommunity,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          email: email,
          passwordHash: passwordHash,
          salt: salt,
          isEmailVerified: isEmailVerified,
          emailVerifiedAt: emailVerifiedAt,
          role: role,
          canCreateCommunity: canCreateCommunity,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserAccount copyWith({
    Object? id = _Undefined,
    String? email,
    String? passwordHash,
    String? salt,
    bool? isEmailVerified,
    Object? emailVerifiedAt = _Undefined,
    String? role,
    bool? canCreateCommunity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAccount(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      emailVerifiedAt:
          emailVerifiedAt is DateTime? ? emailVerifiedAt : this.emailVerifiedAt,
      role: role ?? this.role,
      canCreateCommunity: canCreateCommunity ?? this.canCreateCommunity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
