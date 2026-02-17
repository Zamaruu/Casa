import 'package:casa/src/core/auth/auth.notifier.dart';
import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/auth/auth.state.dart';
import 'package:casa/src/core/interfaces/api/i_api_response.dart';
import 'package:casa/src/core/interfaces/config/i_app_config.dart';
import 'package:casa/src/core/interfaces/config/i_router_config.dart';
import 'package:casa/src/core/models/responses/api.response.dart';
import 'package:casa/src/core/models/config/router_config.dart';
import 'package:casa/src/core/router/casa_router.dart';
import 'package:casa/src/features/infos/data/interfaces/i_meta_api.dart';
import 'package:casa/src/features/settings/data/repositories/settings.repository.dart';
import 'package:casa/src/features/settings/data/repositories/settings.repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier(this._initial);

  final AuthState _initial;

  @override
  Future<AuthState> build() async => _initial;

  void setAuthState(AuthState next) {
    state = AsyncData(next);
  }
}

class _FakeMetaApi implements IMetaApi {
  @override
  Future<IResponse> healthcheck() async => const Response.success();

  @override
  Future<IApiResponse<IServerVersionInfo>> version() async {
    return const ApiResponse.failure(httpStatus: EHttpStatus.internalServerError, message: 'unused in router tests');
  }

  @override
  Future<IApiResponse<T>> runRequestGuarded<T>(Future<IApiResponse<T>> Function() request) => request();
}

class _FakeSettingsRepo extends SettingsRepo {
  const _FakeSettingsRepo({required super.source, required this.routerConfig});

  final IRouterConfig routerConfig;

  @override
  Future<IValueResponse<IAppConfig>> getAppConfig() async {
    return const ValueResponse.failure(message: 'unused in router tests');
  }

  @override
  Future<IValueResponse<IRouterConfig>> getRouterConfig() async {
    return ValueResponse.success(value: routerConfig);
  }

  @override
  Future<IValueResponse<String>> getServerUrl() async {
    return const ValueResponse.failure(message: 'unused in router tests');
  }

  @override
  Future<IValueResponse<IServerVersionInfo>> getVersionInfo() async {
    return const ValueResponse.failure(message: 'unused in router tests');
  }

  @override
  Future<IResponse> setServerUrl(String url) async {
    return const Response.failure(message: 'unused in router tests');
  }
}

ProviderContainer _buildContainer({required AuthState authState}) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(() => TestAuthNotifier(authState)),
      settingsRepositoryProvider.overrideWith((ref) {
        final source = SettingsRepoSource(
          ref: ref,
          user: authState.user ?? User.initial(),
          storage: const FlutterSecureStorage(),
          metaApi: _FakeMetaApi(),
        );

        return _FakeSettingsRepo(
          source: source,
          routerConfig: const CasaRouterConfig(hasConfiguredServerUrl: true),
        );
      }),
    ],
  );
}

Future<GoRouter> _pumpRouter(WidgetTester tester, ProviderContainer container) async {
  final router = await container.read(routerProvider.future);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ),
  );

  await tester.pumpAndSettle();

  return router;
}

void main() {
  group('Casa Router auth redirects', () {
    testWidgets('unauthenticated users stay on /auth and cannot navigate to /', (tester) async {
      final container = _buildContainer(authState: AuthState.initial());
      addTearDown(container.dispose);

      final router = await _pumpRouter(tester, container);

      expect(find.text('Login'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/auth');

      router.go('/');
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/auth');
    });

    testWidgets('authenticated users are redirected from /auth to / automatically', (tester) async {
      const user = User(
        id: 'u1',
        email: 'user@test.dev',
        username: 'user',
        passwordHash: 'hash',
      );

      final container = _buildContainer(authState: const AuthState(user: user, token: 'jwt'));
      addTearDown(container.dispose);

      final router = await _pumpRouter(tester, container);
      expect(router.routeInformationProvider.value.uri.path, '/');
      router.go('/auth');
      await tester.pumpAndSettle();

      expect(router.routeInformationProvider.value.uri.path, '/');
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('router auto-redirects to / after login state changes', (tester) async {
      final container = _buildContainer(authState: AuthState.initial());
      addTearDown(container.dispose);

      final router = await _pumpRouter(tester, container);
      expect(find.text('Login'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/auth');

      final notifier = container.read(authProvider.notifier) as TestAuthNotifier;
      notifier.setAuthState(
        const AuthState(
          user: User(
            id: 'u2',
            email: 'authed@test.dev',
            username: 'authed',
            passwordHash: 'hash',
          ),
          token: 'jwt',
        ),
      );

      await tester.pumpAndSettle();

      expect(router.routeInformationProvider.value.uri.path, '/');
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('router auto-redirects back to /auth after logout state changes', (tester) async {
      const user = User(
        id: 'u1',
        email: 'user@test.dev',
        username: 'user',
        passwordHash: 'hash',
      );

      final container = _buildContainer(authState: const AuthState(user: user, token: 'jwt'));
      addTearDown(container.dispose);

      final router = await _pumpRouter(tester, container);
      expect(router.routeInformationProvider.value.uri.path, '/');

      final notifier = container.read(authProvider.notifier) as TestAuthNotifier;
      notifier.setAuthState(AuthState.initial());

      await tester.pumpAndSettle();

      expect(router.routeInformationProvider.value.uri.path, '/auth');
      expect(find.text('Login'), findsOneWidget);
    });
  });
}
