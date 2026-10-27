import 'package:serverpod_client/serverpod_client.dart';

class CampusEvent extends SerializableModel {
  CampusEvent({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.venue,
    required this.organizer,
    required this.organizerProfileId,
    required this.dateTime,
    this.endDateTime,
    this.imageUrl,
    this.maxAttendees,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  int? id;
  String title;
  String description;
  String category;
  String venue;
  String organizer;
  int organizerProfileId;
  DateTime dateTime;
  DateTime? endDateTime;
  String? imageUrl;
  int? maxAttendees;
  DateTime createdAt;
  DateTime updatedAt;

  CampusEvent copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? venue,
    String? organizer,
    int? organizerProfileId,
    DateTime? dateTime,
    DateTime? endDateTime,
    String? imageUrl,
    int? maxAttendees,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampusEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      venue: venue ?? this.venue,
      organizer: organizer ?? this.organizer,
      organizerProfileId: organizerProfileId ?? this.organizerProfileId,
      dateTime: dateTime ?? this.dateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      imageUrl: imageUrl ?? this.imageUrl,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CampusEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusEvent(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      venue: jsonSerialization['venue'] as String,
      organizer: jsonSerialization['organizer'] as String,
      organizerProfileId: jsonSerialization['organizerProfileId'] as int,
      dateTime: DateTime.parse(jsonSerialization['dateTime'] as String),
      endDateTime: jsonSerialization['endDateTime'] != null
          ? DateTime.parse(jsonSerialization['endDateTime'] as String)
          : null,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      maxAttendees: jsonSerialization['maxAttendees'] as int?,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'organizer': organizer,
      'organizerProfileId': organizerProfileId,
      'dateTime': dateTime.toIso8601String(),
      if (endDateTime != null) 'endDateTime': endDateTime!.toIso8601String(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (maxAttendees != null) 'maxAttendees': maxAttendees,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
