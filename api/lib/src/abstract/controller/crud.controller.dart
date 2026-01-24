import 'dart:convert';

import 'package:api/src/abstract/controller/api.controller.dart';
import 'package:api/src/models/responses/api.response.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

abstract class CrudController<E extends IEntity, O extends IDefaultEntityOperations<E>> extends ApiController {
  final O operations;

  CrudController({required this.operations});

  E Function(Map<String, dynamic> json) get entityFromJson;

  @override
  void registerEndpoints() {
    router.get('/', getAll);
    router.get('/<id>', getById);
    router.post('/', create);
    // router.put('/$path/<id>', update);
    router.delete('/<id>', delete);
  }

  // region CRUD-Endpoints

  Future<ApiResponse> getAll(Request request) async {
    return runGuarded(() async {
      final response = await operations.findAll();
      if (response.isError) {
        return ApiResponse.internalServerError(response.message ?? "Error while getting all entities");
      }
      final entities = response.value!;
      final json = jsonEncode(entities.map((e) => e.toJson()).toList());
      return ApiResponse.ok(json);
    });
  }

  Future<ApiResponse> getById(Request request, String id) async {
    return runGuarded(() async {
      final response = await operations.find(id);

      if (response.isError) {
        return ApiResponse.internalServerError(response.message ?? "Entity with id $id not found");
      } else {
        if (response.hasValue) {
          final entity = response.value!;
          final json = jsonEncode(entity.toJson());
          return ApiResponse.ok(json);
        } else {
          return ApiResponse.notFound("Entity with id $id not found");
        }
      }
    });
  }

  Future<ApiResponse> create(Request request) async {
    return runGuarded(() async {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final entity = entityFromJson(data);
      final saveResponse = await operations.save(entity);

      if (saveResponse.isError) {
        return ApiResponse.internalServerError(saveResponse.message ?? "Error while saving entity");
      }

      final json = jsonEncode(saveResponse.value!.toJson());
      return ApiResponse.created(json);
    });
  }

  Future<ApiResponse> delete(Request request, String id) async {
    return runGuarded(() async {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final entity = entityFromJson(data);

      final response = await operations.delete(entity);

      if (response.isError) {
        return ApiResponse.internalServerError(response.message ?? "Error while deleting entity");
      } else {
        return ApiResponse.ok("Entity with id $id deleted");
      }
    });
  }

  // endregion
}
