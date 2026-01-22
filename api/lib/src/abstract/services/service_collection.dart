import 'package:shared/shared.dart';

abstract class ServiceCollection<K, V> implements IServiceCollection<K, V> {
  final Map<K, V> collection;

  const ServiceCollection({this.collection = const {}});

  void addAll(Map<K, V> map) {
    collection.addAll(map);
  }

  @override
  V get<T>() {
    return collection.values.firstWhere((element) => element is T);
  }

  @override
  V getByKey(K key) {
    return collection[key]!;
  }
}
