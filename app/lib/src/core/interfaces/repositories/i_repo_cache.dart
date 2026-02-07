import 'package:shared/shared.dart';

abstract interface class IRepoCache<T extends IEntity> {
  List<T> get cache;

  Map<String, T> get idCache;

  Duration get ttl;

  DateTime? get lastCacheChange;

  bool get hasValidCache;

  T? findInCache(String id);

  void addToCache(T entity, {bool replace = true});

  void setCache(List<T> entities);
}
