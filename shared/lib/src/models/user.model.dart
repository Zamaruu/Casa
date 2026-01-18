import 'package:shared/src/interfaces/i_user.dart';

class User implements IUser {
  @override
  final String id;

  @override
  final String email;

  @override
  final String username;

  @override
  final List<String> groups;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.groups,
  });

  factory User.initial() {
    return const User(
      id: '',
      email: '',
      username: '',
      groups: [],
    );
  }

  @override
  // TODO: implement createdAt
  DateTime? get createdAt => throw UnimplementedError();

  @override
  // TODO: implement updatedAt
  DateTime? get updatedAt => throw UnimplementedError();

  @override
  User copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
