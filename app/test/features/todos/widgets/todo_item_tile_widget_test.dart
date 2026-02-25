import 'package:casa/src/features/todos/widgets/tiles/todo_item_tile.widget.dart';
import 'package:flutter/material.dart';
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

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('TodoItemTile', () {
    testWidgets('calls onMarkDone when circle is clicked for open item', (
      tester,
    ) async {
      var markDoneCalls = 0;

      await tester.pumpWidget(
        _wrap(
          TodoItemTile(
            item: _buildTodo(status: ETodoStatus.open),
            onMarkDone: () => markDoneCalls++,
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(markDoneCalls, 1);
    });

    testWidgets('disables mark done when item is already done', (tester) async {
      var markDoneCalls = 0;

      await tester.pumpWidget(
        _wrap(
          TodoItemTile(
            item: _buildTodo(status: ETodoStatus.done),
            onMarkDone: () => markDoneCalls++,
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(markDoneCalls, 0);
    });

    testWidgets('shows loading spinner and disables mark done while loading', (
      tester,
    ) async {
      var markDoneCalls = 0;

      await tester.pumpWidget(
        _wrap(
          TodoItemTile(
            item: _buildTodo(status: ETodoStatus.open),
            markDoneLoading: true,
            onMarkDone: () => markDoneCalls++,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(markDoneCalls, 0);
    });
  });
}
