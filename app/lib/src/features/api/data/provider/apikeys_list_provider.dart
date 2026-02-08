import 'package:casa/src/features/api/data/repositories/api.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final apiKeysListProvider = AsyncNotifierProvider.autoDispose<ApiKeysListNotifier, IValueResponse<List<IApiKey>>>(
  () => ApiKeysListNotifier(),
);

class ApiKeysListNotifier extends AutoDisposeAsyncNotifier<IValueResponse<List<IApiKey>>> {
  @override
  Future<IValueResponse<List<IApiKey>>> build() async {
    final response = await ref.read(apiKeyRepositoryProvider).findAll();
    return response;
  }
}
