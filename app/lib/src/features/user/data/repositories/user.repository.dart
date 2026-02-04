import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/features/user/data/interfaces/i_user.api.dart';
import 'package:casa/src/features/user/data/provider/users_list_provider.dart';
import 'package:casa/src/features/user/data/repositories/user.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final userRepositoryProvider = Provider<UserRepo>((ref) {
  final user = ref.read(authUserProvider);

  final userApi = services.api.get<IUserApi>();

  final source = UserRepoSource(
    ref: ref,
    user: user,
    api: userApi,
  );

  return UserRepository(source: source);
});

class UserRepository extends UserRepo {
  UserRepository({required super.source});
}
