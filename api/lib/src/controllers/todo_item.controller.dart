import 'dart:convert';

import 'package:casa_api/src/abstract/controller/crud.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class TodoItemController extends CrudController<ITodo, ITodoItemOperations> {
  TodoItemController({
    required super.operations,
    required super.logger,
  });

  factory TodoItemController.endpoint() {
    final logger = services.logger;
    final operations = services.database.get<ITodoItemOperations>();

    final controller = TodoItemController(
      operations: operations,
      logger: logger,
    );
    controller.registerEndpoints();

    return controller;
  }

  @override
  String get path => 'todos/items';

  @override
  ITodo Function(Map<String, dynamic> json) get entityFromJson => Todo.fromJson;

  @override
  void registerEndpoints() {
    super.registerEndpoints();
    router.get('/by-list/<listId>', getByListId);
  }

  Future<ApiResponse> getByListId(Request request, String listId) async {
    return runCustomGuarded(() async {
      final response = await operations.findByListId(listId);

      if (response.isError) {
        return ApiResponse.internalServerError(response.message ?? 'Error while finding todo items by list');
      }

      final items = response.value ?? <ITodo>[];
      final json = jsonEncode(items.map((e) => e.toJson()).toList());
      return ApiResponse.ok(json);
    }, onError: onGuardedError);
  }
}
