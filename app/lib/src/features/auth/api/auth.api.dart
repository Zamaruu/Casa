import 'package:casa/src/core/api/api_manager.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';

class AuthApi extends ApiManager implements IAuthApi {
  AuthApi(super.client);

  @override
  Future<String?> loginByEmail({
    required String email,
    required String password,
  }) async {
    final response = await client.dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return response.data['accessToken'];
  }
}
