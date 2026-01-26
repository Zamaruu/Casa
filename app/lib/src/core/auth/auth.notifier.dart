import 'package:casa/src/core/auth/auth.state.dart';
import 'package:casa/src/features/auth/data/repositories/auth.repository.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  static const _tokenKey = 'casa.jwt';

  final _storage = const FlutterSecureStorage();

  @override
  Future<AuthState> build() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) {
      return AuthState.initial();
    }

    final user = _userFromJwt(token);
    return AuthState(user: user, token: token);
  }

  // region Auth-Methods

  Future<IResponse> login(String email, String password) async {
    state = const AsyncLoading();

    final tokenResponse = await ref.read(authRepositoryProvider).loginWithEmail(email: email, password: password);

    if (tokenResponse.isError || tokenResponse.hasValue == false) {
      state = AsyncData(AuthState.initial());
      return tokenResponse;
    }

    final token = tokenResponse.value!;

    await _persistAndSetToken(token);

    return Response.success();
  }

  Future<IResponse> loginWithToken(String token) async {
    state = const AsyncLoading();

    await _persistAndSetToken(token);

    return Response.success();
  }

  Future<IResponse> logout() async {
    await _storage.delete(key: _tokenKey);
    state = AsyncData(AuthState.initial());
    return Response.success();
  }

  // endregion

  // region Helpers

  IUser _userFromJwt(String token) {
    final jwt = JWT.decode(token);
    final claims = jwt.payload as Map<String, dynamic>;
    return User.fromJson(claims);
  }

  Future<void> _persistAndSetToken(String token) async {
    final user = _userFromJwt(token);
    await _storage.write(key: _tokenKey, value: token);

    state = AsyncData(
      AuthState(user: user, token: token),
    );
  }

  // endregion
}
