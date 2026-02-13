import 'package:shared/shared.dart';

/// Generic CRUD-like operations contract for entity persistence.
abstract interface class IDefaultEntityOperations<T extends IEntity> {
  /// Saves an entity to the repository.
  ///
  /// Parameter `entity`:
  /// Entity instance of type `T` to persist.
  ///
  /// Returns `Future<IValueResponse<T>>`, typically including the stored
  /// entity with generated metadata (for example `id` timestamps).
  Future<IValueResponse<T>> save(T entity);

  /// Saves a list of entities to the repository.
  ///
  /// Parameter `entities`:
  /// List of entities of type `T` to persist.
  ///
  /// Returns `Future<IValueResponse<List<T>>>` with the stored entities.
  Future<IValueResponse<List<T>>> saveMany(List<T> entities);

  /// Deletes an entity from the repository.
  ///
  /// Parameter `entity`:
  /// Entity instance to delete, usually identified by `entity.id`.
  ///
  /// Returns `Future<IResponse>` indicating success or failure.
  Future<IResponse> delete(T entity);

  /// Finds an entity by its ID in the repository.
  ///
  /// Parameter `id`:
  /// Entity identifier used to look up a record.
  ///
  /// Returns `Future<IValueResponse<T>>` with the found entity when present.
  Future<IValueResponse<T>> find(String id);

  /// Finds all entities in the repository.
  ///
  /// Returns `Future<IValueResponse<List<T>>>` containing all records.
  Future<IValueResponse<List<T>>> findAll();

  /// Finds multiple entities by their IDs in the repository.
  ///
  /// Parameter `ids`:
  /// List of entity identifiers to fetch.
  ///
  /// Returns `Future<IValueResponse<List<T>>>` with matched records.
  Future<IValueResponse<List<T>>> findMany(List<String> ids);
}
