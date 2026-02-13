import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_list.api.dart';
import 'package:shared/shared.dart';

class TodoListApi extends TypedApiManager<ITodoList> implements ITodoListApi {
  TodoListApi(super.client);

  @override
  String get controller => '/todos/lists';

  @override
  ITodoList fromJson(Map<String, dynamic> json) {
    return TodoList.fromJson(json);
  }
}
