import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_item.api.dart';
import 'package:casa/src/features/todos/data/repositories/todo_item.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoRepositoryProvider = Provider<TodoItemRepo>((ref) {
  final user = ref.read(authUserProvider);
  final api = services.api.get<ITodoItemApi>();

  final source = TodoItemRepoSource(
    ref: ref,
    user: user,
    api: api,
  );

  return TodoItemRepository(source: source);
});

class TodoItemRepository extends TodoItemRepo {
  TodoItemRepository({required super.source});
}
