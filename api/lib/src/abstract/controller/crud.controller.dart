import 'dart:convert';
import 'dart:math';

import 'package:api/src/abstract/controller/api.controller.dart';
import 'package:api/src/models/responses/http.response.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class CrudController<E extends IEntity, O extends IDefaultEntityOperations<E>> extends ApiController {
  final O operations;

  CrudController({required this.operations});

  E Function(Map<String, dynamic> json) get entityFromJson;

  @override
  Future<void> registerEndpoints() async {
    router.get('/', getAll);
    router.get('/<id>', getById);
    router.post('/', create);
    // router.put('/<id>', update);
    router.delete('/<id>', delete);
  }

  // region CRUD-Endpoints

  Future<HttpResponse> getAll(http.Request request) async {
    return runGuarded(() async {
      final response = await operations.findAll();
      if (response.isError) {
        return HttpResponse.internalServerError(response.message ?? "Error while getting all entities");
      }
      final entities = response.value!;
      final json = jsonEncode(entities.map((e) => e.toJson()).toList());
      return HttpResponse.ok(json);
    });
  }

  Future<HttpResponse> getById(http.Request request, String id) async {
    return runGuarded(() async {
      final response = await operations.find(id);

      if (response.isError) {
        return HttpResponse.internalServerError(response.message ?? "Entity with id $id not found");
      } else {
        if (response.hasValue) {
          final entity = response.value!;
          final json = jsonEncode(entity.toJson());
          return HttpResponse.ok(json);
        } else {
          return HttpResponse.notFound("Entity with id $id not found");
        }
      }
    });
  }

  Future<HttpResponse> create(http.Request request) async {
    return runGuarded(() async {
      final body = request.body;
      final data = jsonDecode(body);

      final entity = entityFromJson(data);
      final saveResponse = await operations.save(entity);

      if (saveResponse.isError) {
        return HttpResponse.internalServerError(saveResponse.message ?? "Error while saving entity");
      }

      final json = jsonEncode(saveResponse.value!.toJson());
      return HttpResponse.created(json);
    });
  }

  Future<http.Response> delete(http.Request request, String id) async {
    return runGuarded(() async {
      final body = request.body;
      final data = jsonDecode(body);

      final entity = entityFromJson(data);

      final response = await operations.delete(entity);

      if (response.isError) {
        return HttpResponse.internalServerError(response.message ?? "Error while deleting entity");
      } else {
        return HttpResponse.ok("Entity with id $id deleted");
      }
    });
  }

  // endregion
}
