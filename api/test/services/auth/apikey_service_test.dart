import 'package:casa_api/src/services/auth/apikey.service.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import '../../helpers/test_doubles.dart';

void main() {
  group('ApiKeyService', () {
    test('generateRawApiKey uses expected prefix', () {
      final service = ApiKeyService(keyOperations: TestApiKeyOperations());
      final key = service.generateRawApiKey();

      expect(key.startsWith('casa_live_'), isTrue);
    });

    test('hashApiKey is deterministic', () {
      final service = ApiKeyService(keyOperations: TestApiKeyOperations());

      final a = service.hashApiKey('raw');
      final b = service.hashApiKey('raw');

      expect(a, b);
    });

    test('authenticate returns key and updates last used for valid key', () async {
      final ops = TestApiKeyOperations();
      final service = ApiKeyService(keyOperations: ops);
      final raw = 'raw-key';
      final hash = service.hashApiKey(raw);

      ops.findByHashResponse = ValueResponse.success(
        value: ApiKey(
          id: 'k1',
          name: 'key',
          keyHash: hash,
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        ),
      );

      final key = await service.authenticate(raw);

      expect(key, isNotNull);
      expect(key!.id, 'k1');
      expect(ops.updateLastUsedCalls, 1);
    });

    test('authenticate returns null for revoked or expired key', () async {
      final ops = TestApiKeyOperations();
      final service = ApiKeyService(keyOperations: ops);
      final raw = 'raw-key';

      ops.findByHashResponse = ValueResponse.success(
        value: ApiKey(
          id: 'k1',
          name: 'key',
          keyHash: service.hashApiKey(raw),
          revokedAt: DateTime.now(),
        ),
      );
      expect(await service.authenticate(raw), isNull);

      ops.findByHashResponse = ValueResponse.success(
        value: ApiKey(
          id: 'k2',
          name: 'key',
          keyHash: service.hashApiKey(raw),
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      );
      expect(await service.authenticate(raw), isNull);
    });
  });
}
