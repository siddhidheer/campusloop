import 'package:serverpod_client/serverpod_client.dart';

class StudyPartnerRequest extends SerializableModel {
  StudyPartnerRequest({
    this.id,
    required this.fromProfileId,
    required this.toProfileId,
    required this.status,
    required this.matchingSubjects,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  int? id;
  int fromProfileId;
  int toProfileId;
  String status;
  List<String> matchingSubjects;
  String? message;
  DateTime createdAt;
  DateTime updatedAt;

  StudyPartnerRequest copyWith({
    int? id,
    int? fromProfileId,
    int? toProfileId,
    String? status,
    List<String>? matchingSubjects,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudyPartnerRequest(
      id: id ?? this.id,
      fromProfileId: fromProfileId ?? this.fromProfileId,
      toProfileId: toProfileId ?? this.toProfileId,
      status: status ?? this.status,
      matchingSubjects: matchingSubjects ?? List.from(this.matchingSubjects),
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory StudyPartnerRequest.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StudyPartnerRequest(
      id: jsonSerialization['id'] as int?,
      fromProfileId: jsonSerialization['fromProfileId'] as int,
      toProfileId: jsonSerialization['toProfileId'] as int,
      status: jsonSerialization['status'] as String,
      matchingSubjects: (jsonSerialization['matchingSubjects'] as List)
          .map((e) => e as String)
          .toList(),
      message: jsonSerialization['message'] as String?,
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fromProfileId': fromProfileId,
      'toProfileId': toProfileId,
      'status': status,
      'matchingSubjects': matchingSubjects,
      if (message != null) 'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
