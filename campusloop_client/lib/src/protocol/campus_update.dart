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

abstract class CampusUpdate
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CampusUpdate._({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorProfileId,
    required this.priority,
    required this.isPublished,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampusUpdate({
    int? id,
    required String title,
    required String content,
    required String category,
    required int authorProfileId,
    required String priority,
    required bool isPublished,
    DateTime? publishedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CampusUpdateImpl;

  factory CampusUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusUpdate(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      category: jsonSerialization['category'] as String,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      priority: jsonSerialization['priority'] as String,
      isPublished:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['isPublished']),
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedAt']),
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

  String title;

  String content;

  String category;

  int authorProfileId;

  String priority;

  bool isPublished;

  DateTime? publishedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CampusUpdate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CampusUpdate copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    int? authorProfileId,
    String? priority,
    bool? isPublished,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampusUpdate',
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorProfileId': authorProfileId,
      'priority': priority,
      'isPublished': isPublished,
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampusUpdate',
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorProfileId': authorProfileId,
      'priority': priority,
      'isPublished': isPublished,
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
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

class _CampusUpdateImpl extends CampusUpdate {
  _CampusUpdateImpl({
    int? id,
    required String title,
    required String content,
    required String category,
    required int authorProfileId,
    required String priority,
    required bool isPublished,
    DateTime? publishedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          title: title,
          content: content,
          category: category,
          authorProfileId: authorProfileId,
          priority: priority,
          isPublished: isPublished,
          publishedAt: publishedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [CampusUpdate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CampusUpdate copyWith({
    Object? id = _Undefined,
    String? title,
    String? content,
    String? category,
    int? authorProfileId,
    String? priority,
    bool? isPublished,
    Object? publishedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampusUpdate(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      priority: priority ?? this.priority,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt is DateTime? ? publishedAt : this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
