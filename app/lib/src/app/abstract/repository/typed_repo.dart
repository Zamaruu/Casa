import 'package:casa/src/app/abstract/repository/base_repo.dart';
import 'package:shared/shared.dart';

abstract class TypedRepo<T extends IEntity> extends BaseRepo {
  const TypedRepo({required super.source});

  Future<IValueResponse<T>> save(T entity);

  Future<IValueResponse<List<T>>> saveMany(List<T> entities);

  Future<IResponse> delete(T entity);

  Future<IValueResponse<T>> find(String id);

  Future<IValueResponse<List<T>>> findAll();

  Future<IValueResponse<List<T>>> findMany(List<String> ids);
}
