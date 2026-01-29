import 'package:casa/src/core/interfaces/i_api_response.dart';
import 'package:shared/shared.dart';

abstract interface class IApi {
  Future<IResponse> healthcheck();

  Future<IApiResponse<T>> runRequestGuarded<T>(Future<IApiResponse<T>> Function() request);
}
