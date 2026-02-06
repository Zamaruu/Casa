import 'package:casa_api/src/config/api_config.dart';
import 'package:casa_api/src/config/auth_config.dart';
import 'package:casa_api/src/config/database_config.dart';
import 'package:casa_api/src/interfaces/i_api_config.dart';
import 'package:dotenv/dotenv.dart';
import 'package:shared/shared.dart';

class ConfigLoader {
  static IApiConfig load() {
    final env = DotEnv(includePlatformEnvironment: true);

    // Load .env only optionally (Docker does not need it)
    env.load();

    final databaseConfig = _loadDatabaseConfig(env);

    final authConfig = _loadAuthConfig(env);

    final logLevel = ELogLevel.getByName(env['LOG_LEVEL']);

    final enableOpenApi = env['ENABLE_OPENAPI'] == "true";

    final config = ApiConfig(
      logLevel: logLevel,
      authConfig: authConfig,
      databaseConfig: databaseConfig,
      enableOpenApi: enableOpenApi,
    );

    return config;
  }

  static IDatabaseConfig _loadDatabaseConfig(DotEnv env) {
    final databaseType = EDatabase.getByName(env['DB_TYPE']);
    final connectionString = env['DB_CONNECTION_STRING']!;

    return DatabaseConfig(
      databaseType: databaseType,
      connectionString: connectionString,
    );
  }

  static AuthConfig _loadAuthConfig(DotEnv env) {
    final jwtSecret = env['JWT_SECRET']!;

    final expiresInHours = int.tryParse(env['JWT_EXPIRES_IN'] ?? "") ?? 48;

    final expiresIn = Duration(hours: expiresInHours);

    return AuthConfig(
      jwtSecret: jwtSecret,
      expiresIn: expiresIn,
    );
  }
}
