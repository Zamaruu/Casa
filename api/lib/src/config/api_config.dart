import 'package:casa_api/src/config/auth_config.dart';
import 'package:shared/shared.dart';

class ApiConfig implements IConfig {
  @override
  final ELogLevel logLevel;

  @override
  final IDatabaseConfig databaseConfig;

  final AuthConfig authConfig;

  @override
  final Map<String, String> rawConfigs;

  const ApiConfig({
    required this.logLevel,
    required this.databaseConfig,
    required this.authConfig,
    this.rawConfigs = const {},
  });
}
