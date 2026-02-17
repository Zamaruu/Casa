import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:shared/shared.dart';

abstract interface class ITodoItemApi implements ITypedApi<ITodo> {
  Future<IValueResponse<List<ITodo>>> findByListId(String listId);
}
