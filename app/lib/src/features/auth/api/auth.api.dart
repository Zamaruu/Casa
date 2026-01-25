import 'package:casa/src/core/api/api_manager.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';

class AuthApi extends ApiManager implements IAuthApi {
  AuthApi(super.client);

  @override
  Future<String?> loginByEmail({
    required String email,
    required String passwordHash,
  }) async {
    final response = await client.dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': passwordHash,
      },
    );

    return response.data['accessToken'];
  }
}
