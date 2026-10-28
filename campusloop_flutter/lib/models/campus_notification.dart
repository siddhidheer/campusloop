import 'package:campusloop_client/campusloop_client.dart';

enum NotificationCategory {
  connectionRequest,
  campusUpdate,
  clubActivity,
  event,
}

/// Unified notification model for the CampusLoop notifications center.
class CampusNotification {
  final String id;
  final NotificationCategory category;
  final String title;
  final String message;
  final DateTime timestamp;
  final int? targetId;
  final StudyPartnerRequest? requestPayload;
  final StudentProfile? senderProfile;
  final CampusUpdate? updatePayload;
  final CampusEvent? eventPayload;
  final Community? communityPayload;
  bool isRead;
  String requestStatus; // 'pending', 'accepted', 'rejected'

  CampusNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.timestamp,
    this.targetId,
    this.requestPayload,
    this.senderProfile,
    this.updatePayload,
    this.eventPayload,
    this.communityPayload,
    this.isRead = false,
    this.requestStatus = 'pending',
  });
}
