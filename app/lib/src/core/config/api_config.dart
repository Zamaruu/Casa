import 'package:casa/src/core/interfaces/config/i_api_config.dart';

class ApiConfig implements IApiConfig {
  @override
  final Uri baseUrl;

  const ApiConfig({
    required this.baseUrl,
  });
}
