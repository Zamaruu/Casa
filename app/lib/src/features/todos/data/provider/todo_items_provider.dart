import 'package:casa/src/features/todos/data/repositories/todo_item.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final todoItemsByListProvider = AsyncNotifierProvider.autoDispose
    .family<TodoItemsByListNotifier, IValueResponse<List<ITodoItem>>, String>(TodoItemsByListNotifier.new);

class TodoItemsByListNotifier extends AutoDisposeFamilyAsyncNotifier<IValueResponse<List<ITodoItem>>, String> {
  @override
  Future<IValueResponse<List<ITodoItem>>> build(String arg) async {
    return ref.read(todoItemRepositoryProvider).findByListId(arg);
  }
}
