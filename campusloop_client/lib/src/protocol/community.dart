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

abstract class Community
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Community._({
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

  factory Community({
    int? id,
    required String name,
    required String description,
    required String category,
    required List<String> interests,
    required int creatorProfileId,
    required int memberCount,
    String? imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CommunityImpl;

  factory Community.fromJson(Map<String, dynamic> jsonSerialization) {
    return Community(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      interests: _ibp2gf5m.Protocol()
          .deserialize<List<String>>(jsonSerialization['interests']),
      creatorProfileId: jsonSerialization['creatorProfileId'] as int,
      memberCount: jsonSerialization['memberCount'] as int,
      imageUrl: jsonSerialization['imageUrl'] as String?,
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

  String name;

  String description;

  String category;

  List<String> interests;

  int creatorProfileId;

  int memberCount;

  String? imageUrl;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Community]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Community',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'interests': interests.toJson(),
      'creatorProfileId': creatorProfileId,
      'memberCount': memberCount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Community',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'interests': interests.toJson(),
      'creatorProfileId': creatorProfileId,
      'memberCount': memberCount,
      if (imageUrl != null) 'imageUrl': imageUrl,
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

class _CommunityImpl extends Community {
  _CommunityImpl({
    int? id,
    required String name,
    required String description,
    required String category,
    required List<String> interests,
    required int creatorProfileId,
    required int memberCount,
    String? imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          name: name,
          description: description,
          category: category,
          interests: interests,
          creatorProfileId: creatorProfileId,
          memberCount: memberCount,
          imageUrl: imageUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [Community]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Community copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    String? category,
    List<String>? interests,
    int? creatorProfileId,
    int? memberCount,
    Object? imageUrl = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Community(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      interests: interests ?? this.interests.map((e0) => e0).toList(),
      creatorProfileId: creatorProfileId ?? this.creatorProfileId,
      memberCount: memberCount ?? this.memberCount,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
