import 'package:casa/src/core/interfaces/config/i_api_config.dart';
import 'package:casa/src/core/interfaces/config/i_app_config.dart';
import 'package:casa/src/core/interfaces/config/i_router_config.dart';
import 'package:shared/shared.dart';

class AppConfig implements IAppConfig {
  @override
  final IRouterConfig routerConfig;

  @override
  final IApiConfig apiConfig;

  @override
  final ELogLevel logLevel;

  @override
  final Map<String, String> rawConfigs;

  AppConfig({
    required this.routerConfig,
    required this.apiConfig,
    required this.logLevel,
    this.rawConfigs = const {},
  });

  @override
  IDatabaseConfig get databaseConfig => throw UnimplementedError();
}
