import 'dart:convert';
import 'dart:io';

import 'package:casa/src/core/models/version/version_info.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/features/infos/data/interfaces/i_meta_api.dart';
import 'package:casa/src/features/infos/data/repositories/info.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared/shared.dart';
import 'package:universal_platform/universal_platform.dart';

final infoRepositoryProvider = Provider<InfoRepo>((ref) {
  final metaApi = services.api.get<IMetaApi>();

  final storage = FlutterSecureStorage();

  final source = InfoRepoSource(
    ref: ref,
    api: metaApi,
    storage: storage,
  );

  return InfoRepository(source: source);
});

class InfoRepository extends InfoRepo {
  const InfoRepository({required super.source});

  @override
  Future<IValueResponse<IVersionInfo>> getAppVersionInfo() async {
    return runGuardedValue<IValueResponse<IVersionInfo>>(() async {
      final packageInfo = await PackageInfo.fromPlatform();

      final versionString = packageInfo.version;
      final version = Version.fromString(versionString);

      final platform = UniversalPlatform.isWeb ? "Web" : Platform.operatingSystemVersion;

      final versionInfo = VersionInfo.debug(
        version,
        platform,
      );

      return ValueResponse.success(value: versionInfo);
    });
  }

  @override
  Future<IValueResponse<IServerVersionInfo>> getServerVersionInfo({bool forceRefresh = false}) async {
    final serverVersionKey = "casa.server.verison";

    return runGuardedValue<IValueResponse<IServerVersionInfo>>(() async {
      final versionFromStorage = await source.storage.read(key: serverVersionKey);

      if (versionFromStorage == null || forceRefresh) {
        final response = await source.api.version();

        if (response.isSuccess && response.hasValue) {
          final versionInfo = response.value!;

          final json = jsonEncode(versionInfo.toJson());
          await source.storage.write(key: serverVersionKey, value: json);

          return response;
        } else {
          return response;
        }
      } else {
        final json = jsonDecode(versionFromStorage);

        final serverVersion = VersionInfo.fromJson(json);

        return ValueResponse.success(value: serverVersion);
      }
    });
  }
}
