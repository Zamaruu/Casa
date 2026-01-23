import 'package:shared/shared.dart';

abstract class ServiceCollection<K, V> implements IServiceCollection<K, V> {
  final Map<K, V> collection;

  ServiceCollection() : collection = <K, V>{};

  void addAll(Map<K, V> map) {
    collection.addAll(map);
  }

  @override
  T get<T extends V>() {
    return collection.values.firstWhere((element) => element is T) as T;
  }

  @override
  V getByKey(K key) {
    return collection[key]!;
  }
}
