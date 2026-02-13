import 'package:casa_api/src/models/auth/auth_context.dart';
import 'package:casa_api/src/models/enums/e_auth_type.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('AuthContext', () {
    test('user ctor sets user type', () {
      const user = User(id: 'u1', email: 'u@t.dev', username: 'u', passwordHash: 'h');
      const context = AuthContext.user(user);

      expect(context.type, EAuthType.user);
      expect(context.principal, same(user));
    });

    test('apiKey ctor sets apiKey type', () {
      const key = ApiKey(id: 'k1', name: 'key', keyHash: 'h');
      const context = AuthContext.apiKey(key);

      expect(context.type, EAuthType.apiKey);
      expect(context.principal, same(key));
    });
  });
}
