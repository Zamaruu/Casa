import 'package:shared/shared.dart';

abstract interface class IUserRepository implements IDefaultEntityOperations<IUser> {
  /// Find user by email (optional, provider dependent)
  Future<IValueResponse<IUser?>> findByEmail(String email);
}
