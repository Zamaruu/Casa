import 'package:casa_api/src/config/api_config.dart';
import 'package:casa_api/src/database/database.service.dart';
import 'package:casa_api/src/interfaces/i_api_config.dart';
import 'package:casa_api/src/services/auth/auth.service.dart';
import 'package:casa_api/src/services/auth/jwt.service.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:casa_api/src/utils/logger.util.dart';
import 'package:shared/shared.dart';

abstract class ServiceInitializer {
  static Future<IResponse> startUpServices(IApiConfig config) async {
    try {
      final configResponse = await _initializeConfig(config);

      // Storage
      final dbResponse = await _initializeDatabases(
        config.databaseConfig.databaseType,
        config.databaseConfig.connectionString,
      );

      // Auth
      final tokenResponse = await _initializeTokenService(config);
      final authResponse = await _initializeAuthService();

      final serviceResponses = MultiResponse(
        responses: [
          configResponse,
          dbResponse,
          tokenResponse,
          authResponse,
        ],
      );

      return serviceResponses;
    } catch (e, st) {
      final message = 'Unexpected error while starting up services.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: ServiceInitializer);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // region Config

  static Future<IResponse> _initializeConfig(IApiConfig config) async {
    try {
      services.registerSingleton<IApiConfig>(config);

      return Response.success();
    } catch (e, st) {
      final message = 'Error while initializing config.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: ServiceInitializer);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion

  // region Storage

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

  // region Authentication

  static Future<IResponse> _initializeTokenService(IConfig config) async {
    try {
      final ApiConfig apiConfig = config as ApiConfig;
      final authConfig = apiConfig.authConfig;

      final jwtService = JwtService(
        secret: authConfig.jwtSecret,
        tokenLifetime: authConfig.expiresIn,
      );

      services.registerSingleton<JwtService>(jwtService);

      return Response.success();
    } catch (e, st) {
      final message = 'Error while initializing token service.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: ServiceInitializer);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  static Future<IResponse> _initializeAuthService() async {
    try {
      final authService = ApiAuthService(
        userOperations: services.database.get<IUserOperations>(),
        jwtService: services.get<JwtService>(),
      );

      services.registerSingleton<IAuthService>(authService);

      return Response.success();
    } catch (e, st) {
      final message = 'Error while initializing auth service.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: ServiceInitializer);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion
}
