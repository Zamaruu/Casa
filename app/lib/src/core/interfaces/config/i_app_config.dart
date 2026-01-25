import 'package:casa/src/core/interfaces/config/i_api_config.dart';
import 'package:shared/shared.dart';

abstract interface class IAppConfig implements IConfig {
  IApiConfig get apiConfig;
}
