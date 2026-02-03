import 'package:casa/src/core/api/api_client.dart';
import 'package:casa/src/core/interfaces/api/i_api.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/core/models/version/version_info.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

abstract class ApiManager implements IApi {
  final ApiClient _client;

  ApiManager(this._client);

  Dio get http => _client.dio;

  String get _metaController => '/meta';

  @override
  Future<IApiResponse<T>> runRequestGuarded<T>(Future<IApiResponse<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e, st) {
      final code = e.response?.statusCode;
      final statusCode = EHttpStatus.fromCode(code);

      final messageBuffer = StringBuffer();

      messageBuffer.writeln('Error during request (${statusCode.nameWithCode}).');
      messageBuffer.writeln('Request-URL: ${e.requestOptions.uri}');
      messageBuffer.writeln('Request-Method: ${e.requestOptions.method}');
      messageBuffer.writeln('Request-Headers: ${e.requestOptions.headers}');
      messageBuffer.writeln('Request-Data: ${e.requestOptions.data}');
      messageBuffer.writeln('Response-Data: ${e.response?.data}');

      final message = messageBuffer.toString();

      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);

      return ApiResponse.failure(message: message, error: e, stackTrace: st, httpStatus: statusCode);
    } catch (e, st) {
      final message = "Unexcpected error in API-Manager ${runtimeType.toString()}.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);

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
      final response = await http.get('$_metaController/healthcheck');

      final responseCode = response.statusCode;
      final statusCode = EHttpStatus.fromCode(responseCode);

      if (statusCode.isSuccessful) {
        return ApiResponse.success(httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }

  @override
  Future<IApiResponse<IServerVersionInfo>> version() {
    return runRequestGuarded(() async {
      final response = await http.get('$_metaController/version');

      final version = VersionInfo.fromJson(response.data);

      return ApiResponse.success(value: version);
    });
  }
}
