import 'package:casa/src/features/todos/data/repositories/todo_list.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final todoListsProvider =
    AsyncNotifierProvider.autoDispose<TodoListsNotifier, IValueResponse<List<ITodoList>>>(() => TodoListsNotifier());

class TodoListsNotifier extends AutoDisposeAsyncNotifier<IValueResponse<List<ITodoList>>> {
  @override
  Future<IValueResponse<List<ITodoList>>> build() async {
    return ref.read(todoListRepositoryProvider).findAll();
  }
}
