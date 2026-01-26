import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';
import 'package:casa/src/features/auth/data/repositories/auth.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final user = User.initial();

  final authApi = services.api.get<IAuthApi>();

  final source = AuthRepoSource(
    user: user,
    authApi: authApi,
  );

  return AuthRepository(source: source);
});

class AuthRepository extends AuthRepo {
  AuthRepository({required super.source});

  @override
  Future<IValueResponse<String>> loginWithEmail({required String email, required String password}) async {
    try {
      final token = await source.authApi.loginByEmail(email: email, password: password);

      if (token != null) {
        return ValueResponse.success(value: token);
      } else {
        return ValueResponse.failure(message: 'Login failed');
      }
    } catch (e, st) {
      final message = "Unexpected error during login.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }
}
