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

abstract class CommunityPost
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CommunityPost._({
    this.id,
    required this.communityId,
    required this.authorProfileId,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommunityPost({
    int? id,
    required int communityId,
    required int authorProfileId,
    required String title,
    required String content,
    required bool isPinned,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CommunityPostImpl;

  factory CommunityPost.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityPost(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      isPinned: _isc.BoolJsonExtension.fromJson(jsonSerialization['isPinned']),
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

  int communityId;

  int authorProfileId;

  String title;

  String content;

  bool isPinned;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CommunityPost]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CommunityPost copyWith({
    int? id,
    int? communityId,
    int? authorProfileId,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommunityPost',
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommunityPost',
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'title': title,
      'content': content,
      'isPinned': isPinned,
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

class _CommunityPostImpl extends CommunityPost {
  _CommunityPostImpl({
    int? id,
    required int communityId,
    required int authorProfileId,
    required String title,
    required String content,
    required bool isPinned,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          communityId: communityId,
          authorProfileId: authorProfileId,
          title: title,
          content: content,
          isPinned: isPinned,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [CommunityPost]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CommunityPost copyWith({
    Object? id = _Undefined,
    int? communityId,
    int? authorProfileId,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityPost(
      id: id is int? ? id : this.id,
      communityId: communityId ?? this.communityId,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
