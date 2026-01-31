import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';
import 'package:universal_platform/universal_platform.dart';

part 'version_info.g.dart';

@JsonSerializable()
class VersionInfo implements IServerVersionInfo {
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

  const VersionInfo({
    required this.version,
    required this.buildDate,
    required this.commit,
    required this.branch,
    required this.environment,
    required this.platform,
    required this.minimumAppVersion,
  });

  factory VersionInfo.debug(IVersion appVersion, String platform) {
    return VersionInfo(
      version: appVersion,
      buildDate: DateTime.now().toIso8601String(),
      commit: "local",
      branch: "unknown",
      environment: "debug",
      platform: platform,
      minimumAppVersion: Version.empty(),
    );
  }

  factory VersionInfo.inital() {
    return VersionInfo(
      version: Version.empty(),
      buildDate: DateTime.now().toIso8601String(),
      commit: "local",
      branch: "unknown",
      environment: "debug",
      platform: "unkown",
      minimumAppVersion: Version.empty(),
    );
  }

  // region JsonSerializable

  factory VersionInfo.fromJson(Map<String, dynamic> json) => _$VersionInfoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VersionInfoToJson(this);

  // endregion

  @override
  String toString() {
    final buffer = StringBuffer();

    buffer.writeln("Version: $version");
    if (UniversalPlatform.isMobile) {
      buffer.writeln("Minimum App Version: $minimumAppVersion");
    }
    buffer.writeln("Build: $buildDate");
    buffer.writeln("Commit: $commit");
    buffer.writeln("Branch: $branch");
    buffer.writeln("Environment: $environment");
    buffer.writeln("Platform: $platform");

    return buffer.toString();
  }
}
