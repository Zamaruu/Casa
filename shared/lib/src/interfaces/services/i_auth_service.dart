import 'package:shared/shared.dart';

abstract interface class IAuthService {
  bool verifyPassword(String password, String hash);

  Future<IValueResponse<String>> authenticate(String email, String password);
}
