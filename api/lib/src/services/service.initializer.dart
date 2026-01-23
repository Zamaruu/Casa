import 'package:api/src/database/database.service.dart';
import 'package:api/src/services/service_locator.dart';
import 'package:api/src/utils/logger.util.dart';
import 'package:shared/shared.dart';

abstract class ServiceInitializer {
  static Future<IResponse> startUpServices(IConfig config) async {
    try {
      final dbResponse = await _initializeDatabases(
        config.databaseConfig.databaseType,
        config.databaseConfig.connectionString,
      );

      final serviceResponses = MultiResponse([
        dbResponse,
      ]);

      return serviceResponses;
    } catch (e, st) {
      final message = 'Unexpected error while starting up services.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: ServiceInitializer);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // region Databases

  static Future<IResponse> _initializeDatabases(EDatabase databaseType, String databaseConnectionString) async {
    try {
      final database = DatabaseServiceCollection(
        database: databaseType,
        databaseConnectionString: databaseConnectionString,
      );

      await database.initalize();
      services.registerSingleton<DatabaseServiceCollection>(database);

      return Response.success();
    } catch (e, st) {
      final message = 'Error while initializing database.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: ServiceInitializer);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion
}
