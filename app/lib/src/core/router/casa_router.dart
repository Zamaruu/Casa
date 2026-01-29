import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/models/enums/e_auth_status.dart';
import 'package:casa/src/core/router/casa_auth_router_refreshable.dart';
import 'package:casa/src/features/auth/auth.route.dart';
import 'package:casa/src/features/home/home.route.dart';
import 'package:casa/src/features/settings/data/repositories/settings.repository.dart';
import 'package:casa/src/features/settings/routes/server.route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = AsyncNotifierProvider<RouterNotifier, GoRouter>(() => RouterNotifier());

class RouterNotifier extends AsyncNotifier<GoRouter> {
  late RouterRefreshNotifier _refreshNotifier;

  @override
  Future<GoRouter> build() async {
    final configResponse = await ref.read(settingsRepositoryProvider).getRouterConfig();
    final config = configResponse.value!;

    final initialStatus = ref.read(authStatusProvider);
    _refreshNotifier = RouterRefreshNotifier(initialStatus);

    ref.listen<EAuthStatus>(authStatusProvider, (prev, next) {
      if (prev != next) {
        _refreshNotifier.value = next;
      }
    });

    ref.onDispose(_refreshNotifier.dispose);

    final isMobile = config.isMobile;
    final hasServerUrl = config.hasConfiguredServerUrl;
    final needsUrlConfig = isMobile && hasServerUrl == false;

    final initialLocation = needsUrlConfig ? '/serverconfig' : '/auth';

    return GoRouter(
      initialLocation: initialLocation,
      refreshListenable: _refreshNotifier,
      redirect: _redirect,
      routes: _routes,
    );
  }

  // --- Redirect-Logik ausgelagert (lesbarer & testbar)

  String? _redirect(BuildContext context, GoRouterState state) {
    final status = _refreshNotifier.value;
    final isLoggingIn = state.matchedLocation == '/auth';
    final isServerConfig = state.matchedLocation == '/serverconfig';

    // no redirect while configuring server
    if (isServerConfig) {
      return null;
    }

    // no redirect while logging in

    if (status == EAuthStatus.unknown || status == EAuthStatus.authenticating) {
      return null;
    }

    if (status == EAuthStatus.unauthenticated && !isLoggingIn) {
      return '/auth';
    }

    if (status == EAuthStatus.authenticated && isLoggingIn) {
      return '/';
    }

    return null;
  }

  // --- Routen ausgelagert

  static final List<GoRoute> _routes = [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeRoute(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthRoute(),
    ),
    GoRoute(
      path: '/serverconfig',
      builder: (context, state) => const ServerConfigRoute(),
    ),
  ];
}
