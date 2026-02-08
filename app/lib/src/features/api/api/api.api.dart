import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/features/api/data/interfaces/i_apikey.api.dart';
import 'package:casa/src/features/api/data/models/create_apikey_wrapper.dart';
import 'package:shared/shared.dart';

class ApiKeyApi extends TypedApiManager<IApiKey> implements IApiKeyApi {
  @override
  String get controller => "${EApiController.backend.endpoint}/apikeys";

  ApiKeyApi(super.client);

  @override
  IApiKey fromJson(Map<String, dynamic> json) {
    return ApiKey.fromJson(json);
  }

  @override
  Future<IApiResponse<CreateApiKeyWrapper>> createApiKey(IApiKey entity) async {
    return runRequestGuarded(() async {
      final response = await http.post(
        controller,
        data: entity.toJson(),
      );
      final statusCode = EHttpStatus.fromCode(response.statusCode);

      final data = response.data;
      final savedEntity = CreateApiKeyWrapper.fromJson(data);

      if (statusCode.isSuccessful) {
        return ApiResponse.success(value: savedEntity, httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }
}
