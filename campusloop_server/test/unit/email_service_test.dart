import 'package:test/test.dart';
import '../../lib/src/services/email_service.dart';

void main() {
  group('EmailService Gmail Validation Tests', () {
    test('Validates legitimate Gmail addresses', () {
      expect(EmailService.isValidGmail('student123@gmail.com'), isTrue);
      expect(EmailService.isValidGmail('siddhidheer1@gmail.com'), isTrue);
      expect(EmailService.isValidGmail('lavanyaupta136@gmail.com'), isTrue);
      expect(EmailService.isValidGmail('aggarwaldivyanshi80@gmail.com'), isTrue);
      expect(EmailService.isValidGmail('john.doe.2026@gmail.com'), isTrue);
      expect(EmailService.isValidGmail('CAPITAL.GMAIL@GMAIL.COM'), isTrue);
    });

    test('Rejects non-Gmail email addresses', () {
      expect(EmailService.isValidGmail('user@yahoo.com'), isFalse);
      expect(EmailService.isValidGmail('user@outlook.com'), isFalse);
      expect(EmailService.isValidGmail('user@hotmail.com'), isFalse);
      expect(EmailService.isValidGmail('student@campus.edu'), isFalse);
      expect(EmailService.isValidGmail('student@university.ac.in'), isFalse);
      expect(EmailService.isValidGmail('user@icloud.com'), isFalse);
    });

    test('Rejects disposable and temporary email addresses', () {
      expect(EmailService.isValidGmail('temp1234@mailinator.com'), isFalse);
      expect(EmailService.isValidGmail('fake@10minutemail.com'), isFalse);
      expect(EmailService.isValidGmail('burner@trashmail.com'), isFalse);
      expect(EmailService.isValidGmail('user+temp@gmail.com'), isFalse);
      expect(EmailService.isValidGmail('fakeuser@gmail.com'), isFalse);
    });

    test('Rejects malformed and invalid email formats', () {
      expect(EmailService.isValidGmail(''), isFalse);
      expect(EmailService.isValidGmail('notanemail'), isFalse);
      expect(EmailService.isValidGmail('@gmail.com'), isFalse);
      expect(EmailService.isValidGmail('abc@gmail.com'), isFalse); // under 6 chars
      expect(EmailService.isValidGmail('.leadingdot@gmail.com'), isFalse);
      expect(EmailService.isValidGmail('trailingdot.@gmail.com'), isFalse);
      expect(EmailService.isValidGmail('double..dot@gmail.com'), isFalse);
      expect(EmailService.isValidGmail('spaces in email@gmail.com'), isFalse);
      expect(EmailService.isValidGmail('user@gmail.com.co'), isFalse);
    });
  });

  group('EmailService Secure OTP and Cryptography Tests', () {
    test('Generates random 6-digit numeric OTP', () {
      final otp = EmailService.generateSecureOtp();
      expect(otp.length, equals(6));
      expect(int.tryParse(otp), isNotNull);
      final value = int.parse(otp);
      expect(value, greaterThanOrEqualTo(100000));
      expect(value, lessThanOrEqualTo(999999));
    });

    test('Hashes OTP with cryptographic salt (never plain text)', () {
      final otp = '748291';
      final salt = EmailService.generateSalt();
      final hash1 = EmailService.hashOtp(otp, salt);
      final hash2 = EmailService.hashOtp(otp, salt);
      expect(hash1, equals(hash2));
      expect(hash1, isNot(equals(otp)));

      final differentSalt = EmailService.generateSalt();
      final hashDifferentSalt = EmailService.hashOtp(otp, differentSalt);
      expect(hash1, isNot(equals(hashDifferentSalt)));
    });

    test('Hashes passwords with salt securely', () {
      final pwd = 'SecurePassword123!';
      final salt = EmailService.generateSalt();
      final hash = EmailService.hashPassword(pwd, salt);
      expect(hash.length, equals(64)); // SHA-256 hex string
      expect(hash, isNot(contains(pwd)));
    });
  });
}
