import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CasaRoute extends GoRoute {
  CasaRoute({
    required super.path,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<GoRoute> super.routes = const [],
    super.redirect,
  }) : super(
         pageBuilder: (context, state) => NoTransitionPage(child: builder(context, state)),
       );
}
