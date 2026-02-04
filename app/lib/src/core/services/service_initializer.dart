import 'package:casa/src/core/api/api_client.dart';
import 'package:casa/src/core/api/api_service.dart';
import 'package:casa/src/core/auth/token/in_memeory_token_provider.dart';
import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';
import 'package:casa/src/core/interfaces/config/i_app_config.dart';
import 'package:casa/src/core/models/config/config_loader.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

abstract class ServiceInitializer {
  // region Start-Up Routines

  static Future<IValueResponse<IAppConfig>> startUpServices() async {
    try {
      final configResponse = await _loadConfig();

      if (configResponse.isError || configResponse.hasValue == false) {
        return configResponse;
      }

      final config = configResponse.value!;
      final tokenProviderResponse = await _startUpTokenProvider();
      final apiResponse = await _startUpCasaApi(config);

      final response = MultiValueResponse(
        value: config,
        responses: [
          tokenProviderResponse,
          apiResponse,
        ],
      );

      if (response.isSuccess) {
        appLog(message: "Casa-App Services started successfully.", callingClass: ServiceInitializer);
      } else {
        appLog(
          message: "One or more Casa-App Services failed to start.",
          callingClass: ServiceInitializer,
          error: response.error,
          stackTrace: response.stackTrace,
        );
      }

      return response;
    } catch (e, st) {
      final message = "Unexpected error while starting up services.";
      appLog(message: message, error: e, stackTrace: st);
      return ValueResponse.failure(
        message: message,
        error: e,
        stackTrace: st,
      );
    }
  }

  static Future<IResponse> startUpAfterUrlConfig(IAppConfig config) async {
    try {
      final apiResponse = await _startUpCasaApi(config, refresh: true);

      final response = MultiResponse(
        responses: [
          apiResponse,
        ],
      );

      if (response.isSuccess) {
        appLog(message: "Casa-App Services started successfully after url configuration.", callingClass: ServiceInitializer);
      } else {
        appLog(
          message: "One or more Casa-App Services failed to start after url configuration.",
          callingClass: ServiceInitializer,
          error: response.error,
          stackTrace: response.stackTrace,
        );
      }

      return response;
    } catch (e, st) {
      final message = "Unexpected error while starting up services after url configuration.";
      appLog(message: message, error: e, stackTrace: st);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion

  // region Config

  static Future<IValueResponse<IAppConfig>> _loadConfig() async {
    try {
      final config = await AppConfigLoader.loadConfig();
      appLog(message: "Config loaded successfully.", callingClass: ServiceInitializer);
      return ValueResponse.success(value: config);
    } catch (e, st) {
      final message = "Unexpected error while loading config.";
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion

  // region Casa-API

  static Future<IResponse> _startUpTokenProvider() async {
    try {
      final storage = FlutterSecureStorage();
      final tokenProvider = InMemoryAuthTokenProvider.empty(storage);
      services.registerSingleton<ITokenProvider>(tokenProvider);

      return Response.success();
    } catch (e, st) {
      final message = "Unexpected error while starting up ITokenProvider.";
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  static Future<IResponse> _startUpCasaApi(IAppConfig config, {bool refresh = false}) async {
    try {
      final isRegistered = services.isRegistered<ApiServiceManager>();
      if (refresh && isRegistered) {
        services.unregister<ApiServiceManager>();
      }

      final baseUrl = config.apiConfig.baseUrl;
      final apiClient = ApiClient.initial(baseUrl);
      final apiService = ApiServiceManager(client: apiClient);
      await apiService.initalize();

      services.registerSingleton<ApiServiceManager>(apiService);

      return Response.success();
    } catch (e, st) {
      final message = "Unexpected error while starting up Casa-API.";
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion
}
