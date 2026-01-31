import 'package:casa/src/core/models/version/casa_version.dart';
import 'package:casa/src/features/infos/data/repositories/info.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final versionAsyncProvider = AsyncNotifierProvider<VersionNotifier, CasaVersion>(() => VersionNotifier());

final versionProvider = Provider<CasaVersion>((ref) {
  final versionAsync = ref.watch(versionAsyncProvider);

  if (versionAsync.isLoading) {
    return CasaVersion.initial();
  }

  return versionAsync.value!;
});

class VersionNotifier extends AsyncNotifier<CasaVersion> {
  @override
  Future<CasaVersion> build() async {
    final serverVersion = await ref.read(infoRepositoryProvider).getServerVersionInfo();
    final appVersion = await ref.read(infoRepositoryProvider).getAppVersionInfo();

    if (serverVersion.isError || serverVersion.hasValue == false || appVersion.isError || appVersion.hasValue == false) {
      return CasaVersion.initial();
    }

    return CasaVersion(
      serverVersion: serverVersion.value!,
      appVersion: appVersion.value!,
    );
  }
}
