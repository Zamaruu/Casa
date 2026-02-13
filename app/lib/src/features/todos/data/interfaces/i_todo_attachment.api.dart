import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:shared/shared.dart';

abstract interface class ITodoAttachmentApi implements ITypedApi<ITodoAttachment> {
  Future<IValueResponse<List<ITodoAttachment>>> findByTodoItemId(String todoItemId);
}
