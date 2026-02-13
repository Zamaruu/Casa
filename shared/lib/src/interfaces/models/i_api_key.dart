import 'package:shared/shared.dart';

/// API key domain contract used for machine/service authentication.
abstract interface class IApiKey implements IEntity {
  /// Human-readable key name.
  ///
  /// Returns `String`.
  String get name;

  /// Optional key description.
  ///
  /// Returns `String?`.
  String? get description;

  /// Persisted secure hash of the API key secret.
  ///
  /// Returns `String`.
  String get keyHash;

  /// Optional expiration timestamp after which the key is invalid.
  ///
  /// Returns `DateTime?`.
  DateTime? get expiresAt;

  /// Optional timestamp indicating the key has been revoked.
  ///
  /// Returns `DateTime?`.
  DateTime? get revokedAt;

  /// Optional timestamp indicating the most recent successful key usage.
  ///
  /// Returns `DateTime?`.
  DateTime? get lastUsedAt;

  /// Authorized scope identifiers granted to the key.
  ///
  /// Returns `List<String>`.
  List<String> get scopes;
}
