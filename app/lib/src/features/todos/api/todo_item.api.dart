import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_item.api.dart';
import 'package:shared/shared.dart';

class TodoItemApi extends TypedApiManager<ITodoItem> implements ITodoItemApi {
  TodoItemApi(super.client);

  @override
  String get controller => '/todos/items';

  @override
  ITodoItem fromJson(Map<String, dynamic> json) {
    return TodoItem.fromJson(json);
  }

  @override
  Future<IValueResponse<List<ITodoItem>>> findByListId(String listId) async {
    final response = await runRequestGuarded<List<ITodoItem>>(() async {
      final httpResponse = await http.get('$controller/by-list/$listId');
      final statusCode = EHttpStatus.fromCode(httpResponse.statusCode);
      final data = httpResponse.data;

      final items = <ITodoItem>[];
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
