import 'package:casa/src/core/api/api_client.dart';
import 'package:casa/src/core/api/api_service.dart';
import 'package:casa/src/core/auth/token/in_memeory_token_provider.dart';
import 'package:casa/src/core/config/config_loader.dart';
import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';
import 'package:casa/src/core/interfaces/config/i_app_config.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:shared/shared.dart';

abstract class ServiceInitializer {
  static Future<IResponse> startUpServices() async {
    try {
      final configResponse = await _loadConfig();

      if (configResponse.isError || configResponse.hasValue == false) {
        return configResponse;
      }

      final config = configResponse.value!;
      final tokenProviderResponse = await _startUpTokenProvider();
      final apiResponse = await _startUpCasaApi(config);

      appLog(message: "Casa-App Services started successfully.", callingClass: ServiceInitializer);

      return MultiResponse([
        tokenProviderResponse,
        apiResponse,
      ]);
    } catch (e, st) {
      final message = "Unexpected error while starting up services.";
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // region Config

  static Future<IValueResponse<IAppConfig>> _loadConfig() async {
    try {
      final config = AppConfigLoader.loadConfig();
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
      final tokenProvider = InMemoryAuthTokenProvider.empty();
      services.registerSingleton<ITokenProvider>(tokenProvider);
      return Response.success();
    } catch (e, st) {
      final message = "Unexpected error while starting up ITokenProvider.";
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  static Future<IResponse> _startUpCasaApi(IAppConfig config) async {
    try {
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
