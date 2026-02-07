import 'package:casa/src/app/abstract/repositories/base_repo.dart';
import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/core/interfaces/config/i_app_config.dart';
import 'package:casa/src/core/interfaces/config/i_router_config.dart';
import 'package:casa/src/features/infos/data/interfaces/i_meta_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

class SettingsRepoSource extends AuthenticatedRepoSource {
  final FlutterSecureStorage storage;

  final IMetaApi metaApi;

  const SettingsRepoSource({
    required super.ref,
    required super.user,
    required this.storage,
    required this.metaApi,
  });
}

abstract class SettingsRepo extends BaseRepo<SettingsRepoSource> {
  const SettingsRepo({required super.source});

  // region Server-URL Configuration (Mobile only)

  Future<IValueResponse<String>> getServerUrl();

  Future<IResponse> setServerUrl(String url);

  // endregion

  // region (Service-) Configurations

  Future<IValueResponse<IRouterConfig>> getRouterConfig();

  Future<IValueResponse<IAppConfig>> getAppConfig();

  // endregion

  // region Server-Info

  Future<IValueResponse<IServerVersionInfo>> getVersionInfo();

  // endregion
}
