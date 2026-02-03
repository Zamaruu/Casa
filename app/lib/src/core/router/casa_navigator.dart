import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

abstract class CasaNavigator {
  static void go(BuildContext context, String path) {
    final router = GoRouter.of(context);
    final currentUri = router.routerDelegate.currentConfiguration.uri.toString();

    if (currentUri == path) return;

    context.go(path);
  }
}
