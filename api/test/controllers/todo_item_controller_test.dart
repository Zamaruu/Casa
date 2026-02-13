import 'dart:convert';

import 'package:casa_api/src/controllers/todo_item.controller.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../helpers/test_doubles.dart';

void main() {
  group('TodoItemController', () {
    test('getByListId returns 200 with serialized items', () async {
      final operations = TestTodoItemOperations()
        ..byListResponse = ValueResponse.success(
          value: const [
            TodoItem(
              id: 'i1',
              listId: 'l1',
              title: 'Item',
              createdByUserId: 'u1',
            ),
          ],
        );
      final controller = TodoItemController(operations: operations, logger: TestLogger());
      controller.registerEndpoints();

      final response = await controller.getByListId(Request('GET', Uri.parse('http://localhost/')), 'l1');

      expect(response.statusCode, 200);
      final body = jsonDecode(await response.readAsString()) as List<dynamic>;
      expect(body.length, 1);
      expect(body.first['id'], 'i1');
      expect(body.first['listId'], 'l1');
    });

    test('registerEndpoints exposes by-list route', () async {
      final controller = TodoItemController(operations: TestTodoItemOperations(), logger: TestLogger());
      controller.registerEndpoints();

      final response = await controller.handler(Request('GET', Uri.parse('http://localhost/by-list/l1')));

      expect(response.statusCode, 200);
    });
  });
}
