import 'package:serverpod_client/serverpod_client.dart';
import 'student_profile.dart';
import 'campus_event.dart';
import 'community.dart';
import 'community_membership.dart';
import 'community_post.dart';
import 'campus_update.dart';
import 'study_partner_request.dart';

export 'student_profile.dart';
export 'campus_event.dart';
export 'community.dart';
export 'community_membership.dart';
export 'community_post.dart';
export 'campus_update.dart';
export 'study_partner_request.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  Protocol._();

  static final Protocol instance = Protocol._();

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;
    if (t == StudentProfile) {
      return StudentProfile.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CampusEvent) {
      return CampusEvent.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == Community) {
      return Community.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CommunityMembership) {
      return CommunityMembership.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CommunityPost) {
      return CommunityPost.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == CampusUpdate) {
      return CampusUpdate.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == StudyPartnerRequest) {
      return StudyPartnerRequest.fromJson(data as Map<String, dynamic>) as T;
    }
    if (t == getType<StudentProfile?>()) {
      return (data != null ? StudentProfile.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<CampusEvent?>()) {
      return (data != null ? CampusEvent.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<Community?>()) {
      return (data != null ? Community.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<CampusUpdate?>()) {
      return (data != null ? CampusUpdate.fromJson(data as Map<String, dynamic>) : null) as T;
    }
    if (t == getType<List<StudentProfile>>()) {
      return (data as List).map((e) => deserialize<StudentProfile>(e)).toList() as T;
    }
    if (t == getType<List<CampusEvent>>()) {
      return (data as List).map((e) => deserialize<CampusEvent>(e)).toList() as T;
    }
    if (t == getType<List<Community>>()) {
      return (data as List).map((e) => deserialize<Community>(e)).toList() as T;
    }
    if (t == getType<List<CommunityMembership>>()) {
      return (data as List).map((e) => deserialize<CommunityMembership>(e)).toList() as T;
    }
    if (t == getType<List<CommunityPost>>()) {
      return (data as List).map((e) => deserialize<CommunityPost>(e)).toList() as T;
    }
    if (t == getType<List<CampusUpdate>>()) {
      return (data as List).map((e) => deserialize<CampusUpdate>(e)).toList() as T;
    }
    if (t == getType<List<StudyPartnerRequest>>()) {
      return (data as List).map((e) => deserialize<StudyPartnerRequest>(e)).toList() as T;
    }
    if (t == getType<List<String>>()) {
      return (data as List).map((e) => e as String).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    if (data is StudentProfile) return 'StudentProfile';
    if (data is CampusEvent) return 'CampusEvent';
    if (data is Community) return 'Community';
    if (data is CommunityMembership) return 'CommunityMembership';
    if (data is CommunityPost) return 'CommunityPost';
    if (data is CampusUpdate) return 'CampusUpdate';
    if (data is StudyPartnerRequest) return 'StudyPartnerRequest';
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var className = data['className'];
    var dataObj = data['data'];
    if (className == 'StudentProfile') return deserialize<StudentProfile>(dataObj);
    if (className == 'CampusEvent') return deserialize<CampusEvent>(dataObj);
    if (className == 'Community') return deserialize<Community>(dataObj);
    if (className == 'CommunityMembership') return deserialize<CommunityMembership>(dataObj);
    if (className == 'CommunityPost') return deserialize<CommunityPost>(dataObj);
    if (className == 'CampusUpdate') return deserialize<CampusUpdate>(dataObj);
    if (className == 'StudyPartnerRequest') return deserialize<StudyPartnerRequest>(dataObj);
    return super.deserializeByClassName(data);
  }
}
