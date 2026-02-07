import 'dart:convert';

import 'package:casa_api/src/abstract/controller/crud.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

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

  // region Helper

  IUser createOperations(IUser entity) {
    if (entity is User && entity.password != null) {
      final hasher = PasswordHasher();
      final hashedPassword = hasher.hash(entity.password!);
      entity = entity.copyWith(passwordHash: hashedPassword);

      return (entity as User).withoutPassword();
    } else {
      return entity;
    }
  }

  // endregion

  // region Overrides

  @override
  Future<ApiResponse> save(Request request) async {
    return runGuarded(() async {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      var entity = entityFromJson(data);

      entity = createOperations(entity);

      final saveResponse = await operations.save(entity);

      if (saveResponse.isError) {
        return ApiResponse.internalServerError(saveResponse.message ?? "Error while saving entity");
      }

      final json = jsonEncode(saveResponse.value!.toJson());
      return ApiResponse.created(json);
    });
  }

  @override
  Future<ApiResponse> saveMany(Request request) async {
    return runGuarded(() async {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final entities = (data as List).map((e) => entityFromJson(e)).toList();
      final saveEntities = <IUser>[];

      for (var entity in entities) {
        final saveEntity = createOperations(entity);
        saveEntities.add(saveEntity);
      }

      final saveResponse = await operations.saveMany(entities);

      if (saveResponse.isError) {
        return ApiResponse.internalServerError(saveResponse.message ?? "Error while saving entities");
      } else {
        final items = saveResponse.value!.map((e) => e.toJson()).toList();
        final json = jsonEncode(items);
        return ApiResponse.created(json);
      }
    });
  }

  // endregion
}
