import 'package:serverpod_client/serverpod_client.dart';

class CommunityMembership extends SerializableModel {
  CommunityMembership({
    this.id,
    required this.communityId,
    required this.profileId,
    required this.role,
    required this.joinedAt,
  });

  @override
  int? id;
  int communityId;
  int profileId;
  String role;
  DateTime joinedAt;

  CommunityMembership copyWith({
    int? id,
    int? communityId,
    int? profileId,
    String? role,
    DateTime? joinedAt,
  }) {
    return CommunityMembership(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      profileId: profileId ?? this.profileId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory CommunityMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityMembership(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      role: jsonSerialization['role'] as String,
      joinedAt: DateTime.parse(jsonSerialization['joinedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'communityId': communityId,
      'profileId': profileId,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
