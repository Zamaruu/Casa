import 'package:shared/shared.dart';

abstract interface class IConfig {
  Map<String, String> get rawConfigs;

  IDatabaseConfig get databaseConfig;

  ELogLevel get logLevel;
}
