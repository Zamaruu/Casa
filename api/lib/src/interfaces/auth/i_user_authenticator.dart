import 'package:shared/shared.dart';

abstract interface class IUserAuthenticator {
  /// Generates a JWT token [String] for the given user with the given claims.
  String generate(IUser user);

  /// Verifies the given JWT token and returns the user claims as [IUser].
  Future<IUser?> authenticate(String jwt);
}
