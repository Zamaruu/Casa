import 'package:shared/shared.dart';

/// Authentication service contract for password verification and login.
abstract interface class IAuthService {
  /// Verifies a plain text password against a persisted hash.
  ///
  /// Parameter `password`:
  /// Raw password input from the login request.
  ///
  /// Parameter `hash`:
  /// Stored password hash to verify against.
  ///
  /// Returns `bool`.
  bool verifyPassword(String password, String hash);

  /// Authenticates a user and returns an authentication token/value.
  ///
  /// Parameter `email`:
  /// User email identity used for lookup.
  ///
  /// Parameter `password`:
  /// Raw password input for verification.
  ///
  /// Returns `Future<IValueResponse<String>>`, where `value` is typically
  /// a token string on success.
  Future<IValueResponse<String>> authenticate(String email, String password);
}
