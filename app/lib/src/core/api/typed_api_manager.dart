import 'package:casa/src/core/api/api_manager.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:shared/shared.dart';

abstract class TypedApiManager<T extends IEntity> extends ApiManager implements ITypedApi<T> {
  TypedApiManager(super.client);

  /// API-Controller endpoint, e.g. '/users'
  String get controller;

  // region Type-Endpoints

  @override
  Future<IApiResponse> delete(T entity) async {
    return runRequestGuarded(() async {
      final response = await http.delete('$controller/${entity.id}');
      final statusCode = EHttpStatus.fromCode(response.statusCode);

      if (statusCode.isSuccessful) {
        return ApiResponse.success(httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }

  @override
  Future<IApiResponse<T>> find(String id) async {
    return runRequestGuarded(() async {
      final response = await http.get('$controller/$id');

      final statusCode = EHttpStatus.fromCode(response.statusCode);
      final data = response.data;
      final entity = fromJson(data);

      if (statusCode.isSuccessful) {
        return ApiResponse.success(value: entity, httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }

  @override
  Future<IApiResponse<List<T>>> findAll() async {
    return runRequestGuarded(() async {
      final response = await http.get(controller);

      final statusCode = EHttpStatus.fromCode(response.statusCode);
      final data = response.data;
      final entities = <T>[];

      for (final item in data) {
        entities.add(fromJson(item));
      }

      if (statusCode.isSuccessful) {
        return ApiResponse.success(value: entities, httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }

  @override
  Future<IApiResponse<List<T>>> findMany(List<String> ids) async {
    return runRequestGuarded(() async {
      final response = await http.post('$controller/many', data: ids);
      final statusCode = EHttpStatus.fromCode(response.statusCode);
      final data = response.data;
      final entities = <T>[];

      for (final item in data) {
        entities.add(fromJson(item));
      }

      if (statusCode.isSuccessful) {
        return ApiResponse.success(value: entities, httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }

  @override
  Future<IApiResponse<T>> save(T entity) async {
    return runRequestGuarded(() async {
      final response = await http.post(
        controller,
        data: entity.toJson(),
      );
      final statusCode = EHttpStatus.fromCode(response.statusCode);

      final data = response.data;
      final savedEntity = fromJson(data);

      if (statusCode.isSuccessful) {
        return ApiResponse.success(value: savedEntity, httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }

  @override
  Future<IApiResponse<List<T>>> saveMany(List<T> entities) async {
    return runRequestGuarded(() async {
      final response = await http.post(
        '$controller/many',
        data: entities.map((e) => e.toJson()).toList(),
      );

      final statusCode = EHttpStatus.fromCode(response.statusCode);
      final data = response.data;

      final savedEntities = <T>[];

      for (final item in data) {
        savedEntities.add(fromJson(item));
      }

      if (statusCode.isSuccessful) {
        return ApiResponse.success(value: savedEntities, httpStatus: statusCode);
      } else {
        return ApiResponse.failure(httpStatus: statusCode);
      }
    });
  }

  // endregion
}
