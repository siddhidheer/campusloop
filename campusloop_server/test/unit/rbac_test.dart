import 'package:test/test.dart';
import '../../lib/src/services/rbac_service.dart';

void main() {
  group('RbacService Initial Administrators Tests', () {
    test('Correctly identifies the three initially authorized administrators', () {
      expect(RbacService.isInitialAdmin('siddhidheer1@gmail.com'), isTrue);
      expect(RbacService.isInitialAdmin('lavanyaupta136@gmail.com'), isTrue);
      expect(RbacService.isInitialAdmin('aggarwaldivyanshi80@gmail.com'), isTrue);
    });

    test('Case-insensitive match for initial administrator emails', () {
      expect(RbacService.isInitialAdmin('SIDDHIDHEER1@GMAIL.COM'), isTrue);
      expect(RbacService.isInitialAdmin('LavanyaUpta136@Gmail.Com'), isTrue);
      expect(RbacService.isInitialAdmin(' AggarwalDivyanshi80@gmail.com '), isTrue);
    });

    test('Rejects arbitrary emails as initial administrators', () {
      expect(RbacService.isInitialAdmin('otherstudent@gmail.com'), isFalse);
      expect(RbacService.isInitialAdmin('admin@campus.edu'), isFalse);
      expect(RbacService.isInitialAdmin('hacker@gmail.com'), isFalse);
    });
  });
}
