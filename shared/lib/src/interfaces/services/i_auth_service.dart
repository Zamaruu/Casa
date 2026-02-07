import 'package:shared/shared.dart';
import 'package:shared/src/interfaces/models/i_user.dart';

abstract interface class IAuthService {
  IUser fromClaims(Map<String, dynamic> claims);

  String hashPassword(String password);

  bool verifyPassword(String password, String hash);

  Future<IValueResponse<String>> authenticate(String email, String password);
}
