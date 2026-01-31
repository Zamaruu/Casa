import 'package:shared/src/interfaces/version/i_version.dart';

abstract interface class IVersionInfo {
  /// Version of the app
  IVersion get version;

  /// Date of the build
  String get buildDate;

  /// Commit that triggered the build
  String get commit;

  /// Branch the app build is based on
  String get branch;

  /// Environment the app is running in (e.g. development, staging, production)
  String get environment;

  /// Platform the app is running on (e.g. Windows, Linux, Docker, iOS, Android)
  String get platform;
}

abstract interface class IServerVersionInfo implements IVersionInfo {
  /// Minimum version the mobile app must have so that it can be used.
  ///
  /// Would only trigger with breaking changes in de api interface (e.g. major version increases)
  IVersion get minimumAppVersion;
}
