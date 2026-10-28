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

abstract class CommunityMembership
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CommunityMembership._({
    this.id,
    required this.communityId,
    required this.profileId,
    required this.role,
    required this.joinedAt,
  });

  factory CommunityMembership({
    int? id,
    required int communityId,
    required int profileId,
    required String role,
    required DateTime joinedAt,
  }) = _CommunityMembershipImpl;

  factory CommunityMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityMembership(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      role: jsonSerialization['role'] as String,
      joinedAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int communityId;

  int profileId;

  String role;

  DateTime joinedAt;

  /// Returns a shallow copy of this [CommunityMembership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CommunityMembership copyWith({
    int? id,
    int? communityId,
    int? profileId,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommunityMembership',
      if (id != null) 'id': id,
      'communityId': communityId,
      'profileId': profileId,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommunityMembership',
      if (id != null) 'id': id,
      'communityId': communityId,
      'profileId': profileId,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommunityMembershipImpl extends CommunityMembership {
  _CommunityMembershipImpl({
    int? id,
    required int communityId,
    required int profileId,
    required String role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          communityId: communityId,
          profileId: profileId,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [CommunityMembership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CommunityMembership copyWith({
    Object? id = _Undefined,
    int? communityId,
    int? profileId,
    String? role,
    DateTime? joinedAt,
  }) {
    return CommunityMembership(
      id: id is int? ? id : this.id,
      communityId: communityId ?? this.communityId,
      profileId: profileId ?? this.profileId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
