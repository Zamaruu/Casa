import 'package:shared/src/interfaces/i_entity.dart';
import 'package:shared/src/interfaces/i_user.dart';

class AuthUser implements IUser {
  @override
  final String id;

  @override
  final String email;

  @override
  final String username;

  @override
  final List<String> groups;

  const AuthUser({
    required this.id,
    required this.email,
    required this.username,
    required this.groups,
  });

  @override
  // TODO: implement createdAt
  DateTime? get createdAt => throw UnimplementedError();

  @override
  // TODO: implement updatedAt
  DateTime? get updatedAt => throw UnimplementedError();

  @override
  AuthUser copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
