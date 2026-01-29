import 'package:bcrypt/bcrypt.dart';

class PasswordHasher {
  const PasswordHasher();

  String hash(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool verify(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }
}
