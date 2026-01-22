import 'package:shared/shared.dart';

abstract interface class IDatabaseConfig {
  EDatabase get databaseType;

  String get connectionString;
}
