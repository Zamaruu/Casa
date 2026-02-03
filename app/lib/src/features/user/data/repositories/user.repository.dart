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
  const UserRepository({required super.source});

  @override
  Future<IValueResponse<IUser>> find(String id) async {
    return runGuardedValue(() async {
      final fromCache = ref.read(usersListProvider.notifier).find(id);

      if (fromCache != null) {
        return ValueResponse.success(value: fromCache);
      } else {
        final response = await super.find(id);

        if (response.isSuccess && response.hasValue) {
          final user = response.value!;
          ref.read(usersListProvider.notifier).add(user);
          return ValueResponse.success(value: user);
        } else {
          return ValueResponse.failure(message: response.message);
        }
      }
    });
  }

  @override
  Future<IValueResponse<List<IUser>>> findAll() async {
    return runGuardedValue(() async {
      final fromCache = ref.read(usersListProvider);

      if (fromCache.isNotEmpty) {
        return ValueResponse.success(value: fromCache);
      } else {
        final response = await super.findAll();

        if (response.isSuccess && response.hasValue) {
          final users = response.value!;
          ref.read(usersListProvider.notifier).set(users);
          return ValueResponse.success(value: users);
        } else {
          return ValueResponse.failure(message: response.message);
        }
      }
    });
  }
}
