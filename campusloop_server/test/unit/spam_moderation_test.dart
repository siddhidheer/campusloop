import 'package:test/test.dart';
import '../../lib/src/services/spam_moderation_service.dart';

void main() {
  group('SpamModerationService Text Normalization Tests', () {
    test('Normalizes casing and trims extra whitespace', () {
      final normalized =
          SpamModerationService.normalizeContent('   SPECIAL   DISCOUNT   ');
      expect(normalized, equals('special discount'));
    });

    test('Normalizes leetspeak substitutions', () {
      // @ -> a, 0 -> o, 1 -> i, 3 -> e, $ -> s, ! -> i
      final normalized =
          SpamModerationService.normalizeContent('bUy n0w w!th pr0m0 c0d3');
      expect(normalized, contains('buy now'));
      expect(normalized, contains('promo code'));
    });

    test('Compacts spaced-out characters to prevent evasion', () {
      final compacted =
          SpamModerationService.compactAlphaNumeric('b u y   n o w   5 0 %   o f f');
      expect(compacted, contains('buynow'));
      expect(compacted, contains('50off'));
    });
  });

  group('Spam Keyword Detection Rules Tests', () {
    test('Identifies commercial promotion patterns', () {
      final sampleRules = SpamModerationService.defaultRules
          .map((r) => r['pattern']!)
          .toList();

      expect(sampleRules, contains('buy now'));
      expect(sampleRules, contains('special discount'));
      expect(sampleRules, contains('50% off'));
      expect(sampleRules, contains('essay writing service'));
    });

    test('Identifies referral and affiliate patterns', () {
      final sampleRules = SpamModerationService.defaultRules
          .map((r) => r['pattern']!)
          .toList();

      expect(sampleRules, contains('referral code'));
      expect(sampleRules, contains('free crypto'));
      expect(sampleRules, contains('earn money from home'));
    });

    test('Identifies suspicious external link shorteners', () {
      final sampleRules = SpamModerationService.defaultRules
          .map((r) => r['pattern']!)
          .toList();

      expect(sampleRules, contains('bit.ly/'));
      expect(sampleRules, contains('tinyurl.com/'));
      expect(sampleRules, contains('t.me/'));
      expect(sampleRules, contains('wa.me/'));
    });

    test('Distinguishes legitimate academic context keywords', () {
      final academicKeywords = SpamModerationService.academicContextKeywords;
      expect(academicKeywords, contains('exam'));
      expect(academicKeywords, contains('syllabus'));
      expect(academicKeywords, contains('course'));
      expect(academicKeywords, contains('textbook'));
      expect(academicKeywords, contains('assignment'));
    });
  });
}
