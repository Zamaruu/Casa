import 'package:casa/src/core/models/version/version_info.dart';
import 'package:shared/shared.dart';

class CasaVersion {
  final bool hasVersions;

  final IVersionInfo appVersion;

  final IServerVersionInfo serverVersion;

  const CasaVersion({
    this.hasVersions = true,
    required this.appVersion,
    required this.serverVersion,
  });

  factory CasaVersion.initial() {
    final appVersion = VersionInfo.inital();
    final serverVersion = VersionInfo.inital();

    return CasaVersion(
      appVersion: appVersion,
      serverVersion: serverVersion,
      hasVersions: false,
    );
  }
}
