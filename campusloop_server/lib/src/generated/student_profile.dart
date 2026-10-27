import 'package:serverpod/serverpod.dart';

class StudentProfile extends TableRow {
  StudentProfile({
    super.id,
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

  String displayName;
  String email;
  String? department;
  int? year;
  String? bio;
  List<String> studySubjects;
  List<String> interests;
  DateTime createdAt;
  DateTime updatedAt;

  static final t = StudentProfileTable();
  static const db = StudentProfileRepository._();

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

  @override
  Map<String, dynamic> toJsonForProtocol() => toJson();
}

class StudentProfileTable extends Table {
  StudentProfileTable({super.tableRelation})
      : super(tableName: 'student_profile') {
    displayName = ColumnString('displayName', this);
    email = ColumnString('email', this);
    department = ColumnString('department', this);
    year = ColumnInt('year', this);
    bio = ColumnString('bio', this);
    studySubjects = ColumnSerializable('studySubjects', this);
    interests = ColumnSerializable('interests', this);
    createdAt = ColumnDateTime('createdAt', this);
    updatedAt = ColumnDateTime('updatedAt', this);
  }

  late final ColumnString displayName;
  late final ColumnString email;
  late final ColumnString department;
  late final ColumnInt year;
  late final ColumnString bio;
  late final ColumnSerializable studySubjects;
  late final ColumnSerializable interests;
  late final ColumnDateTime createdAt;
  late final ColumnDateTime updatedAt;

  @override
  List<Column> get columns => [
        id,
        displayName,
        email,
        department,
        year,
        bio,
        studySubjects,
        interests,
        createdAt,
        updatedAt,
      ];
}

class StudentProfileRepository {
  const StudentProfileRepository._();

  Future<StudentProfile?> findById(Session session, int id) async {
    return session.db.findById<StudentProfile>(id);
  }

  Future<List<StudentProfile>> find(
    Session session, {
    Expression Function(StudentProfileTable)? where,
    int? limit,
    int? offset,
    Column Function(StudentProfileTable)? orderBy,
    bool orderDescending = false,
  }) async {
    return session.db.find<StudentProfile>(
      where: where != null ? where(StudentProfile.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy != null ? orderBy(StudentProfile.t) : null,
      orderDescending: orderDescending,
    );
  }

  Future<StudentProfile> insertRow(
      Session session, StudentProfile row) async {
    return session.db.insertRow<StudentProfile>(row);
  }

  Future<StudentProfile> updateRow(
      Session session, StudentProfile row) async {
    return session.db.updateRow<StudentProfile>(row);
  }

  Future<List<StudentProfile>> deleteWhere(
    Session session, {
    required Expression Function(StudentProfileTable) where,
  }) async {
    return session.db.deleteWhere<StudentProfile>(
      where: where(StudentProfile.t),
    );
  }
}
