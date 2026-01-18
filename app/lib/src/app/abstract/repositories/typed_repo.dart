import 'package:casa/src/app/abstract/repositories/base_repo.dart';
import 'package:shared/shared.dart';

abstract class TypedRepo<T extends IEntity> extends BaseRepo implements ITypedRepository<T> {
  const TypedRepo({required super.source});

  @override
  Future<IValueResponse<T>> save(T entity);

  @override
  Future<IValueResponse<List<T>>> saveMany(List<T> entities);

  @override
  Future<IResponse> delete(T entity);

  @override
  Future<IValueResponse<T>> find(String id);

  @override
  Future<IValueResponse<List<T>>> findAll();

  @override
  Future<IValueResponse<List<T>>> findMany(List<String> ids);
}
