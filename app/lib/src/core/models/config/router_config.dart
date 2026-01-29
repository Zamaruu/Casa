import 'package:casa/src/core/interfaces/config/i_router_config.dart';
import 'package:universal_platform/universal_platform.dart';

class CasaRouterConfig implements IRouterConfig {
  @override
  final bool hasConfiguredServerUrl;

  const CasaRouterConfig({required this.hasConfiguredServerUrl});

  const CasaRouterConfig.web() : hasConfiguredServerUrl = true;

  @override
  bool get isMobile => UniversalPlatform.isMobile;

  @override
  bool get isWeb => UniversalPlatform.isWeb;
}
