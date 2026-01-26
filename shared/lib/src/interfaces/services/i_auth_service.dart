import 'package:shared/shared.dart';

abstract interface class IAuthService {
  IUser fromClaims(Map<String, dynamic> claims);

  String hashPassword(String password);

  bool verifyPassword(String password, String hash);

  Future<IValueResponse<String>> authenticate(String email, String password);
}
