import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/features/auth/auth.route.dart';
import 'package:casa/src/features/home/home.route.dart';
import 'package:casa/src/features/root/root.route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final asyncAuthState = ref.watch(authProvider);
    return GoRouter(
      initialLocation: '/',
      // refreshListenable: GoRouterRefreshStream(ref.watch(authProvider.notifier).stream),
      redirect: (context, state) {
        final auth = asyncAuthState.value;

        final isLoggingIn = state.matchedLocation == '/auth';
        final isAuthenticated = auth?.isAuthenticated ?? false;

        if (!isAuthenticated && !isLoggingIn) {
          return '/auth';
        }

        if (isAuthenticated && isLoggingIn) {
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
