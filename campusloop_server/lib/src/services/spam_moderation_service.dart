import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Serverpod backend service for automated spam, commercial promotion,
/// and irrelevant content moderation in community discussions.
class SpamModerationService {
  /// Default starter list of configurable spam patterns
  static final List<Map<String, String>> defaultRules = [
    // Commercial Promotions & Services
    {
      'pattern': 'buy now',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'special discount',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'limited time deal',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'order online at',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': '50% off',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'use promo code',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'discount coupon',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'essay writing service',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'pay someone to write',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'assignment helper for cheap',
      'category': 'commercial_promotion',
      'severity': 'block'
    },
    {
      'pattern': 'cheap essay',
      'category': 'commercial_promotion',
      'severity': 'block'
    },

    // Referral, Affiliate & Quick-Money Schemes
    {
      'pattern': 'referral code',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'refer and earn',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'bonus cash',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'free crypto',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'free airdrop',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'earn money from home',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'daily income guarantee',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'guaranteed profit',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'free gift card',
      'category': 'referral_affiliate',
      'severity': 'block'
    },
    {
      'pattern': 'earn cash fast',
      'category': 'referral_affiliate',
      'severity': 'block'
    },

    // Suspicious External Links & Redirects
    {
      'pattern': 'bit.ly/',
      'category': 'unsolicited_links',
      'severity': 'block'
    },
    {
      'pattern': 'tinyurl.com/',
      'category': 'unsolicited_links',
      'severity': 'block'
    },
    {
      'pattern': 't.me/',
      'category': 'unsolicited_links',
      'severity': 'block'
    },
    {
      'pattern': 'wa.me/',
      'category': 'unsolicited_links',
      'severity': 'block'
    },
    {
      'pattern': 'shorturl.at/',
      'category': 'unsolicited_links',
      'severity': 'block'
    },
    {
      'pattern': 'cutt.ly/',
      'category': 'unsolicited_links',
      'severity': 'block'
    },
  ];

  /// Legitimate academic & campus keywords that should not be blocked
  /// even if common words like 'project' or 'study' are present.
  static final List<String> academicContextKeywords = [
    'exam',
    'syllabus',
    'course',
    'professor',
    'lecture',
    'assignment',
    'homework',
    'laboratory',
    'textbook',
    'semester',
    'library',
    'research paper',
    'study group',
    'campus',
    'hostel',
    'hackathon',
    'workshop',
    'internship',
  ];

