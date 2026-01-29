import 'package:casa/src/core/auth/auth_request.dart';
import 'package:casa/src/core/auth/auth_result.dart';
import 'package:casa/src/core/auth/provider/auth_config_provider.dart';
import 'package:casa/src/core/extensions/string.extensions.dart';
import 'package:shared/shared.dart';

class LocalAuthProvider extends AuthConfigProvider {
  @override
  bool get enabled => true;

  @override
  String get name => EAuthProvider.jwt.name.asCapitalized;

  @override
  Future<AuthResult> authenticate(AuthRequest request) async {
    // 1. User via Email laden
    // 2. Passwort prüfen (argon2/bcrypt)
    // 3. AuthResult zurückgeben
    return AuthResult(externalUserId: "", email: "");
  }
}
