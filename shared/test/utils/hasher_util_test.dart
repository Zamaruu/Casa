import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('PasswordHasher', () {
    test('hash creates non-empty hash different from plain password', () {
      const hasher = PasswordHasher();

      final hash = hasher.hash('my-secret');

      expect(hash, isNotEmpty);
      expect(hash, isNot('my-secret'));
    });

    test('verify succeeds with original password and fails with wrong password', () {
      const hasher = PasswordHasher();
      final hash = hasher.hash('correct-password');

      expect(hasher.verify('correct-password', hash), isTrue);
      expect(hasher.verify('wrong-password', hash), isFalse);
    });
  });
}
