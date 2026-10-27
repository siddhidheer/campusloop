import 'package:serverpod_client/serverpod_client.dart';

class StudentProfile extends SerializableModel {
  StudentProfile({
    this.id,
    required this.displayName,
    required this.email,
    this.department,
    this.year,
    this.bio,
    required this.studySubjects,
    required this.interests,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  int? id;
  String displayName;
  String email;
  String? department;
  int? year;
  String? bio;
  List<String> studySubjects;
  List<String> interests;
  DateTime createdAt;
  DateTime updatedAt;

  StudentProfile copyWith({
    int? id,
    String? displayName,
    String? email,
    String? department,
    int? year,
    String? bio,
    List<String>? studySubjects,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      department: department ?? this.department,
      year: year ?? this.year,
      bio: bio ?? this.bio,
      studySubjects: studySubjects ?? List.from(this.studySubjects),
      interests: interests ?? List.from(this.interests),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory StudentProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentProfile(
      id: jsonSerialization['id'] as int?,
      displayName: jsonSerialization['displayName'] as String,
      email: jsonSerialization['email'] as String,
      department: jsonSerialization['department'] as String?,
      year: jsonSerialization['year'] as int?,
      bio: jsonSerialization['bio'] as String?,
      studySubjects: (jsonSerialization['studySubjects'] as List)
          .map((e) => e as String)
          .toList(),
      interests: (jsonSerialization['interests'] as List)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(jsonSerialization['createdAt'] as String),
      updatedAt: DateTime.parse(jsonSerialization['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'displayName': displayName,
      'email': email,
      if (department != null) 'department': department,
      if (year != null) 'year': year,
      if (bio != null) 'bio': bio,
      'studySubjects': studySubjects,
      'interests': interests,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
