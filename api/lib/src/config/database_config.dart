import 'package:shared/shared.dart';

class DatabaseConfig implements IDatabaseConfig {
  @override
  final String connectionString;

  @override
  final EDatabase databaseType;

  const DatabaseConfig({
    required this.connectionString,
    required this.databaseType,
  });
}
