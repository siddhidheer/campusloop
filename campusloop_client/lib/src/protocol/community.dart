import 'package:serverpod_client/serverpod_client.dart';

class Community extends SerializableModel {
  Community({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.interests,
    required this.creatorProfileId,
    required this.memberCount,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  int? id;
  String name;
  String description;
  String category;
  List<String> interests;
  int creatorProfileId;
  int memberCount;
  String? imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Community copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    List<String>? interests,
    int? creatorProfileId,
    int? memberCount,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      interests: interests ?? List.from(this.interests),
      creatorProfileId: creatorProfileId ?? this.creatorProfileId,
      memberCount: memberCount ?? this.memberCount,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Community.fromJson(Map<String, dynamic> jsonSerialization) {
    return Community(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      interests: (jsonSerialization['interests'] as List)
          .map((e) => e as String)
          .toList(),
      creatorProfileId: jsonSerialization['creatorProfileId'] as int,
      memberCount: jsonSerialization['memberCount'] as int,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'interests': interests,
      'creatorProfileId': creatorProfileId,
      'memberCount': memberCount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
