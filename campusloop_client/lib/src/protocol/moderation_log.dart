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

abstract class ModerationLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ModerationLog._({
    this.id,
    required this.communityId,
    required this.authorProfileId,
    required this.authorEmail,
    required this.postTitle,
    required this.contentSnippet,
    required this.matchedRule,
    required this.reason,
    required this.isBlocked,
    required this.timestamp,
  });

  factory ModerationLog({
    int? id,
    required int communityId,
    required int authorProfileId,
    required String authorEmail,
    required String postTitle,
    required String contentSnippet,
    required String matchedRule,
    required String reason,
    required bool isBlocked,
    required DateTime timestamp,
  }) = _ModerationLogImpl;

  factory ModerationLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModerationLog(
      id: jsonSerialization['id'] as int?,
      communityId: jsonSerialization['communityId'] as int,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      authorEmail: jsonSerialization['authorEmail'] as String,
      postTitle: jsonSerialization['postTitle'] as String,
      contentSnippet: jsonSerialization['contentSnippet'] as String,
      matchedRule: jsonSerialization['matchedRule'] as String,
      reason: jsonSerialization['reason'] as String,
      isBlocked:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['isBlocked']),
      timestamp:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int communityId;

  int authorProfileId;

  String authorEmail;

  String postTitle;

  String contentSnippet;

  String matchedRule;

  String reason;

  bool isBlocked;

  DateTime timestamp;

  /// Returns a shallow copy of this [ModerationLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ModerationLog copyWith({
    int? id,
    int? communityId,
    int? authorProfileId,
    String? authorEmail,
    String? postTitle,
    String? contentSnippet,
    String? matchedRule,
    String? reason,
    bool? isBlocked,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModerationLog',
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'authorEmail': authorEmail,
      'postTitle': postTitle,
      'contentSnippet': contentSnippet,
      'matchedRule': matchedRule,
      'reason': reason,
      'isBlocked': isBlocked,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModerationLog',
      if (id != null) 'id': id,
      'communityId': communityId,
      'authorProfileId': authorProfileId,
      'authorEmail': authorEmail,
      'postTitle': postTitle,
      'contentSnippet': contentSnippet,
      'matchedRule': matchedRule,
      'reason': reason,
      'isBlocked': isBlocked,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModerationLogImpl extends ModerationLog {
  _ModerationLogImpl({
    int? id,
    required int communityId,
    required int authorProfileId,
    required String authorEmail,
    required String postTitle,
    required String contentSnippet,
    required String matchedRule,
    required String reason,
    required bool isBlocked,
    required DateTime timestamp,
  }) : super._(
          id: id,
          communityId: communityId,
          authorProfileId: authorProfileId,
          authorEmail: authorEmail,
          postTitle: postTitle,
          contentSnippet: contentSnippet,
          matchedRule: matchedRule,
          reason: reason,
          isBlocked: isBlocked,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [ModerationLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ModerationLog copyWith({
    Object? id = _Undefined,
    int? communityId,
    int? authorProfileId,
    String? authorEmail,
    String? postTitle,
    String? contentSnippet,
    String? matchedRule,
    String? reason,
    bool? isBlocked,
    DateTime? timestamp,
  }) {
    return ModerationLog(
      id: id is int? ? id : this.id,
      communityId: communityId ?? this.communityId,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      authorEmail: authorEmail ?? this.authorEmail,
      postTitle: postTitle ?? this.postTitle,
      contentSnippet: contentSnippet ?? this.contentSnippet,
      matchedRule: matchedRule ?? this.matchedRule,
      reason: reason ?? this.reason,
      isBlocked: isBlocked ?? this.isBlocked,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
