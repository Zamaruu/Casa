import 'package:casa/src/app/theme/casa_theme.dart';
import 'package:casa/src/core/router/casa_router.dart';
import 'package:casa/src/core/services/service_initializer.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await ServiceInitializer.startUpServices();

  runApp(
    ProviderScope(
      child: CasaApp(),
    ),
  );
}

class CasaApp extends ConsumerWidget {
  const CasaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerAsync = ref.watch(routerProvider);

    debugPaintSizeEnabled = false;

    return ToastificationWrapper(
      child: routerAsync.when(
        loading: _loadingBuilder,
        error: _errorBuilder,
        data: (router) => MaterialApp.router(
          title: "Casa",
          theme: CasaTheme.light(),
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

Widget _loadingBuilder() {
  return MaterialApp(
    title: "Casa",
    theme: CasaTheme.light(),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

Widget _errorBuilder(Object error, StackTrace stack) {
  final message = "Unexpected error while starting up Casa-App.";

  appLog(message: message, error: error, stackTrace: stack);

  return MaterialApp(
    title: "Casa",
    theme: CasaTheme.light(),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CasaText('Casa', style: TextStyle(fontSize: 20)),
            CasaText(message, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CasaText(
                error.toString(),
                maxLines: 10,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 32),
              CasaText(
                stack.toString(),
                maxLines: 10,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const CasaText("Report Issue"),
                  icon: const Icon(Icons.bug_report),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
