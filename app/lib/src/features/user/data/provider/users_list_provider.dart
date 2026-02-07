import 'package:casa/src/features/user/data/repositories/user.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final usersListProvider = AsyncNotifierProvider.autoDispose<UsersListNotifier, IValueResponse<List<IUser>>>(() => UsersListNotifier());

class UsersListNotifier extends AutoDisposeAsyncNotifier<IValueResponse<List<IUser>>> {
  @override
  Future<IValueResponse<List<IUser>>> build() async {
    final response = await ref.read(userRepositoryProvider).findAll();
    return response;
  }
}
