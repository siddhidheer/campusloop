import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model representing student social handles and direct communication channels.
/// Kept private and only revealed to connected study partners.
class StudentSocials {
  final String? discord;
  final String? linkedin;
  final String? whatsapp;

  const StudentSocials({
    this.discord,
    this.linkedin,
    this.whatsapp,
  });

  static const String tagPrefix = '[CAMPUS_SOCIAL:';
  static const String tagSuffix = ']';

  bool get hasAny =>
      (discord != null && discord!.trim().isNotEmpty) ||
      (linkedin != null && linkedin!.trim().isNotEmpty) ||
      (whatsapp != null && whatsapp!.trim().isNotEmpty);

  /// Strips the social metadata tag from bio for clean user display.
  static String cleanBio(String? rawBio) {
    if (rawBio == null || rawBio.isEmpty) return '';
    final startIndex = rawBio.indexOf(tagPrefix);
    if (startIndex == -1) return rawBio.trim();
    final endIndex = rawBio.indexOf(tagSuffix, startIndex);
    if (endIndex == -1) return rawBio.substring(0, startIndex).trim();
    final before = rawBio.substring(0, startIndex);
    final after = rawBio.substring(endIndex + tagSuffix.length);
    return ('$before $after').trim();
  }

  /// Extracts social handles from bio string metadata tag.
  static StudentSocials fromBio(String? rawBio) {
    if (rawBio == null || rawBio.isEmpty) {
      return const StudentSocials();
    }
    final startIndex = rawBio.indexOf(tagPrefix);
    if (startIndex == -1) return const StudentSocials();
    final endIndex = rawBio.indexOf(tagSuffix, startIndex);
    if (endIndex == -1) return const StudentSocials();

    final payload =
        rawBio.substring(startIndex + tagPrefix.length, endIndex);
    final parts = payload.split('&');
    String? discord;
    String? linkedin;
    String? whatsapp;

    for (final part in parts) {
      final kv = part.split('=');
      if (kv.length == 2) {
        final key = kv[0].trim().toLowerCase();
        final val = Uri.decodeComponent(kv[1].trim());
        if (val.isNotEmpty) {
          if (key == 'discord') discord = val;
          if (key == 'linkedin') linkedin = val;
          if (key == 'whatsapp') whatsapp = val;
        }
      }
    }

    return StudentSocials(
      discord: discord,
      linkedin: linkedin,
      whatsapp: whatsapp,
    );
  }

  /// Embeds social handles cleanly at the end of the bio string.
  static String embedInBio(String cleanBio, StudentSocials socials) {
    final trimmedBio = cleanBio.trim();
    if (!socials.hasAny) return trimmedBio;

    final parts = <String>[];
    if (socials.discord != null && socials.discord!.trim().isNotEmpty) {
      parts.add('discord=${Uri.encodeComponent(socials.discord!.trim())}');
    }
    if (socials.linkedin != null && socials.linkedin!.trim().isNotEmpty) {
      parts.add('linkedin=${Uri.encodeComponent(socials.linkedin!.trim())}');
    }
    if (socials.whatsapp != null && socials.whatsapp!.trim().isNotEmpty) {
      parts.add('whatsapp=${Uri.encodeComponent(socials.whatsapp!.trim())}');
    }

    if (parts.isEmpty) return trimmedBio;
    final tag = '$tagPrefix${parts.join('&')}$tagSuffix';
    return trimmedBio.isEmpty ? tag : '$trimmedBio\n\n$tag';
  }

  /// Locally caches the current user's socials for instant retrieval.
  static Future<void> saveLocalSocials(
      String emailOrId, StudentSocials socials) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'socials_$emailOrId',
          jsonEncode({
            'discord': socials.discord,
            'linkedin': socials.linkedin,
            'whatsapp': socials.whatsapp,
          }));
    } catch (_) {}
  }

  /// Retrieves locally cached socials.
  static Future<StudentSocials> loadLocalSocials(String emailOrId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('socials_$emailOrId');
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return StudentSocials(
          discord: map['discord'] as String?,
          linkedin: map['linkedin'] as String?,
          whatsapp: map['whatsapp'] as String?,
        );
      }
    } catch (_) {}
    return const StudentSocials();
  }
}

/// Model representing a scheduled collaborative study session.
class ScheduledStudySession {
  final String id;
  final String title;
  final String subject;
  final int partnerId;
  final String partnerName;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String meetingLink;
  final bool isOnline;

  ScheduledStudySession({
    required this.id,
    required this.title,
    required this.subject,
    required this.partnerId,
    required this.partnerName,
    required this.scheduledAt,
    this.durationMinutes = 60,
    this.meetingLink = '',
    this.isOnline = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'partnerId': partnerId,
        'partnerName': partnerName,
        'scheduledAt': scheduledAt.toIso8601String(),
        'durationMinutes': durationMinutes,
        'meetingLink': meetingLink,
        'isOnline': isOnline,
      };

  factory ScheduledStudySession.fromJson(Map<String, dynamic> json) =>
      ScheduledStudySession(
        id: json['id'] as String,
        title: json['title'] as String,
        subject: json['subject'] as String? ?? 'General Study',
        partnerId: json['partnerId'] as int? ?? 0,
        partnerName: json['partnerName'] as String? ?? 'Study Partner',
        scheduledAt: DateTime.parse(json['scheduledAt'] as String),
        durationMinutes: json['durationMinutes'] as int? ?? 60,
        meetingLink: json['meetingLink'] as String? ?? '',
        isOnline: json['isOnline'] as bool? ?? true,
      );

  static Future<List<ScheduledStudySession>> loadSessions(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList('study_sessions_$userId') ?? [];
      final sessions = rawList
          .map((s) => ScheduledStudySession.fromJson(
              jsonDecode(s) as Map<String, dynamic>))
          .toList();
      sessions.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      return sessions;
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveSession(
      int userId, ScheduledStudySession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessions = await loadSessions(userId);
      sessions.removeWhere((s) => s.id == session.id);
      sessions.add(session);
      final rawList = sessions.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList('study_sessions_$userId', rawList);
    } catch (_) {}
  }

  static Future<void> deleteSession(int userId, String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessions = await loadSessions(userId);
      sessions.removeWhere((s) => s.id == sessionId);
      final rawList = sessions.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList('study_sessions_$userId', rawList);
    } catch (_) {}
  }
}
