import 'dart:convert';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

abstract class CrudController<E extends IEntity, O extends IDefaultEntityOperations<E>> extends ApiController {
  final O operations;

  CrudController({required this.operations});

  E Function(Map<String, dynamic> json) get entityFromJson;

  @override
  void registerEndpoints() {
    router.post('/', save);
    router.post('/many', saveMany);
    router.delete('/<id>', delete);
    router.get('/<id>', getById);
    router.get('/', getAll);
    router.get('/many/<ids>', getByIds);
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

  Future<ApiResponse> getByIds(Request request, List<String> ids) async {
    return runGuarded(() async {
      final response = await operations.findMany(ids);

      if (response.isError) {
        return ApiResponse.internalServerError(response.message ?? "Error while getting entities");
      } else {
        final entities = response.value!;
        final json = jsonEncode(entities.map((e) => e.toJson()).toList());
        return ApiResponse.ok(json);
      }
    });
  }

  Future<ApiResponse> save(Request request) async {
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

  Future<ApiResponse> saveMany(Request request) async {
    return runGuarded(() async {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final entities = (data as List).map((e) => entityFromJson(e)).toList();

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
