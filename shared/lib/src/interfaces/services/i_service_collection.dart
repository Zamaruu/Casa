abstract interface class IServiceCollection<K, V> {
  Future<void> initalize();

  V get<T>();

  V getByKey(K key);
}
