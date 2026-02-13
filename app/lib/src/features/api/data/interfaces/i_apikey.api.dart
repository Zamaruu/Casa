import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:casa/src/features/api/data/models/create_apikey_wrapper.dart';
import 'package:shared/shared.dart';

abstract interface class IApiKeyApi implements ITypedApi<IApiKey> {
  Future<IApiResponse<CreateApiKeyWrapper>> createApiKey(IApiKey entity);
}
