import 'package:casa_api/src/config/api_config.dart';
import 'package:casa_api/src/config/auth_config.dart';
import 'package:casa_api/src/config/database_config.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('Config models', () {
    test('AuthConfig stores constructor values', () {
      final config = AuthConfig(jwtSecret: 'secret', expiresIn: const Duration(hours: 12));

      expect(config.jwtSecret, 'secret');
      expect(config.expiresIn, const Duration(hours: 12));
    });

    test('DatabaseConfig stores constructor values', () {
      const config = DatabaseConfig(
        connectionString: 'mongodb://localhost:27017/casa',
        databaseType: EDatabase.mongodb,
      );

      expect(config.connectionString, contains('mongodb://'));
      expect(config.databaseType, EDatabase.mongodb);
    });

    test('ApiConfig stores constructor values', () {
      const db = DatabaseConfig(connectionString: 'mongodb://localhost', databaseType: EDatabase.mongodb);
      final auth = AuthConfig(jwtSecret: 'secret', expiresIn: const Duration(hours: 1));
      final config = ApiConfig(
        logLevel: ELogLevel.warn,
        databaseConfig: db,
        authConfig: auth,
        enableOpenApi: true,
        rawConfigs: const {'A': 'B'},
      );

      expect(config.logLevel, ELogLevel.warn);
      expect(config.databaseConfig, same(db));
      expect(config.authConfig, same(auth));
      expect(config.enableOpenApi, isTrue);
      expect(config.rawConfigs['A'], 'B');
    });
  });
}
