import 'package:serverpod_client/serverpod_client.dart';

class CommunityPost extends SerializableModel {
  CommunityPost({
    this.id,
    required this.communityId,
    required this.authorProfileId,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  int? id;
  int communityId;
  int authorProfileId;
  String title;
  String content;
  bool isPinned;
  DateTime createdAt;
  DateTime updatedAt;

  CommunityPost copyWith({
    int? id,
    int? communityId,
    int? authorProfileId,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CommunityPost.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityPost(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      isPinned: jsonSerialization['isPinned'] as bool,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
