/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:campusloop_client/src/protocol/campus_event.dart' as _isvc2zbb;
import 'package:campusloop_client/src/protocol/campus_update.dart' as _iiyyc0fa;
import 'package:campusloop_client/src/protocol/community.dart' as _ih1h51b7;
import 'package:campusloop_client/src/protocol/community_membership.dart'
    as _iy33aivh;
import 'package:campusloop_client/src/protocol/community_post.dart'
    as _i5khyfwd;
import 'package:campusloop_client/src/protocol/student_profile.dart'
    as _iu5j17l1;
import 'package:campusloop_client/src/protocol/study_partner_request.dart'
    as _ia93fw83;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'campus_event.dart' as _ieh998j0;
import 'campus_update.dart' as _ikfbu05k;
import 'community.dart' as _i2q09qvg;
import 'community_membership.dart' as _ir33x8kn;
import 'community_post.dart' as _itvhuiq9;
import 'student_profile.dart' as _iovtxv26;
import 'study_partner_request.dart' as _idamz02b;
export 'campus_event.dart';
export 'campus_update.dart';
export 'community.dart';
export 'community_membership.dart';
export 'community_post.dart';
export 'student_profile.dart';
export 'study_partner_request.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ieh998j0.CampusEvent) {
      return _ieh998j0.CampusEvent.fromJson(data) as T;
    }
    if (t == _ikfbu05k.CampusUpdate) {
      return _ikfbu05k.CampusUpdate.fromJson(data) as T;
    }
    if (t == _i2q09qvg.Community) {
      return _i2q09qvg.Community.fromJson(data) as T;
    }
    if (t == _ir33x8kn.CommunityMembership) {
      return _ir33x8kn.CommunityMembership.fromJson(data) as T;
    }
    if (t == _itvhuiq9.CommunityPost) {
      return _itvhuiq9.CommunityPost.fromJson(data) as T;
    }
    if (t == _iovtxv26.StudentProfile) {
      return _iovtxv26.StudentProfile.fromJson(data) as T;
    }
    if (t == _idamz02b.StudyPartnerRequest) {
      return _idamz02b.StudyPartnerRequest.fromJson(data) as T;
    }
    if (t == _isc.getType<_ieh998j0.CampusEvent?>()) {
      return (data != null ? _ieh998j0.CampusEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikfbu05k.CampusUpdate?>()) {
      return (data != null ? _ikfbu05k.CampusUpdate.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2q09qvg.Community?>()) {
      return (data != null ? _i2q09qvg.Community.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ir33x8kn.CommunityMembership?>()) {
      return (data != null
          ? _ir33x8kn.CommunityMembership.fromJson(data)
          : null) as T;
    }
    if (t == _isc.getType<_itvhuiq9.CommunityPost?>()) {
      return (data != null ? _itvhuiq9.CommunityPost.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iovtxv26.StudentProfile?>()) {
      return (data != null ? _iovtxv26.StudentProfile.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idamz02b.StudyPartnerRequest?>()) {
      return (data != null
          ? _idamz02b.StudyPartnerRequest.fromJson(data)
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iiyyc0fa.CampusUpdate>) {
      return (data as List)
          .map((e) => deserialize<_iiyyc0fa.CampusUpdate>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ih1h51b7.Community>) {
      return (data as List)
          .map((e) => deserialize<_ih1h51b7.Community>(e))
          .toList() as T;
    }
    if (t == List<_iy33aivh.CommunityMembership>) {
      return (data as List)
          .map((e) => deserialize<_iy33aivh.CommunityMembership>(e))
          .toList() as T;
    }
    if (t == List<_i5khyfwd.CommunityPost>) {
      return (data as List)
          .map((e) => deserialize<_i5khyfwd.CommunityPost>(e))
          .toList() as T;
    }
    if (t == List<_isvc2zbb.CampusEvent>) {
      return (data as List)
          .map((e) => deserialize<_isvc2zbb.CampusEvent>(e))
          .toList() as T;
    }
    if (t == List<_iu5j17l1.StudentProfile>) {
      return (data as List)
          .map((e) => deserialize<_iu5j17l1.StudentProfile>(e))
          .toList() as T;
    }
    if (t == List<_ia93fw83.StudyPartnerRequest>) {
      return (data as List)
          .map((e) => deserialize<_ia93fw83.StudyPartnerRequest>(e))
          .toList() as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ieh998j0.CampusEvent => 'CampusEvent',
      _ikfbu05k.CampusUpdate => 'CampusUpdate',
      _i2q09qvg.Community => 'Community',
      _ir33x8kn.CommunityMembership => 'CommunityMembership',
      _itvhuiq9.CommunityPost => 'CommunityPost',
      _iovtxv26.StudentProfile => 'StudentProfile',
      _idamz02b.StudyPartnerRequest => 'StudyPartnerRequest',
      _ => null
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('campusloop.', '');
    }

    switch (data) {
      case _ieh998j0.CampusEvent():
        return 'CampusEvent';
      case _ikfbu05k.CampusUpdate():
        return 'CampusUpdate';
      case _i2q09qvg.Community():
        return 'Community';
      case _ir33x8kn.CommunityMembership():
        return 'CommunityMembership';
      case _itvhuiq9.CommunityPost():
        return 'CommunityPost';
      case _iovtxv26.StudentProfile():
        return 'StudentProfile';
      case _idamz02b.StudyPartnerRequest():
        return 'StudyPartnerRequest';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CampusEvent') {
      return deserialize<_ieh998j0.CampusEvent>(data['data']);
    }
    if (dataClassName == 'CampusUpdate') {
      return deserialize<_ikfbu05k.CampusUpdate>(data['data']);
    }
    if (dataClassName == 'Community') {
      return deserialize<_i2q09qvg.Community>(data['data']);
    }
    if (dataClassName == 'CommunityMembership') {
      return deserialize<_ir33x8kn.CommunityMembership>(data['data']);
    }
    if (dataClassName == 'CommunityPost') {
      return deserialize<_itvhuiq9.CommunityPost>(data['data']);
    }
    if (dataClassName == 'StudentProfile') {
      return deserialize<_iovtxv26.StudentProfile>(data['data']);
    }
    if (dataClassName == 'StudyPartnerRequest') {
      return deserialize<_idamz02b.StudyPartnerRequest>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('campusloop', this);
    _iacc.Protocol().registerHostProtocol('campusloop', this);
  }

  @override
  String getModuleName() => 'campusloop';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
