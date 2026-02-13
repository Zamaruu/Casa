import 'package:shared/shared.dart';

/// Runtime/app build metadata contract.
abstract interface class IVersionInfo {
  /// Version of the app
  ///
  /// Returns `IVersion`.
  IVersion get version;

  /// Date of the build
  ///
  /// Returns `String`.
  String get buildDate;

  /// Commit that triggered the build
  ///
  /// Returns `String`.
  String get commit;

  /// Branch the app build is based on
  ///
  /// Returns `String`.
  String get branch;

  /// Environment the app is running in (e.g. development, staging, production)
  ///
  /// Returns `String`.
  String get environment;

  /// Platform the app is running on (e.g. Windows, Linux, Docker, iOS, Android)
  ///
  /// Returns `String`.
  String get platform;
}

/// Server-specific extension of [IVersionInfo].
abstract interface class IServerVersionInfo implements IVersionInfo, ISerializable {
  /// Minimum version the mobile app must have so that it can be used.
  ///
  /// This is primarily used to enforce compatibility after breaking API
  /// changes (for example major version increases).
  ///
  /// Returns `IVersion`.
  IVersion get minimumAppVersion;
}
