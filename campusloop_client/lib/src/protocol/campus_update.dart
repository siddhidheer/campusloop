import 'package:serverpod_client/serverpod_client.dart';

class CampusUpdate extends SerializableModel {
  CampusUpdate({
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

  @override
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
  }) {
    return CampusUpdate(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      priority: priority ?? this.priority,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CampusUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusUpdate(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      category: jsonSerialization['category'] as String,
      authorProfileId: jsonSerialization['authorProfileId'] as int,
      priority: jsonSerialization['priority'] as String,
      isPublished: jsonSerialization['isPublished'] as bool,
      publishedAt: jsonSerialization['publishedAt'] != null
          ? DateTime.parse(jsonSerialization['publishedAt'] as String)
          : null,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorProfileId': authorProfileId,
      'priority': priority,
      'isPublished': isPublished,
      if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
