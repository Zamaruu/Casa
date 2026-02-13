import 'package:casa_api/src/controllers/todo_list.controller.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import '../helpers/test_doubles.dart';

class _TodoListOps implements ITodoListOperations {
  @override
  Future<IResponse> delete(ITodoList entity) async => const Response.success();

  @override
  Future<IValueResponse<ITodoList>> find(String id) async => ValueResponse.failure(message: 'not found');

  @override
  Future<IValueResponse<List<ITodoList>>> findAll() async => const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<ITodoList>>> findMany(List<String> ids) async => const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<ITodoList>> save(ITodoList entity) async => ValueResponse.success(value: entity);

  @override
  Future<IValueResponse<List<ITodoList>>> saveMany(List<ITodoList> entities) async => ValueResponse.success(value: entities);
}

void main() {
  test('TodoListController path and entityFromJson', () {
    final controller = TodoListController(operations: _TodoListOps(), logger: TestLogger());

    expect(controller.path, 'todos/lists');

    final entity = controller.entityFromJson({
      'id': 'l1',
      'name': 'List',
      'description': '',
      'ownerUserId': 'u1',
      'memberUserIds': ['u1'],
      'isShared': true,
    });

    expect(entity.id, 'l1');
    expect(entity.name, 'List');
  });
}
