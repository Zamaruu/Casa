import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:shared/shared.dart';

abstract interface class ITodoListApi implements ITypedApi<ITodoList> {
  Future<IApiResponse<void>> deleteList(String id, {String? todoAction});
}
