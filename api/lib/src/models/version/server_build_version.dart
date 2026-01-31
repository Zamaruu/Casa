import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';

part 'server_build_version.g.dart';

@JsonSerializable()
class ServerBuildVersion implements IServerVersionInfo {
  // region Parameters

  @override
  @VersionConverter()
  final IVersion version;

  @override
  final String buildDate;

  @override
  final String commit;

  @override
  final String branch;

  @override
  final String environment;

  @override
  final String platform;

  @override
  @VersionConverter()
  final IVersion minimumAppVersion;

  // endregion

  // region Constructors

  const ServerBuildVersion({
    required this.version,
    required this.buildDate,
    required this.commit,
    required this.branch,
    required this.environment,
    required this.platform,
    required this.minimumAppVersion,
  });

  /// Creates a [ServerBuildVersion] based on the Build-Arguments provided by Dart-Build / Docker-Image.
  factory ServerBuildVersion.fromEnvironment() {
    final buildDate = String.fromEnvironment("BUILD_DATE", defaultValue: DateTime.now().toIso8601String());
    final commit = String.fromEnvironment("COMMIT", defaultValue: "Unknown");
    final branch = String.fromEnvironment("BRANCH", defaultValue: "Unknown");
    final environment = String.fromEnvironment("ENVIRONMENT", defaultValue: "Development");
    final platform = getPlatfrom();

    final minimumAppVersionString = String.fromEnvironment("MINIMUM_APP_VERSION", defaultValue: "0.0.0");
    final minimumAppVersion = Version.fromString(minimumAppVersionString);

    final versionString = String.fromEnvironment("VERSION", defaultValue: "0.0.0");
    final version = Version.fromString(versionString);

    return ServerBuildVersion(
      version: version,
      buildDate: buildDate,
      commit: commit,
      branch: branch,
      environment: environment,
      platform: platform,
      minimumAppVersion: minimumAppVersion,
    );
  }

  // endregion

  // region Methods

  static String getPlatfrom() {
    final osVersion = Platform.operatingSystemVersion; // Platform Version (e.g. Linux 10.15.1)
    final arch = Platform.version; // Platform Architecture (e.g. x64, arm64)

    return "$osVersion $arch";
  }

  // endregion

  // region JsonSerializable

  factory ServerBuildVersion.fromJson(Map<String, dynamic> json) => _$ServerBuildVersionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServerBuildVersionToJson(this);

  // endregion
}
