import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/abstract/entity.dart';
import 'package:shared/src/interfaces/i_user.dart';

part 'user.model.g.dart';

@JsonSerializable()
class User extends Entity implements IUser {
  @override
  final String email;

  @override
  final String username;

  @override
  final String passwordHash;

  @override
  final List<String> groups;

  const User({
    required super.id,
    super.createdAt,
    super.updatedAt,
    this.passwordHash = '',
    required this.email,
    required this.username,
    this.groups = const [],
  });

  factory User.initial() {
    return const User(
      id: '',
      email: '',
      username: '',
      passwordHash: '',
    );
  }

  bool get isInitial => id == '';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  IUser copyWith({
    String? id,
    String? email,
    String? username,
    String? passwordHash,
    List<String>? groups,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      groups: groups ?? this.groups,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool get isAdmin => groups.contains('admin');
}
