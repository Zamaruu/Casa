import 'package:casa_api/src/services/auth/user_context.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('UserContext', () {
    test('group checks and isAdmin work', () {
      const user = User(
        id: 'u1',
        email: 'u@t.dev',
        username: 'user',
        passwordHash: 'hash',
        groups: ['user', 'admin'],
      );

      final ctx = UserContext(user);

      expect(ctx.hasGroup('admin'), isTrue);
      expect(ctx.hasAnyGroup(['guest', 'user']), isTrue);
      expect(ctx.isAdmin, isTrue);
    });
  });
}
