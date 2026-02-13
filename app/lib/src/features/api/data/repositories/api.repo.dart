import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/app/abstract/repositories/typed_cache_repo.dart';
import 'package:casa/src/features/api/data/interfaces/i_apikey.api.dart';
import 'package:casa/src/features/api/data/models/create_apikey_wrapper.dart';
import 'package:shared/shared.dart';

class ApiKeyRepoSource extends TypedRepoSource<IApiKey, IApiKeyApi> {
  const ApiKeyRepoSource({
    required super.ref,
    required super.user,
    required super.api,
  });
}

abstract class ApiKeyRepo extends TypedCacheRepo<IApiKey, IApiKeyApi> {
  ApiKeyRepo({required super.source});

  Future<IValueResponse<CreateApiKeyWrapper>> createApiKey(IApiKey entity);
}
