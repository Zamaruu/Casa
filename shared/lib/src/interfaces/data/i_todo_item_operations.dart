import 'package:shared/shared.dart';

/// Repository operations contract for todo item entities.
abstract interface class ITodoItemOperations implements IDefaultEntityOperations<ITodoItem> {
  /// Finds all todo items that belong to the list identified by `listId`.
  ///
  /// Parameter `listId`:
  /// Parent todo list identifier.
  ///
  /// Returns `Future<IValueResponse<List<ITodoItem>>>`.
  Future<IValueResponse<List<ITodoItem>>> findByListId(String listId);
}
