import 'package:shared/src/interfaces/i_user.dart';

abstract class AuthService {
  IUser fromClaims(Map<String, dynamic> claims);

  bool hasAccess(IUser user);
}
