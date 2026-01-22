import 'package:shared/src/interfaces/config/i_database_config.dart';

abstract interface class IConfig {
  Map<String, String> get rawConfigs;

  IDatabaseConfig get databaseConfig;
}
