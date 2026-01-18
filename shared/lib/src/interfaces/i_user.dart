import 'package:shared/src/interfaces/i_entity.dart';

abstract interface class IUser implements IEntity {
  String get email;

  String get username;

  List<String> get groups;
}
