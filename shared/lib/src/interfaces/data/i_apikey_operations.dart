import 'package:shared/shared.dart';

abstract interface class IApiKeyOperations implements IDefaultEntityOperations<IApiKey> {
  Future<IValueResponse<IApiKey>> findByHash(String hash);

  Future<IResponse> updateLastUsed(String id);
}
