import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';
import 'package:casa/src/features/auth/data/repositories/auth.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

final authRepositoryProvider = Provider.autoDispose<AuthRepo>((ref) {
  final storage = const FlutterSecureStorage();

  final tokenProvider = services.get<ITokenProvider>();

  final authApi = services.api.get<IAuthApi>();

  final source = AuthRepoSource(
    ref: ref,
    authApi: authApi,
    storage: storage,
    tokenProvider: tokenProvider,
  );

  return AuthRepository(source: source);
});

class AuthRepository extends AuthRepo {
  static const _tokenKey = 'casa.jwt';

  const AuthRepository({required super.source});

  @override
  Future<IValueResponse<String>> loginWithEmail({required String email, required String password}) async {
    try {
      final tokenResponse = await source.authApi.loginByEmail(email: email, password: password);

      return tokenResponse;
    } catch (e, st) {
      final message = "Unexpected error during login.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IResponse> saveAndSetToken(String token) async {
    try {
      // Set in Local Storage
      await source.storage.write(key: _tokenKey, value: token);

      // Update token in memory
      source.tokenProvider.setAccessToken(token);

      return Response.success();
    } catch (e, st) {
      final message = "Unexpected error while saving and setting token.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IValueResponse<String>> getToken() async {
    try {
      final token = await source.storage.read(key: _tokenKey);

      if (token != null) {
        return ValueResponse.success(value: token);
      } else {
        return ValueResponse.failure(message: 'No token was found!');
      }
    } catch (e, st) {
      final message = "Unexpected error while getting token.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IResponse> logout() async {
    try {
      await source.storage.delete(key: _tokenKey);

      source.tokenProvider.setAccessToken(null);

      return Response.success();
    } catch (e, st) {
      final message = "Unexpected error while logging out.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }
}
