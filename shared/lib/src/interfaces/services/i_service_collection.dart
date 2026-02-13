/// Generic service container contract with keyed and typed lookups.
abstract interface class IServiceCollection<K, V> {
  /// Initializes and registers services in the collection.
  ///
  /// Returns `Future<void>`.
  Future<void> initalize();

  /// Resolves a service by type.
  ///
  /// Returns `T`, where `T` extends base service type `V`.
  T get<T extends V>();

  /// Resolves a service by an explicit key.
  ///
  /// Parameter `key`:
  /// Key value of type `K` used to identify a registered service.
  ///
  /// Returns `V`.
  V getByKey(K key);
}
