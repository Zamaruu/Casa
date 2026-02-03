import 'package:shared/src/interfaces/i_entity.dart';

abstract interface class IUser implements IEntity {
  String get email;

  String get username;

  String get passwordHash;

  List<String> get groups;

  @override
  IUser copyWith({
    String? id,
    String? email,
    String? username,
    List<String>? groups,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  bool get isAdmin;
}
