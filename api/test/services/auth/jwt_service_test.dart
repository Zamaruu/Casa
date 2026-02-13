import 'package:casa_api/src/services/auth/jwt.service.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('JwtService', () {
    test('generate + authenticate roundtrip returns user', () async {
      final service = JwtService(secret: 'secret-123', tokenLifetime: const Duration(hours: 1));
      final user = User(
        id: 'u1',
        email: 'a@b.c',
        username: 'alice',
        passwordHash: 'hash',
        groups: const ['user'],
        createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2025-01-02T00:00:00Z'),
      );

      final token = service.generate(user);
      final authenticated = await service.authenticate(token);

      expect(authenticated, isNotNull);
      expect(authenticated!.id, 'u1');
      expect(authenticated.email, 'a@b.c');
      expect(authenticated.username, 'alice');
    });

    test('authenticate returns null for invalid jwt', () async {
      final service = JwtService(secret: 'secret-123', tokenLifetime: const Duration(hours: 1));
      final token = 'invalid-token';

      final result = await service.authenticate(token);

      expect(result, isNull);
    });

    test('verify returns claims map', () {
      final service = JwtService(secret: 'secret-123', tokenLifetime: const Duration(hours: 1));
      final user = User(
        id: 'u2',
        email: 'x@y.z',
        username: 'bob',
        passwordHash: 'hash',
      );

      final token = service.generate(user);
      final claims = service.verify(token);

      expect(claims['id'], 'u2');
      expect(claims['email'], 'x@y.z');
      expect(claims['username'], 'bob');
    });
  });
}
