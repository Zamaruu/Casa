import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_list.api.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class TodoListApi extends TypedApiManager<ITodoList> implements ITodoListApi {
  TodoListApi(super.client);

  @override
  String get controller => '/todos/lists';

  @override
  ITodoList fromJson(Map<String, dynamic> json) {
    return TodoList.fromJson(json);
  }

  @override
  Future<IApiResponse<void>> deleteList(String id, {String? todoAction}) {
    return runRequestGuarded(() async {
      final query = <String, dynamic>{};
      if (todoAction != null && todoAction.isNotEmpty) {
        query['todoAction'] = todoAction;
      }

      final response = await http.delete(
        '$controller/$id',
        queryParameters: query,
        options: Options(validateStatus: (_) => true),
      );

      final statusCode = EHttpStatus.fromCode(response.statusCode);
      final body = response.data;
      final rawBody = body is Map<String, dynamic>
          ? body
          : const <String, dynamic>{};
      final message = rawBody['message']?.toString();

      if (statusCode.isSuccessful) {
        return ApiResponse<void>.success(
          httpStatus: statusCode,
          rawBody: rawBody,
        );
      }

      return ApiResponse<void>.failure(
        httpStatus: statusCode,
        message: message,
        rawBody: rawBody,
      );
    });
  }
}
