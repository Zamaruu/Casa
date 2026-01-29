import 'package:casa/src/core/api/api_manager.dart';
import 'package:casa/src/core/interfaces/i_api_response.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class AuthApi extends ApiManager implements IAuthApi {
  AuthApi(super.client);

  @override
  Future<IApiResponse<String>> loginByEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final token = response.data['accessToken'];
      return ApiResponse.success(value: token);
    } on DioException catch (e, st) {
      final code = e.response?.statusCode;
      final statusCode = EHttpStatus.fromCode(code);

      final message = 'Error during login (${statusCode.nameWithCode}).';
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ApiResponse.failure(message: message, error: e, stackTrace: st, httpStatus: statusCode);
    } catch (e, st) {
      final message = "Unexpected error during login.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ApiResponse.failure(message: message, error: e, stackTrace: st, httpStatus: EHttpStatus.requestError);
    }
  }
}
