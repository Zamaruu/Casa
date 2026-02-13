import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_list.api.dart';
import 'package:casa/src/features/todos/data/repositories/todo_list.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoListRepositoryProvider = Provider<TodoListRepo>((ref) {
  final user = ref.read(authUserProvider);
  final api = services.api.get<ITodoListApi>();

  final source = TodoListRepoSource(
    ref: ref,
    user: user,
    api: api,
  );

  return TodoListRepository(source: source);
});

class TodoListRepository extends TodoListRepo {
  TodoListRepository({required super.source});
}
