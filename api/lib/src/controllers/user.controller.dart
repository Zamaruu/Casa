import 'package:api/src/abstract/controller/crud.controller.dart';
import 'package:api/src/services/service_locator.dart';
import 'package:shared/shared.dart';

class UserController extends CrudController<IUser, IUserOperations> {
  UserController({required super.operations});

  factory UserController.endpoint() {
    final operations = services.database.get<IUserOperations>();
    return UserController(operations: operations);
  }

  @override
  String get path => "/user";

  @override
  IUser Function(Map<String, dynamic> json) get entityFromJson => User.fromJson;

  @override
  Future<void> registerEndpoints() async {
    await super.registerEndpoints();
  }
}
