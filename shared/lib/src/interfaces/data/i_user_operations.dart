import 'package:shared/shared.dart';

/// Repository operations contract for user entities.
abstract interface class IUserOperations implements IDefaultEntityOperations<IUser> {
  /// Finds a user by email address.
  ///
  /// Parameter `email`:
  /// Email address to query in the user source.
  ///
  /// Returns `Future<IValueResponse<IUser?>>`. The value can be `null` when
  /// the user is not found.
  Future<IValueResponse<IUser?>> findByEmail(String email);
}
