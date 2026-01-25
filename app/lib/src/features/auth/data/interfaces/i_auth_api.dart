import 'package:casa/src/core/interfaces/i_api.dart';

abstract interface class IAuthApi implements IApi {
  Future<String?> loginByEmail({required String email, required String passwordHash});
}
