import 'package:casa/src/core/api/api_client.dart';
import 'package:casa/src/core/interfaces/i_api.dart';
import 'package:casa/src/core/interfaces/i_api_response.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:shared/shared.dart';

abstract class ApiManager implements IApi {
  final ApiClient client;

  ApiManager(this.client);

  @override
  Future<IApiResponse<T>> runRequestGuarded<T>(Future<IApiResponse<T>> Function() request) async {
    try {
      return await request();
    } catch (e, st) {
      final message = "Unexcpected error in API-Manager ${runtimeType.toString()}.";

      return ApiResponse.failure(
        httpStatus: EHttpStatus.requestError,
        message: message,
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<IResponse> healthcheck() async {
    return runRequestGuarded(() async {
      final response = await client.dio.get('/healthcheck');
      final responseCode = response.statusCode;
      final statusCode = EHttpStatus.fromCode(responseCode);

      if (statusCode.isSuccessful) {
        return ApiResponse.success(httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }
}
