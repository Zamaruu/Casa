import 'package:shared/shared.dart';

abstract interface class ITypedRepository<T extends IEntity> implements IRepository {
  /// Saves an entity to the repository.
  ///
  /// Returns the saved entity with a new ID if successful.
  Future<IValueResponse<T>> save(T entity);

  /// Saves a list of entities to the repository.
  ///
  /// Returns a list of saved entities with new IDs if successful.
  Future<IValueResponse<List<T>>> saveMany(List<T> entities);

  /// Deletes an entity from the repository.
  ///
  /// Returns a response indicating the success or failure of the deletion.
  Future<IResponse> delete(T entity);

  /// Finds an entity by its ID in the repository.
  ///
  /// Returns the found entity if successful.
  Future<IValueResponse<T>> find(String id);

  /// Finds all entities in the repository.
  ///
  /// Returns a list of all entities if successful.
  Future<IValueResponse<List<T>>> findAll();

  /// Finds multiple entities by their IDs in the repository.
  ///
  /// Returns a list of found entities if successful.
  Future<IValueResponse<List<T>>> findMany(List<String> ids);
}
