import 'package:casa/src/core/config/api_config.dart';
import 'package:casa/src/core/config/app_config.dart';
import 'package:shared/shared.dart';
import 'package:universal_platform/universal_platform.dart';

class AppConfigLoader {
  static AppConfig loadConfig() {
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      return _loadForWeb();
    } else if (UniversalPlatform.isWeb) {
      return _loadForApp();
    } else {
      throw UnimplementedError('Cannot load config for unsupported  platform ${UniversalPlatform.operatingSystem}');
    }
  }

  static AppConfig _loadForApp() {
    // TODO: Implement loading url by sercure preferences
    final apiBaseUrl = Uri.parse('http://localhost:8080/api');

    final apiConfig = ApiConfig(baseUrl: apiBaseUrl);
    final logLevel = ELogLevel.debug;

    return AppConfig(apiConfig: apiConfig, logLevel: logLevel);
  }

  static AppConfig _loadForWeb() {
    final origin = Uri.base.host;

    final apiBaseUrl = Uri.parse('$origin/api');

    final apiConfig = ApiConfig(baseUrl: apiBaseUrl);
    final logLevel = ELogLevel.debug;

    return AppConfig(apiConfig: apiConfig, logLevel: logLevel);
  }
}
