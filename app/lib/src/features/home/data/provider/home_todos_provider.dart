import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/features/todos/data/provider/todo_items_provider.dart';
import 'package:casa/src/features/todos/data/provider/todo_lists_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class HomeTodosSections {
  final List<ITodo> dueTodos;
  final List<ITodo> recentlyAssignedTodos;

  const HomeTodosSections({
    required this.dueTodos,
    required this.recentlyAssignedTodos,
  });
}

final homeTodosSectionsProvider = FutureProvider.autoDispose<HomeTodosSections>(
  (ref) async {
    final currentUser = ref.watch(authUserProvider);
    final currentUserId = currentUser.id;

    final listsResponse = await ref.watch(todoListsProvider.future);
    final lists = listsResponse.value ?? const <ITodoList>[];

    if (lists.isEmpty) {
      return const HomeTodosSections(
        dueTodos: [],
        recentlyAssignedTodos: [],
      );
    }

    final todoResponses = await Future.wait(
      lists.map((list) => ref.watch(todoItemsByListProvider(list.id).future)),
    );

    final allTodos = <ITodo>[];
    for (final response in todoResponses) {
      if (response.isSuccess && response.hasValue) {
        allTodos.addAll(response.value!);
      }
    }

    final dueTodos =
        allTodos
            .where(
              (todo) =>
                  todo.dueDate != null &&
                  todo.status != ETodoStatus.done &&
                  todo.status != ETodoStatus.archived,
            )
            .toList()
          ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    final recentlyAssignedTodos =
        allTodos
            .where(
              (todo) =>
                  currentUserId.isNotEmpty &&
                  todo.assignedUserIds.contains(currentUserId) &&
                  todo.status != ETodoStatus.done &&
                  todo.status != ETodoStatus.archived,
            )
            .toList()
          ..sort((a, b) {
            final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate);
          });

    return HomeTodosSections(
      dueTodos: dueTodos,
      recentlyAssignedTodos: recentlyAssignedTodos,
    );
  },
);
