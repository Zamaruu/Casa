abstract interface class IServiceCollection<K, V> {
  Future<void> initalize();

  T get<T extends V>();

  V getByKey(K key);
}
