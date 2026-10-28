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

abstract class CampusEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CampusEvent._({
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

  factory CampusEvent({
    int? id,
    required String title,
    required String description,
    required String category,
    required String venue,
    required String organizer,
    required int organizerProfileId,
    required DateTime dateTime,
    DateTime? endDateTime,
    String? imageUrl,
    int? maxAttendees,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CampusEventImpl;

  factory CampusEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusEvent(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      venue: jsonSerialization['venue'] as String,
      organizer: jsonSerialization['organizer'] as String,
      organizerProfileId: jsonSerialization['organizerProfileId'] as int,
      dateTime:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dateTime']),
      endDateTime: jsonSerialization['endDateTime'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['endDateTime']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      maxAttendees: jsonSerialization['maxAttendees'] as int?,
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

  /// Returns a shallow copy of this [CampusEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampusEvent',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'organizer': organizer,
      'organizerProfileId': organizerProfileId,
      'dateTime': dateTime.toJson(),
      if (endDateTime != null) 'endDateTime': endDateTime?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (maxAttendees != null) 'maxAttendees': maxAttendees,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampusEvent',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'organizer': organizer,
      'organizerProfileId': organizerProfileId,
      'dateTime': dateTime.toJson(),
      if (endDateTime != null) 'endDateTime': endDateTime?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (maxAttendees != null) 'maxAttendees': maxAttendees,
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

class _CampusEventImpl extends CampusEvent {
  _CampusEventImpl({
    int? id,
    required String title,
    required String description,
    required String category,
    required String venue,
    required String organizer,
    required int organizerProfileId,
    required DateTime dateTime,
    DateTime? endDateTime,
    String? imageUrl,
    int? maxAttendees,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          title: title,
          description: description,
          category: category,
          venue: venue,
          organizer: organizer,
          organizerProfileId: organizerProfileId,
          dateTime: dateTime,
          endDateTime: endDateTime,
          imageUrl: imageUrl,
          maxAttendees: maxAttendees,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [CampusEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CampusEvent copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    String? category,
    String? venue,
    String? organizer,
    int? organizerProfileId,
    DateTime? dateTime,
    Object? endDateTime = _Undefined,
    Object? imageUrl = _Undefined,
    Object? maxAttendees = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampusEvent(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      venue: venue ?? this.venue,
      organizer: organizer ?? this.organizer,
      organizerProfileId: organizerProfileId ?? this.organizerProfileId,
      dateTime: dateTime ?? this.dateTime,
      endDateTime: endDateTime is DateTime? ? endDateTime : this.endDateTime,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      maxAttendees: maxAttendees is int? ? maxAttendees : this.maxAttendees,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
