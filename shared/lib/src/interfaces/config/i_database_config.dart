import 'package:shared/shared.dart';

/// Database-specific configuration contract.
abstract interface class IDatabaseConfig {
  /// Selected backend database type used by persistence services.
  ///
  /// Returns `EDatabase`.
  EDatabase get databaseType;

  /// Connection string used to connect to the configured database backend.
  ///
  /// Returns `String`.
  String get connectionString;
}
