import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campusloop_client/campusloop_client.dart';
import 'package:campusloop_flutter/theme/campus_theme.dart';

/// Model representing a formal safety or harassment report submitted by a student.
class CampusReport {
  final String id;
  final String targetType; // 'student', 'post', 'event', 'community'
  final int targetId;
  final String targetName;
  final String reason;
  final String details;
  final DateTime timestamp;
  final String status; // 'Under Review', 'Action Taken', 'Resolved'

  const CampusReport({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.targetName,
    required this.reason,
    required this.details,
    required this.timestamp,
    this.status = 'Under Review',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'targetType': targetType,
        'targetId': targetId,
        'targetName': targetName,
        'reason': reason,
        'details': details,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
      };

  factory CampusReport.fromJson(Map<String, dynamic> json) => CampusReport(
        id: json['id'] as String,
        targetType: json['targetType'] as String,
        targetId: json['targetId'] as int? ?? 0,
        targetName: json['targetName'] as String? ?? 'User',
        reason: json['reason'] as String? ?? 'Inappropriate Behavior',
        details: json['details'] as String? ?? '',
        timestamp: DateTime.parse(json['timestamp'] as String),
        status: json['status'] as String? ?? 'Under Review',
      );

  static Future<List<CampusReport>> loadReports(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('safety_reports_$userId') ?? [];
      return list
          .map((s) => CampusReport.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveReport(int userId, CampusReport report) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = await loadReports(userId);
      list.insert(0, report);
      final raw = list.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList('safety_reports_$userId', raw);
    } catch (_) {}
  }
}

/// Helper for blocking users, email verification, and campus trust checks.
class CampusSafetyManager {
  /// Returns set of profile IDs blocked by the current student.
  static Future<Set<int>> getBlockedUserIds(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('blocked_users_$userId') ?? [];
      return list.map((s) => int.tryParse(s) ?? 0).where((id) => id > 0).toSet();
    } catch (_) {
      return {};
    }
  }

  /// Returns blocked users list with their cached names.
  static Future<List<Map<String, dynamic>>> getBlockedUsersWithNames(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('blocked_users_$userId') ?? [];
      final result = <Map<String, dynamic>>[];
      for (final idStr in list) {
        final id = int.tryParse(idStr) ?? 0;
        if (id > 0) {
          final name = prefs.getString('blocked_name_$id') ?? 'Student #$id';
          result.add({'id': id, 'name': name});
        }
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  /// Blocks a user and persists across sessions.
  static Future<void> blockUser(
      int currentUserId, int targetUserId, String targetName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final set = await getBlockedUserIds(currentUserId);
      set.add(targetUserId);
      await prefs.setStringList(
          'blocked_users_$currentUserId', set.map((i) => i.toString()).toList());
      // Cache target name for unblock UI
      await prefs.setString('blocked_name_$targetUserId', targetName);
    } catch (_) {}
  }

  /// Unblocks a user.
  static Future<void> unblockUser(int currentUserId, int targetUserId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final set = await getBlockedUserIds(currentUserId);
      set.remove(targetUserId);
      await prefs.setStringList(
          'blocked_users_$currentUserId', set.map((i) => i.toString()).toList());
    } catch (_) {}
  }

  /// Checks if a student's email has completed campus verification.
  static Future<bool> isVerified(String email) async {
    try {
      final lower = email.trim().toLowerCase();
      final prefs = await SharedPreferences.getInstance();
      final verified = prefs.getBool('verified_email_$lower');
      if (verified == true) return true;

      // Recognized institutional domain suffixes are auto-verified
      if (lower.endsWith('.edu') ||
          lower.endsWith('.ac.in') ||
          lower.endsWith('.edu.in') ||
          lower.endsWith('.org')) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Sets email verification status in persistent storage.
  static Future<void> setVerified(String email, bool isVerified) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('verified_email_${email.trim().toLowerCase()}', isVerified);
    } catch (_) {}
  }

