import 'package:casa/src/app/abstract/repositories/base_repo.dart';
import 'package:casa/src/app/abstract/repositories/repo_source.dart';
import 'package:casa/src/core/interfaces/config/i_app_config.dart';
import 'package:casa/src/core/interfaces/config/i_router_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

class SettingsRepoSource extends RepoSource {
  final FlutterSecureStorage storage;

  const SettingsRepoSource({
    required super.user,
    required this.storage,
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
}
