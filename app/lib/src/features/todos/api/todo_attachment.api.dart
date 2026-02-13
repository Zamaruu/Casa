import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/features/todos/data/interfaces/i_todo_attachment.api.dart';
import 'package:shared/shared.dart';

class TodoAttachmentApi extends TypedApiManager<ITodoAttachment> implements ITodoAttachmentApi {
  TodoAttachmentApi(super.client);

  @override
  String get controller => '/todos/attachments';

  @override
  ITodoAttachment fromJson(Map<String, dynamic> json) {
    return TodoAttachment.fromJson(json);
  }

  @override
  Future<IValueResponse<List<ITodoAttachment>>> findByTodoItemId(String todoItemId) async {
    final response = await runRequestGuarded<List<ITodoAttachment>>(() async {
      final httpResponse = await http.get('$controller/by-item/$todoItemId');
      final statusCode = EHttpStatus.fromCode(httpResponse.statusCode);
      final data = httpResponse.data;

      final items = <ITodoAttachment>[];
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
