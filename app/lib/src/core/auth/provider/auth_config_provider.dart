import 'package:casa/src/core/auth/auth_request.dart';
import 'package:casa/src/core/auth/auth_result.dart';
import 'package:shared/shared.dart';

abstract class AuthConfigProvider implements IAuthProvider {
  Future<AuthResult> authenticate(AuthRequest request);
}
