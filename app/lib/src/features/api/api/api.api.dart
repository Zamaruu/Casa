import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/features/api/data/interfaces/i_apikey.api.dart';
import 'package:shared/shared.dart';

class ApiKeyApi extends TypedApiManager<IApiKey> implements IApiKeyApi {
  @override
  String get controller => "${EApiController.backend.endpoint}/apikeys";

  ApiKeyApi(super.client);

  @override
  IApiKey fromJson(Map<String, dynamic> json) {
    return ApiKey.fromJson(json);
  }
}
