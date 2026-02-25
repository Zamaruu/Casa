import 'dart:convert';

import 'package:casa_api/src/controllers/todo_list.controller.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart' show Request;
import 'package:test/test.dart';

import '../helpers/test_doubles.dart';

class _TodoListOps implements ITodoListOperations {
  IValueResponse<ITodoList> findResponse = const ValueResponse.success(
    value: TodoList(
      id: 'l1',
      name: 'List',
      ownerUserId: 'u1',
      memberUserIds: ['u1'],
      isShared: true,
    ),
  );
  IResponse deleteResponse = const Response.success();
  int deleteCalls = 0;

  @override
  Future<IResponse> delete(ITodoList entity) async {
    deleteCalls += 1;
    return deleteResponse;
  }

  @override
  Future<IValueResponse<ITodoList>> find(String id) async => findResponse;

  @override
  Future<IValueResponse<List<ITodoList>>> findAll() async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<ITodoList>>> findMany(List<String> ids) async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<ITodoList>> save(ITodoList entity) async =>
      ValueResponse.success(value: entity);

  @override
  Future<IValueResponse<List<ITodoList>>> saveMany(
    List<ITodoList> entities,
  ) async => ValueResponse.success(value: entities);
}

class _TodoItemOps implements ITodoItemOperations {
  IValueResponse<List<ITodo>> byListResponse = const ValueResponse.success(
    value: [],
  );
  int deleteCalls = 0;
  int saveCalls = 0;
  int deleteByListCalls = 0;
  int detachByListCalls = 0;
  String? lastDeleteByListId;
  String? lastDetachByListId;

  @override
  Future<IValueResponse<List<ITodo>>> findByListId(String listId) async =>
      byListResponse;

  @override
  Future<IResponse> deleteByListId(String listId) async {
    deleteByListCalls += 1;
    lastDeleteByListId = listId;
    return const Response.success();
  }

  @override
  Future<IResponse> detachFromListId(String listId) async {
    detachByListCalls += 1;
    lastDetachByListId = listId;
    return const Response.success();
  }

  @override
  Future<IResponse> delete(ITodo entity) async {
    deleteCalls += 1;
    return const Response.success();
  }

  @override
  Future<IValueResponse<ITodo>> find(String id) async =>
      ValueResponse.failure(message: 'not found');

  @override
  Future<IValueResponse<List<ITodo>>> findAll() async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<ITodo>>> findMany(List<String> ids) async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<ITodo>> save(ITodo entity) async {
    saveCalls += 1;
    return ValueResponse.success(value: entity);
  }

  @override
  Future<IValueResponse<List<ITodo>>> saveMany(List<ITodo> entities) async =>
      ValueResponse.success(value: entities);
}

void main() {
  test('TodoListController path and entityFromJson', () {
    final controller = TodoListController(
      operations: _TodoListOps(),
      logger: TestLogger(),
      todoItemOperations: _TodoItemOps(),
    );

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

  test('delete prompts for todo action if list still has todos', () async {
    final listOps = _TodoListOps();
    final itemOps = _TodoItemOps()
      ..byListResponse = ValueResponse.success(
        value: const [
          Todo(id: 't1', listId: 'l1', title: 'T1', createdByUserId: 'u1'),
        ],
      );

    final controller = TodoListController(
      operations: listOps,
      logger: TestLogger(),
      todoItemOperations: itemOps,
    );
    controller.registerEndpoints();

    final response = await controller.handler(
      Request('DELETE', Uri.parse('http://localhost/l1')),
    );

    expect(response.statusCode, 400);
    final body =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(
      (body['message'] as String).contains('todoAction=delete|detach'),
      isTrue,
    );
    expect(listOps.deleteCalls, 0);
  });

  test('delete with todoAction=delete removes todos then list', () async {
    final listOps = _TodoListOps();
    final itemOps = _TodoItemOps()
      ..byListResponse = ValueResponse.success(
        value: const [
          Todo(id: 't1', listId: 'l1', title: 'T1', createdByUserId: 'u1'),
          Todo(id: 't2', listId: 'l1', title: 'T2', createdByUserId: 'u1'),
        ],
      );

    final controller = TodoListController(
      operations: listOps,
      logger: TestLogger(),
      todoItemOperations: itemOps,
    );
    controller.registerEndpoints();

    final response = await controller.handler(
      Request('DELETE', Uri.parse('http://localhost/l1?todoAction=delete')),
    );

    expect(response.statusCode, 200);
    expect(itemOps.deleteByListCalls, 1);
    expect(itemOps.lastDeleteByListId, 'l1');
    expect(itemOps.deleteCalls, 0);
    expect(itemOps.saveCalls, 0);
    expect(itemOps.detachByListCalls, 0);
    expect(listOps.deleteCalls, 1);
  });

  test('delete with todoAction=detach clears listId and keeps todos', () async {
    final listOps = _TodoListOps();
    final itemOps = _TodoItemOps()
      ..byListResponse = ValueResponse.success(
        value: const [
          Todo(id: 't1', listId: 'l1', title: 'T1', createdByUserId: 'u1'),
        ],
      );

    final controller = TodoListController(
      operations: listOps,
      logger: TestLogger(),
      todoItemOperations: itemOps,
    );
    controller.registerEndpoints();

    final response = await controller.handler(
      Request('DELETE', Uri.parse('http://localhost/l1?todoAction=detach')),
    );

    expect(response.statusCode, 200);
    expect(itemOps.deleteCalls, 0);
    expect(itemOps.saveCalls, 0);
    expect(itemOps.detachByListCalls, 1);
    expect(itemOps.lastDetachByListId, 'l1');
    expect(listOps.deleteCalls, 1);
  });
}
