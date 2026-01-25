import 'package:casa/src/app/theme/casa_theme.dart';
import 'package:casa/src/core/router/casa_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(
    ProviderScope(
      child: const CasaApp(),
    ),
  );
}

class CasaApp extends ConsumerWidget {
  const CasaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: "Casa",
      theme: CasaTheme.light(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
