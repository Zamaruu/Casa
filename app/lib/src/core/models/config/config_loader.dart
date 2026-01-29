import 'package:casa/src/core/models/config/api_config.dart';
import 'package:casa/src/core/models/config/app_config.dart';
import 'package:casa/src/core/models/config/router_config.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';
import 'package:universal_platform/universal_platform.dart';

class AppConfigLoader {
  static Future<AppConfig> loadConfig() async {
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      return await _loadForApp();
    } else if (UniversalPlatform.isWeb) {
      return _loadForWeb();
    } else {
      throw UnimplementedError('Cannot load config for unsupported  platform ${UniversalPlatform.operatingSystem}');
    }
  }

  static Future<AppConfig> _loadForApp() async {
    final key = 'casa.server.url';
    final storage = FlutterSecureStorage();

    final urlFromStorage = await storage.read(key: key);
    final hasUrl = urlFromStorage != null;

    late Uri apiBaseUrl;
    if (hasUrl) {
      apiBaseUrl = Uri.parse("$urlFromStorage/api");
    } else {
      apiBaseUrl = Uri.parse('https://10.0.2.2:8080/api');
    }

    appLog(message: 'API-Base-URL: $apiBaseUrl', callingClass: AppConfigLoader);

    final routerConfig = CasaRouterConfig(hasConfiguredServerUrl: hasUrl);
    final apiConfig = ApiConfig(baseUrl: apiBaseUrl);
    final logLevel = ELogLevel.debug;

    return AppConfig(
      apiConfig: apiConfig,
      logLevel: logLevel,
      routerConfig: routerConfig,
    );
  }

  static AppConfig _loadForWeb() {
    final origin = Uri.base.host;

    late Uri apiBaseUrl;

    if (kDebugMode) {
      apiBaseUrl = Uri.parse('http://$origin:8080/api');
    } else {
      apiBaseUrl = Uri.parse('https://$origin/api');
    }

    final routerConfig = const CasaRouterConfig.web();
    final apiConfig = ApiConfig(baseUrl: apiBaseUrl);
    final logLevel = ELogLevel.debug;

    return AppConfig(
      apiConfig: apiConfig,
      logLevel: logLevel,
      routerConfig: routerConfig,
    );
  }
}