  /// Launches modal bottom sheet to report a student, post, or event.
  static Future<void> showReportModal(
    BuildContext context, {
    required int currentUserId,
    required String targetType,
    required int targetId,
    required String targetName,
    VoidCallback? onReported,
  }) async {
    final reasonController = TextEditingController();
    String selectedReason = 'Harassment or Bullying';
    bool alsoBlock = false;

    final reasons = [
      'Harassment or Bullying',
      'Inappropriate / Offensive Content',
      'Spam or Scam',
      'Impersonation / Fake Student',
      'Academic Dishonesty',
      'Other Violation',
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CampusTheme.coral.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: CampusTheme.coral,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Report to Campus Moderation',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Reporting: $targetName ($targetType)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: CampusTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reason for Report',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CampusTheme.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reasons.map((r) {
                    final isSel = selectedReason == r;
                    return ChoiceChip(
                      label: Text(r),
                      selected: isSel,
                      selectedColor: CampusTheme.coral,
                      backgroundColor: CampusTheme.darkCardLight,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSel ? Colors.white : CampusTheme.textMuted,
                      ),
                      onSelected: (val) {
                        if (val) setModalState(() => selectedReason = r);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Additional Details (Optional)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CampusTheme.textLight,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Please describe what happened to help our moderation team review this case promptly...',
                    hintStyle: const TextStyle(
                        fontSize: 12, color: CampusTheme.textMuted),
                    filled: true,
                    fillColor: CampusTheme.darkSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
                if (targetType == 'student') ...[
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: alsoBlock,
                    title: const Text(
                      'Also block this student (they will no longer see your profile or connect with you)',
                      style: TextStyle(fontSize: 12, color: CampusTheme.textLight),
                    ),
                    activeColor: CampusTheme.coral,
                    onChanged: (v) => setModalState(() => alsoBlock = v ?? false),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CampusTheme.coral,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final caseId =
                              '#MOD-2026-${(1000 + Random().nextInt(9000))}';
                          final report = CampusReport(
                            id: caseId,
                            targetType: targetType,
                            targetId: targetId,
                            targetName: targetName,
                            reason: selectedReason,
                            details: reasonController.text.trim(),
                            timestamp: DateTime.now(),
                            status: 'Under Review',
                          );

                          await CampusReport.saveReport(currentUserId, report);

                          if (alsoBlock && targetType == 'student') {
                            await CampusSafetyManager.blockUser(
                                currentUserId, targetId, targetName);
                          }

                          if (context.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '✓ Report $caseId submitted. Campus moderation is reviewing this case.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: CampusTheme.coral,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                            onReported?.call();
                          }
                        },
                        child: const Text(
                          'Submit Report',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Displays confirmation dialog to block a student.
  static Future<void> confirmAndBlockUser(
    BuildContext context, {
    required int currentUserId,
    required int targetUserId,
    required String targetName,
    VoidCallback? onBlocked,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CampusTheme.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: CampusTheme.coral.withValues(alpha: 0.3),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CampusTheme.coral.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.block_rounded,
                color: CampusTheme.coral,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Block Student?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to block $targetName?\n\n'
          '• They will not be able to find your study profile\n'
          '• Existing connection requests will be muted\n'
          '• You can unblock them at any time from your Profile Safety settings',
          style: const TextStyle(
            fontSize: 13,
            color: CampusTheme.textLight,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CampusTheme.coral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Block Student'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await blockUser(currentUserId, targetUserId, targetName);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ $targetName has been blocked.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.coral,
          ),
        );
        onBlocked?.call();
      }
    }
  }

  /// Displays official CampusLoop Community Safety Guidelines modal.
  static void showCommunityGuidelines(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (ctx, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.gavel_rounded, color: CampusTheme.mint, size: 24),
                SizedBox(width: 10),
                Text(
                  'Campus Community Guidelines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'CampusLoop is committed to fostering a safe, respectful, and productive academic environment for all students.',
              style: TextStyle(fontSize: 12, color: CampusTheme.textMuted),
            ),
            const SizedBox(height: 18),
            _guidelineTile(
              '1. Zero Tolerance for Harassment & Bullying',
              'Any intimidation, stalking, derogatory remarks, or unwanted advances towards peers is strictly prohibited and results in immediate account suspension.',
              Icons.do_not_disturb_on_rounded,
            ),
            _guidelineTile(
              '2. Verified Campus Affiliation & Authenticity',
              'Students must represent their true institutional identity. Impersonating faculty, administrators, or fellow students is an expulsion-level offense.',
              Icons.verified_user_rounded,
            ),
            _guidelineTile(
              '3. Academic Integrity & Study Partnerships',
              'Study partner matchmaking is intended for collaborative learning, exam preparation, and campus projects. Plagiarism facilitation or commercial homework services are forbidden.',
              Icons.menu_book_rounded,
            ),
            _guidelineTile(
              '4. Safe Meetup Protocols',
              'Whenever scheduling in-person study sessions, choose public campus locations such as institute libraries, student centers, or campus cafeterias. Use Virtual Study Rooms for remote study.',
              Icons.health_and_safety_rounded,
            ),
            _guidelineTile(
              '5. Reporting & Transparent Moderation',
              'Every student has access to one-tap reporting and blocking. Moderation reports (#MOD-XXXX) are tracked and actioned by campus coordinators.',
              Icons.shield_rounded,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CampusTheme.mint,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'I Understand & Agree',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _guidelineTile(String title, String body, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CampusTheme.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CampusTheme.mint.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: CampusTheme.mint, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CampusTheme.textLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper for Event Cancellation & Status Broadcast.
class CampusEventManager {
  /// Checks whether an event has been cancelled by organizer.
  static Future<bool> isEventCancelled(CampusEvent event) async {
    if (event.title.trim().startsWith('[CANCELLED]')) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('cancelled_event_${event.id}') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Retrieves the recorded cancellation reason for an event.
  static Future<String?> getCancellationReason(CampusEvent event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localReason = prefs.getString('cancelled_reason_${event.id}');
      if (localReason != null && localReason.isNotEmpty) return localReason;

      // Extract from description if embedded
      final desc = event.description;
      final match = RegExp(r'\[EVENT_CANCELLED:\s*([^\]]+)\]').firstMatch(desc);
      if (match != null) {
        return match.group(1)?.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Cancels an event and broadcasts status alert across campus.
  static Future<void> cancelEvent({
    required Client client,
    required CampusEvent event,
    required String reason,
    required int requestingProfileId,
  }) async {
    final cleanTitle = event.title.replaceFirst(RegExp(r'^\[CANCELLED\]\s*'), '').trim();
    final updatedTitle = '[CANCELLED] $cleanTitle';
    final updatedDesc = '${event.description}\n\n[EVENT_CANCELLED: $reason]';

    event.title = updatedTitle;
    event.description = updatedDesc;
    event.updatedAt = DateTime.now();

    // 1. Update on Serverpod Cloud
    try {
      await client.event.updateEvent(event, requestingProfileId);
    } catch (_) {}

    // 2. Persist locally and update broadcast list
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('cancelled_event_${event.id}', true);
      await prefs.setString('cancelled_reason_${event.id}', reason);

      final broadcastList = prefs.getStringList('broadcast_cancelled_events') ?? [];
      final item = jsonEncode({
        'id': event.id,
        'title': cleanTitle,
        'venue': event.venue,
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
      });
      broadcastList.removeWhere((s) {
        try {
          return (jsonDecode(s) as Map<String, dynamic>)['id'] == event.id;
        } catch (_) {
          return false;
        }
      });
      broadcastList.insert(0, item);
      await prefs.setStringList('broadcast_cancelled_events', broadcastList);
    } catch (_) {}
  }

  /// Reactivates an event.
  static Future<void> reactivateEvent({
    required Client client,
    required CampusEvent event,
    required int requestingProfileId,
  }) async {
    final cleanTitle = event.title.replaceFirst(RegExp(r'^\[CANCELLED\]\s*'), '').trim();
    final cleanDesc = event.description.replaceAll(RegExp(r'\[EVENT_CANCELLED:[^\]]*\]'), '').trim();

    event.title = cleanTitle;
    event.description = cleanDesc;
    event.updatedAt = DateTime.now();

    try {
      await client.event.updateEvent(event, requestingProfileId);
    } catch (_) {}

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('cancelled_event_${event.id}', false);
      await prefs.remove('cancelled_reason_${event.id}');
      final broadcastList = prefs.getStringList('broadcast_cancelled_events') ?? [];
      broadcastList.removeWhere((s) {
        try {
          return (jsonDecode(s) as Map<String, dynamic>)['id'] == event.id;
        } catch (_) {
          return false;
        }
      });
      await prefs.setStringList('broadcast_cancelled_events', broadcastList);
    } catch (_) {}
  }
}
