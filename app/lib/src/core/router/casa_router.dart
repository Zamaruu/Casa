import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/models/enums/e_auth_status.dart';
import 'package:casa/src/core/router/casa_auth_router_refreshable.dart';
import 'package:casa/src/features/auth/auth.route.dart';
import 'package:casa/src/features/home/home.route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final initialStatus = ref.read(authStatusProvider);
    final refreshNotifier = RouterRefreshNotifier(initialStatus);

    ref.listen<EAuthStatus>(authStatusProvider, (prev, next) {
      if (prev != next) {
        refreshNotifier.value = next;
      }
    });

    return GoRouter(
      initialLocation: '/auth',
      refreshListenable: refreshNotifier,
      redirect: (context, state) {
        final status = refreshNotifier.value;
        final isLoggingIn = state.matchedLocation == '/auth';

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
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeRoute(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthRoute(),
        ),
      ],
    );
  },
);
