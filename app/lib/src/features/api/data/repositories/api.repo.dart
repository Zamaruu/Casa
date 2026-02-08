import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_cache_repo.dart';
import 'package:shared/shared.dart';

class ApiKeyRepoSource extends TypedRepoSource<IApiKey> {
  const ApiKeyRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class ApiKeyRepo extends TypedCacheRepo<IApiKey> {
  ApiKeyRepo({required super.source});
}
