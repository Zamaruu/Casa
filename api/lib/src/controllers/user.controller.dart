import 'package:casa_api/src/abstract/controller/crud.controller.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';

class UserController extends CrudController<IUser, IUserOperations> {
  UserController({required super.operations});

  factory UserController.endpoint() {
    final operations = services.database.get<IUserOperations>();
    final controller = UserController(operations: operations);
    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "user";

  @override
  IUser Function(Map<String, dynamic> json) get entityFromJson => User.fromJson;
}
