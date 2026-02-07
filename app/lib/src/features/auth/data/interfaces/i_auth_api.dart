import 'package:casa/src/core/interfaces/api/i_api.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';

abstract interface class IAuthApi implements IApi {
  Future<IApiResponse<String>> loginByEmail({required String email, required String password});
}
