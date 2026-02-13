import 'package:shared/shared.dart';

/// Repository operations contract for todo attachment entities.
abstract interface class ITodoAttachmentOperations implements IDefaultEntityOperations<ITodoAttachment> {
  /// Finds all attachments linked to the todo item identified by `todoItemId`.
  ///
  /// Parameter `todoItemId`:
  /// Parent todo item identifier.
  ///
  /// Returns `Future<IValueResponse<List<ITodoAttachment>>>`.
  Future<IValueResponse<List<ITodoAttachment>>> findByTodoItemId(String todoItemId);
}
