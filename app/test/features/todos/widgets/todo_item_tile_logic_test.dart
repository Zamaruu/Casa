import 'package:casa/src/features/todos/widgets/tiles/todo_item_tile.widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

Todo _buildTodo({ETodoStatus status = ETodoStatus.open}) {
  return Todo(
    id: 'todo-1',
    listId: 'list-1',
    title: 'Buy milk',
    description: '2l whole milk',
    status: status,
    priority: ETodoPriority.medium,
    createdByUserId: 'user-1',
  );
}

void main() {
  group('canMarkTodoAsDone', () {
    test('returns true for open todo when not loading', () {
      final todo = _buildTodo(status: ETodoStatus.open);

      final result = canMarkTodoAsDone(
        item: todo,
        markDoneLoading: false,
      );

      expect(result, isTrue);
    });

    test('returns false for done todo', () {
      final todo = _buildTodo(status: ETodoStatus.done);

      final result = canMarkTodoAsDone(
        item: todo,
        markDoneLoading: false,
      );

      expect(result, isFalse);
    });

    test('returns false when loading', () {
      final todo = _buildTodo(status: ETodoStatus.open);

      final result = canMarkTodoAsDone(
        item: todo,
        markDoneLoading: true,
      );

      expect(result, isFalse);
    });
  });
}
