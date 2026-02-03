import 'package:casa/src/app/abstract/repositories/base_repo.dart';
import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:shared/shared.dart';

abstract class TypedRepo<T extends IEntity> extends BaseRepo<TypedRepoSource<T>> implements ITypedRepository<T> {
  const TypedRepo({required super.source});

  @override
  Future<IValueResponse<T>> save(T entity) => source.api.save(entity);

  @override
  Future<IValueResponse<List<T>>> saveMany(List<T> entities) => source.api.saveMany(entities);

  @override
  Future<IResponse> delete(T entity) => source.api.delete(entity);

  @override
  Future<IValueResponse<T>> find(String id) => source.api.find(id);

  @override
  Future<IValueResponse<List<T>>> findAll() => source.api.findAll();

  @override
  Future<IValueResponse<List<T>>> findMany(List<String> ids) => source.api.findMany(ids);
}
