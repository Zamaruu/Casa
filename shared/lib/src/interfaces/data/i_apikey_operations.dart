import 'package:shared/shared.dart';

/// Repository operations contract for API key entities.
abstract interface class IApiKeyOperations implements IDefaultEntityOperations<IApiKey> {
  /// Finds an API key by its persisted hash value.
  ///
  /// Parameter `hash`:
  /// Hash string to resolve in the underlying data source.
  ///
  /// Returns `Future<IValueResponse<IApiKey>>`.
  Future<IValueResponse<IApiKey>> findByHash(String hash);

  /// Updates the "last used" timestamp of a key identified by `id`.
  ///
  /// Parameter `id`:
  /// Entity ID of the API key to update.
  ///
  /// Returns `Future<IResponse>` describing success or failure.
  Future<IResponse> updateLastUsed(String id);
}
