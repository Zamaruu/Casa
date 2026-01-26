import 'package:casa/src/app/abstract/repositories/base_repo.dart';
import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';
import 'package:shared/shared.dart';

class AuthRepoSource extends RepoSource {
  final IAuthApi authApi;

  const AuthRepoSource({
    required super.user,
    required this.authApi,
  });
}

abstract class AuthRepo extends BaseRepo<AuthRepoSource> {
  const AuthRepo({required super.source});

  Future<IValueResponse<String>> loginWithEmail({required String email, required String password});
}
