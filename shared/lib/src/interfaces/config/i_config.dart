import 'package:shared/shared.dart';

/// Root runtime configuration contract for the application.
abstract interface class IConfig {
  /// Raw key-value configuration map as loaded from environment/config source.
  ///
  /// Returns `Map<String, String>`.
  Map<String, String> get rawConfigs;

  /// Structured database-related configuration.
  ///
  /// Returns `IDatabaseConfig`.
  IDatabaseConfig get databaseConfig;

  /// Active logging level for runtime logging behavior.
  ///
  /// Returns `ELogLevel`.
  ELogLevel get logLevel;
}
