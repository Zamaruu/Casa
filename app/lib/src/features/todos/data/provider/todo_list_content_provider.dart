import 'dart:async';
import 'package:casa/src/features/todos/data/provider/todo_items_provider.dart';
import 'package:casa/src/features/todos/data/repositories/todo_list.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final todoListContentProvider = AsyncNotifierProvider.autoDispose.family<TodoListContentNotifier, IValueResponse<ITodoList>, String>(
  TodoListContentNotifier.new,
);

class TodoListContentNotifier extends AutoDisposeFamilyAsyncNotifier<IValueResponse<ITodoList>, String> {
  @override
  Future<IValueResponse<ITodoList>> build(String listId) async {
    final todoListResponse = await ref.read(todoListRepositoryProvider).find(listId);
    final todosResponse = await ref.read(todoItemsByListProvider(listId).future);

    if (!todoListResponse.isSuccess || !todosResponse.isSuccess) {
      final listMessage = todoListResponse.message ?? '';
      final todosMessage = todosResponse.message ?? '';
      final concattedMessages = '$listMessage, $todosMessage';
      return ValueResponse.failure(message: concattedMessages);
    } else {
      var todoList = todoListResponse.value!;
      final todos = todosResponse.value!;

      todoList = todoList.copyWith(todos: todos);
      return ValueResponse.success(value: todoList);
    }
  }
}
