import 'package:casa/src/core/interfaces/api/i_api.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:casa/src/core/interfaces/i_deserializer.dart';
import 'package:shared/shared.dart';

abstract interface class ITypedApi<T extends IEntity> implements IApi, IDeserializer<T>, IDefaultEntityOperations<T> {
  @override
  Future<IApiResponse<T>> save(T entity);

  @override
  Future<IApiResponse<List<T>>> saveMany(List<T> entities);

  @override
  Future<IResponse> delete(T entity);

  @override
  Future<IApiResponse<T>> find(String id);

  @override
  Future<IApiResponse<List<T>>> findAll();

  @override
  Future<IApiResponse<List<T>>> findMany(List<String> ids);
}
