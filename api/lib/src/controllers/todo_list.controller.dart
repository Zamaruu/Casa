import 'package:casa_api/src/abstract/controller/crud.controller.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';

class TodoListController extends CrudController<ITodoList, ITodoListOperations> {
  TodoListController({
    required super.operations,
    required super.logger,
  });

  factory TodoListController.endpoint() {
    final logger = services.logger;
    final operations = services.database.get<ITodoListOperations>();

    final controller = TodoListController(
      operations: operations,
      logger: logger,
    );
    controller.registerEndpoints();

    return controller;
  }

  @override
  String get path => 'todos/lists';

  @override
  ITodoList Function(Map<String, dynamic> json) get entityFromJson => TodoList.fromJson;
}

