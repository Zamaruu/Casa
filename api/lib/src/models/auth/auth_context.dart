import 'package:casa_api/src/models/enums/e_auth_type.dart';

class AuthContext {
  final EAuthType type;
  final Object principal; // User | ApiKey

  const AuthContext.user(this.principal) : type = EAuthType.user;
  const AuthContext.apiKey(this.principal) : type = EAuthType.apiKey;
}
