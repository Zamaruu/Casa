import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/features/api/data/interfaces/i_apikey.api.dart';
import 'package:casa/src/features/api/data/models/create_apikey_wrapper.dart';
import 'package:casa/src/features/api/data/repositories/api.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final apiKeyRepositoryProvider = Provider<ApiKeyRepo>((ref) {
  final user = ref.read(authUserProvider);

  final userApi = services.api.get<IApiKeyApi>();

  final source = ApiKeyRepoSource(
    ref: ref,
    user: user,
    api: userApi,
  );

  return ApiKeyRepository(source: source);
});

class ApiKeyRepository extends ApiKeyRepo {
  ApiKeyRepository({required super.source});

  @override
  Future<IValueResponse<CreateApiKeyWrapper>> createApiKey(IApiKey entity) async {
    return runGuardedValue(() async {
      final response = await source.api.createApiKey(entity);

      return response;
    });
  }
}
