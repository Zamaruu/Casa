import 'package:casa_api/src/abstract/repositories/base.repo.dart';
import 'package:casa_api/src/abstract/repositories/typed_source.dart';
import 'package:shared/shared.dart';

abstract class TypedApiRepo<T extends IEntity> extends BaseApiRepo<TypedRepoSource<T>> implements ITypedRepository<T> {
  const TypedApiRepo({required super.source});

  @override
  Future<IResponse> delete(T entity) async {
    return await source.operations.delete(entity);
  }

  @override
  Future<IValueResponse<T>> find(String id) async {
    return await source.operations.find(id);
  }

  @override
  Future<IValueResponse<List<T>>> findAll() async {
    return await source.operations.findAll();
  }

  @override
  Future<IValueResponse<List<T>>> findMany(List<String> ids) async {
    return await source.operations.findMany(ids);
  }

  @override
  Future<IValueResponse<T>> save(T entity) async {
    return await source.operations.save(entity);
  }

  @override
  Future<IValueResponse<List<T>>> saveMany(List<T> entities) async {
    return await source.operations.saveMany(entities);
  }
}
