import 'package:casa/src/app/abstract/repositories/base_repo.dart';
import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

class AuthRepoSource extends RepoSource {
  final IAuthApi authApi;

  final ITokenProvider tokenProvider;

  final FlutterSecureStorage storage;

  const AuthRepoSource({
    required super.ref,
    required this.authApi,
    required this.tokenProvider,
    required this.storage,
  });
}

abstract class AuthRepo extends BaseRepo<AuthRepoSource> {
  const AuthRepo({required super.source});

  Future<IValueResponse<String>> loginWithEmail({required String email, required String password});

  Future<IResponse> saveAndSetToken(String token);

  Future<IValueResponse<String>> getToken();

  Future<IResponse> logout();
}
