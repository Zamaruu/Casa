import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/features/auth/auth.route.dart';
import 'package:casa/src/features/home/home.route.dart';
import 'package:casa/src/features/root/root.route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authProvider);

    return GoRouter(
      initialLocation: '/',
      // refreshListenable: GoRouterRefreshStream(ref.watch(authProvider.notifier).stream),
      redirect: (context, state) {
        return null;

        if (authState.isLoading) {
          return '/';
        }

        final isLoggedIn = authState.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';

        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }

        if (isLoggedIn && isLoginRoute) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RootRoute(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthRoute(),
        ),
        // GoRoute(
        //  path: '/login',
        //  builder: (context, state) => const LoginPage(),
        // ),
        GoRoute(
          path: "/home",
          builder: (context, state) => const HomeRoute(),
          routes: [
            // GoRoute(
            //  path: 'todos',
            //  builder: (context, state) => const TodoPage(),
            // ),
          ],
        ),
      ],
    );
  },
);
