import 'package:shared/shared.dart';

class ApiConfig implements IConfig {
  @override
  final ELogLevel logLevel;

  @override
  final IDatabaseConfig databaseConfig;

  @override
  final Map<String, String> rawConfigs;

  const ApiConfig({
    required this.logLevel,
    required this.databaseConfig,
    this.rawConfigs = const {},
  });
}