  /// Normalizes message text to prevent evasion through leetspeak, spacing, and casing.
  static String normalizeContent(String input) {
    if (input.isEmpty) return '';

    String text = input.toLowerCase();

    // Leetspeak substitution map
    const leetMap = {
      '@': 'a',
      '4': 'a',
      '8': 'b',
      '3': 'e',
      '1': 'i',
      '!': 'i',
      '0': 'o',
      '5': 's',
      '\$': 's',
      '7': 't',
    };

    leetMap.forEach((k, v) {
      text = text.replaceAll(k, v);
    });

    // Remove zero-width characters and unusual unicode separators
    text = text.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');

    // Collapse multiple consecutive spaces and punctuation
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  /// Compact alphanumeric representation to catch "b u y   n o w" evasion
  static String compactAlphaNumeric(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  /// Ensures default spam rules exist in the database.
  static Future<void> ensureDefaultRules(Session session) async {
    final existing = await SpamKeywordRule.db.find(session, limit: 1);
    if (existing.isNotEmpty) return;

    final now = DateTime.now();
    for (final rule in defaultRules) {
      await SpamKeywordRule.db.insertRow(
        session,
        SpamKeywordRule(
          pattern: rule['pattern']!,
          category: rule['category']!,
          severity: rule['severity']!,
          isEnabled: true,
          createdAt: now,
        ),
      );
    }
  }

  /// Checks submitted message content against configurable spam rules,
  /// suspicious links, commercial patterns, and repeated spam.
  static Future<SpamCheckResult> checkContent(
    Session session, {
    required int authorProfileId,
    required String authorEmail,
    required int communityId,
    required String title,
    required String content,
  }) async {
    await ensureDefaultRules(session);

    final combined = '$title $content';
    final normalized = normalizeContent(combined);
    final compacted = compactAlphaNumeric(combined);

    // 1. Repeated spam check: Detect identical content posted within the last 10 minutes
    final tenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 10));
    final recentPosts = await CommunityPost.db.find(
      session,
      where: (t) =>
          t.authorProfileId.equals(authorProfileId) &
          (t.createdAt > tenMinutesAgo),
      orderBy: (t) => t.createdAt.desc(),
      limit: 5,
    );

    for (final post in recentPosts) {
      if (post.title.trim().toLowerCase() == title.trim().toLowerCase() &&
          post.content.trim().toLowerCase() == content.trim().toLowerCase()) {
        const reason = 'Repeated duplicate message detected within short time interval.';
        await _logModeration(
          session,
          communityId: communityId,
          authorProfileId: authorProfileId,
          authorEmail: authorEmail,
          postTitle: title,
          snippet: content.length > 100 ? content.substring(0, 100) : content,
          matchedRule: 'DUPLICATE_MESSAGE_INTERVAL',
          reason: reason,
        );

        return SpamCheckResult(
          isSpam: true,
          reason: reason,
          friendlyFeedback:
              'Your message could not be published because it appears to contain spam or promotional content. Please keep discussions relevant to the college community.',
          matchedRule: 'DUPLICATE_MESSAGE_INTERVAL',
        );
      }
    }

    // 2. Fetch active rules from database
    final rules = await SpamKeywordRule.db.find(
      session,
      where: (t) => t.isEnabled.equals(true),
    );

    for (final rule in rules) {
      final pattern = rule.pattern.trim().toLowerCase();
      if (pattern.isEmpty) continue;

      bool matched = false;

      // Check standard normalized text
      if (normalized.contains(pattern)) {
        matched = true;
      }

      // Check compacted text for spaced-out evasion (e.g. "b u y n o w")
      final compactedPattern = compactAlphaNumeric(pattern);
      if (compactedPattern.length >= 4 &&
          compacted.contains(compactedPattern)) {
        matched = true;
      }

      if (matched) {
        // Context check: If message contains genuine academic inquiry keywords,
        // ensure we don't block legitimate academic discussions unless it clearly contains
        // commercial triggers or suspicious link redirects.
        final hasAcademicContext = academicContextKeywords
            .any((ak) => normalized.contains(ak.toLowerCase()));

        final isStrictLinkRule = rule.category == 'unsolicited_links';
        final isEssayScam = rule.pattern.contains('essay') ||
            rule.pattern.contains('assignment helper') ||
            rule.pattern.contains('pay someone');

        // Only excuse if it's not a link or known essay mill scam, and academic context is strong
        if (hasAcademicContext && !isStrictLinkRule && !isEssayScam) {
          // If message is clearly an academic question, skip this benign trigger
          if (normalized.contains('?') ||
              normalized.contains('how to') ||
              normalized.contains('question') ||
              normalized.contains('anyone know')) {
            continue;
          }
        }

        final reason = 'Detected ${rule.category} match on pattern: "${rule.pattern}"';
        await _logModeration(
          session,
          communityId: communityId,
          authorProfileId: authorProfileId,
          authorEmail: authorEmail,
          postTitle: title,
          snippet: content.length > 100 ? content.substring(0, 100) : content,
          matchedRule: rule.pattern,
          reason: reason,
        );

        return SpamCheckResult(
          isSpam: true,
          reason: reason,
          friendlyFeedback:
              'Your message could not be published because it appears to contain spam or promotional content. Please keep discussions relevant to the college community.',
          matchedRule: rule.pattern,
        );
      }
    }

    return SpamCheckResult(
      isSpam: false,
      reason: null,
      friendlyFeedback: null,
      matchedRule: null,
    );
  }

  static Future<void> _logModeration(
    Session session, {
    required int communityId,
    required int authorProfileId,
    required String authorEmail,
    required String postTitle,
    required String snippet,
    required String matchedRule,
    required String reason,
  }) async {
    try {
      await ModerationLog.db.insertRow(
        session,
        ModerationLog(
          communityId: communityId,
          authorProfileId: authorProfileId,
          authorEmail: authorEmail,
          postTitle: postTitle,
          contentSnippet: snippet,
          matchedRule: matchedRule,
          reason: reason,
          isBlocked: true,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      session.log('Failed to save ModerationLog: $e', level: LogLevel.warning);
    }
  }
}
