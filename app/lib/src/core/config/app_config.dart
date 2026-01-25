import 'package:casa/src/core/interfaces/config/i_api_config.dart';
import 'package:shared/shared.dart';

import '../interfaces/config/i_app_config.dart';

class AppConfig implements IAppConfig {
  @override
  final IApiConfig apiConfig;

  @override
  final ELogLevel logLevel;

  @override
  final Map<String, String> rawConfigs;

  AppConfig({
    required this.apiConfig,
    required this.logLevel,
    this.rawConfigs = const {},
  });

  @override
  IDatabaseConfig get databaseConfig => throw UnimplementedError();
}
