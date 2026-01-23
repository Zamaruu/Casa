import 'package:api/src/config/api_config.dart';
import 'package:api/src/config/database_config.dart';
import 'package:dotenv/dotenv.dart';
import 'package:shared/shared.dart';

class ConfigLoader {
  static IConfig load() {
    final env = DotEnv(includePlatformEnvironment: true);

    // .env nur optional laden (Docker braucht sie nicht)
    env.load();

    final databaseConfig = _loadDatabaseConfig(env);

    final logLevel = ELogLevel.getByName(env['LOG_LEVEL']);

    final config = ApiConfig(
      logLevel: logLevel,
      databaseConfig: databaseConfig,
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
}
