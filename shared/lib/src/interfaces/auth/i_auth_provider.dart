/// Describes an authentication provider integration and whether it is active.
abstract interface class IAuthProvider {
  /// Whether this provider is enabled and available for authentication flow.
  ///
  /// Returns `bool`.
  bool get enabled;

  /// Unique provider name used for configuration and selection.
  ///
  /// Returns `String`.
  String get name;
}
