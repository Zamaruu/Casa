import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

abstract class CasaNavigator {
  static void go(BuildContext context, String path) {
    final router = GoRouter.of(context);
    final currentUri = router.routerDelegate.currentConfiguration.uri.toString();

    if (currentUri == path) return;

    context.go(path);
  }

  /// Takes the current route, removes all query parameters (after the ?) and calls context.go with that route.
  static void removeQuery(BuildContext context) {
    final router = GoRouter.of(context);
    final currentUri = router.routerDelegate.currentConfiguration.uri.toString();

    final queryIndex = currentUri.indexOf('?');
    final newUri = queryIndex == -1 ? currentUri : currentUri.substring(0, queryIndex);

    context.go(newUri);
  }
}
