import 'package:casa/src/core/extensions/list.extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final usersListProvider = NotifierProvider.autoDispose<UsersListNotifier, List<IUser>>(() => UsersListNotifier());

class UsersListNotifier extends AutoDisposeNotifier<List<IUser>> {
  @override
  List<IUser> build() {
    return [];
  }

  void add(IUser user) {
    if (state.contains(user)) {
      return;
    }

    state = [...state, user];
  }

  void set(List<IUser> users) {
    state = [...users];
  }

  IUser? find(String id) {
    return state.firstWhereOrNull((user) => user.id == id);
  }
}
