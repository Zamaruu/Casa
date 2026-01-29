import 'package:casa/src/core/interfaces/i_api.dart';
import 'package:casa/src/core/interfaces/i_api_response.dart';

abstract interface class IAuthApi implements IApi {
  Future<IApiResponse<String>> loginByEmail({required String email, required String password});
}
