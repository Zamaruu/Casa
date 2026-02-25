import 'package:casa_api/src/abstract/controller/crud.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class TodoListController
    extends CrudController<ITodoList, ITodoListOperations> {
  final ITodoItemOperations todoItemOperations;

  TodoListController({
    required super.operations,
    required super.logger,
    required this.todoItemOperations,
  });

  factory TodoListController.endpoint() {
    final logger = services.logger;
    final operations = services.database.get<ITodoListOperations>();
    final todoItemOperations = services.database.get<ITodoItemOperations>();

    final controller = TodoListController(
      operations: operations,
      logger: logger,
      todoItemOperations: todoItemOperations,
    );
    controller.registerEndpoints();

    return controller;
  }

  @override
  String get path => 'todos/lists';

  @override
  ITodoList Function(Map<String, dynamic> json) get entityFromJson =>
      TodoList.fromJson;

  @override
  Future<ApiResponse> delete(Request request, String id) async {
    return runCustomGuarded(() async {
      final entityResponse = await operations.find(id);

      if (entityResponse.isError || entityResponse.hasValue == false) {
        final result = encodeResult(message: "Entity with id $id not found");
        return ApiResponse.notFound(result);
      }

      final list = entityResponse.value!;
      final itemsResponse = await todoItemOperations.findByListId(id);
      if (itemsResponse.isError) {
        final result = encodeError(
          message:
              itemsResponse.message ??
              "Error while checking todo items for list $id",
          error: itemsResponse.error,
          stackTrace: itemsResponse.stackTrace,
        );
        return ApiResponse.internalServerError(result);
      }

      final items = itemsResponse.value ?? const <ITodo>[];
      final todoAction = request.requestedUri.queryParameters['todoAction'];

      if (items.isNotEmpty &&
          todoAction != 'delete' &&
          todoAction != 'detach') {
        final result = encodeResult(
          message:
              'Todo list contains ${items.length} todos. '
              'Choose what to do with them via query parameter "todoAction=delete|detach".',
        );
        return ApiResponse.badRequest(result);
      }

      if (todoAction == 'delete') {
        final deleteItemsResponse = await todoItemOperations.deleteByListId(id);
        if (deleteItemsResponse.isError) {
          final result = encodeError(
            message:
                deleteItemsResponse.message ??
                'Error while deleting todos for list $id',
            error: deleteItemsResponse.error,
            stackTrace: deleteItemsResponse.stackTrace,
          );
          return ApiResponse.internalServerError(result);
        }
      } else if (todoAction == 'detach') {
        final detachItemsResponse = await todoItemOperations.detachFromListId(
          id,
        );
        if (detachItemsResponse.isError) {
          final result = encodeError(
            message:
                detachItemsResponse.message ??
                'Error while detaching todos for list $id',
            error: detachItemsResponse.error,
            stackTrace: detachItemsResponse.stackTrace,
          );
          return ApiResponse.internalServerError(result);
        }
      }

      final deleteResponse = await operations.delete(list);
      if (deleteResponse.isError) {
        final result = encodeError(
          message: deleteResponse.message ?? "Error while deleting entity",
          error: deleteResponse.error,
          stackTrace: deleteResponse.stackTrace,
        );
        return ApiResponse.internalServerError(result);
      }

      final result = encodeResult(
        message:
            'Todo list $id deleted'
            '${items.isNotEmpty ? ' (${items.length} todos: $todoAction)' : ''}',
      );
      return ApiResponse.ok(result);
    }, onError: onGuardedError);
  }
}
