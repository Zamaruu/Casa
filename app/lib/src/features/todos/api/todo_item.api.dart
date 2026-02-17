import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_item.api.dart';
import 'package:shared/shared.dart';

class TodoItemApi extends TypedApiManager<ITodo> implements ITodoItemApi {
  TodoItemApi(super.client);

  @override
  String get controller => '/todos/items';

  @override
  ITodo fromJson(Map<String, dynamic> json) {
    return Todo.fromJson(json);
  }

  @override
  Future<IValueResponse<List<ITodo>>> findByListId(String listId) async {
    final response = await runRequestGuarded<List<ITodo>>(() async {
      final httpResponse = await http.get('$controller/by-list/$listId');
      final statusCode = EHttpStatus.fromCode(httpResponse.statusCode);
      final data = httpResponse.data;

      final items = <ITodo>[];
      for (final item in data) {
        items.add(fromJson(item));
      }

      if (statusCode.isSuccessful) {
        return ApiResponse.success(value: items, httpStatus: statusCode);
      }

      return ApiResponse.failure(httpStatus: statusCode);
    });

    return response;
  }
}
