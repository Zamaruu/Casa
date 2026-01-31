import 'package:casa/src/app/abstract/repositories/base_repo.dart';
import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/features/infos/data/interfaces/i_meta_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

class InfoRepoSource extends RepoSource {
  final IMetaApi api;

  final FlutterSecureStorage storage;

  const InfoRepoSource({
    required super.ref,
    required this.api,
    required this.storage,
  });
}

abstract class InfoRepo extends BaseRepo<InfoRepoSource> {
  const InfoRepo({required super.source});

  Future<IValueResponse<IServerVersionInfo>> getServerVersionInfo({bool forceRefresh = false});

  Future<IValueResponse<IVersionInfo>> getAppVersionInfo();

  // Future<IValueResponse> getPackageInfos();
}
