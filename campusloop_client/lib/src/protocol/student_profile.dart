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

abstract class StudentProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentProfile._({
    this.id,
    required this.displayName,
    required this.email,
    this.department,
    this.year,
    this.bio,
    required this.studySubjects,
    required this.interests,
    this.role,
    this.canCreateCommunity,
    this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentProfile({
    int? id,
    required String displayName,
    required String email,
    String? department,
    int? year,
    String? bio,
    required List<String> studySubjects,
    required List<String> interests,
    String? role,
    bool? canCreateCommunity,
    bool? isEmailVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudentProfileImpl;

  factory StudentProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentProfile(
      id: jsonSerialization['id'] as int?,
      displayName: jsonSerialization['displayName'] as String,
      email: jsonSerialization['email'] as String,
      department: jsonSerialization['department'] as String?,
      year: jsonSerialization['year'] as int?,
      bio: jsonSerialization['bio'] as String?,
      studySubjects: _ibp2gf5m.Protocol()
          .deserialize<List<String>>(jsonSerialization['studySubjects']),
      interests: _ibp2gf5m.Protocol()
          .deserialize<List<String>>(jsonSerialization['interests']),
      role: jsonSerialization['role'] as String?,
      canCreateCommunity: jsonSerialization['canCreateCommunity'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['canCreateCommunity']),
      isEmailVerified: jsonSerialization['isEmailVerified'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isEmailVerified']),
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

  String displayName;

  String email;

  String? department;

  int? year;

  String? bio;

  List<String> studySubjects;

  List<String> interests;

  String? role;

  bool? canCreateCommunity;

  bool? isEmailVerified;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentProfile copyWith({
    int? id,
    String? displayName,
    String? email,
    String? department,
    int? year,
    String? bio,
    List<String>? studySubjects,
    List<String>? interests,
    String? role,
    bool? canCreateCommunity,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentProfile',
      if (id != null) 'id': id,
      'displayName': displayName,
      'email': email,
      if (department != null) 'department': department,
      if (year != null) 'year': year,
      if (bio != null) 'bio': bio,
      'studySubjects': studySubjects.toJson(),
      'interests': interests.toJson(),
      if (role != null) 'role': role,
      if (canCreateCommunity != null) 'canCreateCommunity': canCreateCommunity,
      if (isEmailVerified != null) 'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentProfile',
      if (id != null) 'id': id,
      'displayName': displayName,
      'email': email,
      if (department != null) 'department': department,
      if (year != null) 'year': year,
      if (bio != null) 'bio': bio,
      'studySubjects': studySubjects.toJson(),
      'interests': interests.toJson(),
      if (role != null) 'role': role,
      if (canCreateCommunity != null) 'canCreateCommunity': canCreateCommunity,
      if (isEmailVerified != null) 'isEmailVerified': isEmailVerified,
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

class _StudentProfileImpl extends StudentProfile {
  _StudentProfileImpl({
    int? id,
    required String displayName,
    required String email,
    String? department,
    int? year,
    String? bio,
    required List<String> studySubjects,
    required List<String> interests,
    String? role,
    bool? canCreateCommunity,
    bool? isEmailVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          displayName: displayName,
          email: email,
          department: department,
          year: year,
          bio: bio,
          studySubjects: studySubjects,
          interests: interests,
          role: role,
          canCreateCommunity: canCreateCommunity,
          isEmailVerified: isEmailVerified,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [StudentProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentProfile copyWith({
    Object? id = _Undefined,
    String? displayName,
    String? email,
    Object? department = _Undefined,
    Object? year = _Undefined,
    Object? bio = _Undefined,
    List<String>? studySubjects,
    List<String>? interests,
    Object? role = _Undefined,
    Object? canCreateCommunity = _Undefined,
    Object? isEmailVerified = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentProfile(
      id: id is int? ? id : this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      department: department is String? ? department : this.department,
      year: year is int? ? year : this.year,
      bio: bio is String? ? bio : this.bio,
      studySubjects:
          studySubjects ?? this.studySubjects.map((e0) => e0).toList(),
      interests: interests ?? this.interests.map((e0) => e0).toList(),
      role: role is String? ? role : this.role,
      canCreateCommunity: canCreateCommunity is bool?
          ? canCreateCommunity
          : this.canCreateCommunity,
      isEmailVerified:
          isEmailVerified is bool? ? isEmailVerified : this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
