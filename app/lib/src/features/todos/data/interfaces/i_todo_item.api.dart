import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:shared/shared.dart';

abstract interface class ITodoItemApi implements ITypedApi<ITodoItem> {
  Future<IValueResponse<List<ITodoItem>>> findByListId(String listId);
}
