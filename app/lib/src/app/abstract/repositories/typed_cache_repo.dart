import 'package:casa/src/app/abstract/repositories/typed_repo.dart';
import 'package:casa/src/core/extensions/list.extensions.dart';
import 'package:casa/src/core/interfaces/repositories/i_repo_cache.dart';
import 'package:shared/shared.dart';

abstract class TypedCacheRepo<T extends IEntity> extends TypedRepo<T> implements IRepoCache<T> {
  // ignore: prefer_final_fields
  late List<T> _cache;

  @override
  DateTime? lastCacheChange;

  TypedCacheRepo({
    required super.source,
  }) : _cache = [];

  // region Cache-Getter

  @override
  List<T> get cache => _cache;

  @override
  Duration get ttl => Duration(minutes: 5);

  @override
  bool get hasValidCache {
    final cacheEmpty = cache.isEmpty;
    final ttlExpired = lastCacheChange == null || DateTime.now().difference(lastCacheChange!) > ttl;

    if (cacheEmpty || ttlExpired) {
      return false;
    }

    return true;
  }

  @override
  Map<String, T> get idCache {
    final map = <String, T>{};

    for (final entity in cache) {
      map[entity.id] = entity;
    }

    return map;
  }

  // endregion

  // region Cache-Methods

  @override
  void addToCache(T entity, {bool replace = true}) {
    final isInCache = cache.contains(entity);

    if (!isInCache || replace) {
      cache.add(entity);
      lastCacheChange = DateTime.now();
    }
  }

  @override
  T? findInCache(String id) {
    return cache.firstWhereOrNull((entity) => entity.id == id);
  }

  @override
  void setCache(List<T> entities) {
    _cache = entities;
    lastCacheChange = DateTime.now();
  }

  void addAllToCache(List<T> entities) {
    final currentCache = cache;
    final newCache = [...currentCache, ...entities];
    setCache(newCache);
  }

  // endregion

  // region Overrides

  @override
  Future<IValueResponse<T>> find(String id) async {
    return runGuardedValue(() async {
      final fromCache = findInCache(id);

      if (fromCache != null) {
        return ValueResponse.success(value: fromCache);
      } else {
        final response = await super.find(id);

        if (response.isSuccess && response.hasValue) {
          final user = response.value!;
          addToCache(user);

          return ValueResponse.success(value: user);
        } else {
          return ValueResponse.failure(message: response.message);
        }
      }
    });
  }

  @override
  Future<IValueResponse<List<T>>> findAll() async {
    return runGuardedValue(() async {
      final fromCache = cache;

      if (fromCache.isNotEmpty) {
        return ValueResponse.success(value: fromCache);
      } else {
        final response = await super.findAll();

        if (response.isSuccess && response.hasValue) {
          final items = response.value!;
          setCache(items);

          return ValueResponse.success(value: items);
        } else {
          return ValueResponse.failure(message: response.message);
        }
      }
    });
  }

  @override
  Future<IValueResponse<T>> save(T entity) {
    return runGuardedValue(() async {
      final response = await super.save(entity);

      if (response.isSuccess) {
        final item = response.value!;
        addToCache(item);
        return ValueResponse.success(value: item);
      } else {
        return response;
      }
    });
  }

  @override
  Future<IValueResponse<List<T>>> saveMany(List<T> entities) {
    return runGuardedValue(() async {
      final response = await super.saveMany(entities);

      if (response.isSuccess) {
        final items = response.value!;
        setCache(items);
        return ValueResponse.success(value: items);
      } else {
        return response;
      }
    });
  }

  // endregion
}
