import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/interfaces/config/i_app_config.dart';
import 'package:casa/src/core/interfaces/config/i_router_config.dart';
import 'package:casa/src/core/models/config/config_loader.dart';
import 'package:casa/src/core/models/config/router_config.dart';
import 'package:casa/src/core/services/service_initializer.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/features/infos/data/interfaces/i_meta_api.dart';
import 'package:casa/src/features/settings/data/repositories/settings.repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

final settingsRepositoryProvider = Provider.autoDispose<SettingsRepo>((ref) {
  final user = ref.watch(authUserProvider);

  final storage = const FlutterSecureStorage();

  final metaApi = services.api.get<IMetaApi>();

  final source = SettingsRepoSource(
    ref: ref,
    user: user,
    storage: storage,
    metaApi: metaApi,
  );

  return SettingsRepository(source: source);
});

class SettingsRepository extends SettingsRepo {
  static const _urlKey = 'casa.server.url';

  const SettingsRepository({required super.source});

  // region Server-URL Configuration (Mobile only)

  @override
  Future<IValueResponse<String>> getServerUrl() async {
    try {
      final url = await source.storage.read(key: _urlKey);

      if (url != null) {
        return ValueResponse.success(value: url);
      } else {
        return ValueResponse.failure(message: 'No server url was found!');
      }
    } catch (e, st) {
      final message = "Unexpected error while getting server url from secure storage.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  @override
  Future<IResponse> setServerUrl(String url) async {
    try {
      await source.storage.write(key: _urlKey, value: url);

      final configResponse = await getAppConfig();

      if (configResponse.isError || configResponse.hasValue == false) {
        return configResponse;
      }

      final config = configResponse.value!;

      final startUpResponse = await ServiceInitializer.startUpAfterUrlConfig(config);

      return startUpResponse;
    } catch (e, st) {
      final message = "Unexpected error while saving server url in secure storage.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return Response.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion

  // region (Service-) Configurations

  @override
  Future<IValueResponse<IRouterConfig>> getRouterConfig() async {
    try {
      final urlResponse = await getServerUrl();
      final hasUrl = urlResponse.isSuccess && urlResponse.hasValue;

      final config = CasaRouterConfig(hasConfiguredServerUrl: hasUrl);

      return ValueResponse.success(value: config);
    } catch (e, st) {
      final message = "Unexpected error while getting router config.";

      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      final config = CasaRouterConfig(hasConfiguredServerUrl: false);

      return ValueResponse.failure(
        message: message,
        error: e,
        stackTrace: st,
        value: config,
      );
    }
  }

  @override
  Future<IValueResponse<IAppConfig>> getAppConfig() async {
    try {
      final config = await AppConfigLoader.loadConfig();
      return ValueResponse.success(value: config);
    } catch (e, st) {
      final message = "Unexpected error while getting app config.";
      appLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return ValueResponse.failure(message: message, error: e, stackTrace: st);
    }
  }

  // endregion

  // region Server-Info

  @override
  Future<IValueResponse<IServerVersionInfo>> getVersionInfo() async {
    return runGuardedValue(() async {
      final versionResponse = await source.metaApi.version();
      return versionResponse;
    });
  }

  // endregion
}
