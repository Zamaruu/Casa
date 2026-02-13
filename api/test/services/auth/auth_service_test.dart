import 'package:casa_api/src/services/auth/auth.service.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import '../../helpers/test_doubles.dart';

void main() {
  group('ApiAuthService', () {
    test('authenticate returns token when user exists and password is valid', () async {
      final user = User(
        id: 'u1',
        email: 'user@test.dev',
        username: 'user',
        passwordHash: const PasswordHasher().hash('pw-123'),
      );

      final userOps = TestUserOperations()
        ..findByEmailResponse = ValueResponse.success(value: user);
      final auth = TestUserAuthenticator(tokenToGenerate: 'jwt-token');

      final service = ApiAuthService(userOperations: userOps, userAuthenticator: auth);

      final response = await service.authenticate('user@test.dev', 'pw-123');

      expect(response.isSuccess, isTrue);
      expect(response.value, 'jwt-token');
    });

    test('authenticate fails when user lookup fails', () async {
      final userOps = TestUserOperations()
        ..findByEmailResponse = const ValueResponse.failure(message: 'not found');
      final auth = TestUserAuthenticator();

      final service = ApiAuthService(userOperations: userOps, userAuthenticator: auth);
      final response = await service.authenticate('missing@test.dev', 'pw');

      expect(response.isError, isTrue);
      expect(response.message, 'not found');
    });

    test('authenticate fails when password is invalid', () async {
      final user = User(
        id: 'u1',
        email: 'user@test.dev',
        username: 'user',
        passwordHash: const PasswordHasher().hash('correct'),
      );

      final userOps = TestUserOperations()
        ..findByEmailResponse = ValueResponse.success(value: user);
      final auth = TestUserAuthenticator(tokenToGenerate: 'jwt-token');

      final service = ApiAuthService(userOperations: userOps, userAuthenticator: auth);
      final response = await service.authenticate('user@test.dev', 'wrong');

      expect(response.isError, isTrue);
      expect(response.message, 'Invalid password');
    });
  });
}
