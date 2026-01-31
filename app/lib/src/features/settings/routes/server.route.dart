import 'package:casa/src/core/router/casa_router.dart';
import 'package:casa/src/features/settings/data/repositories/settings.repository.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerConfigRoute extends ConsumerStatefulWidget {
  const ServerConfigRoute({super.key});

  @override
  ConsumerState<ServerConfigRoute> createState() => _ServerConfigRouteState();
}

class _ServerConfigRouteState extends ConsumerState<ServerConfigRoute> {
  late final GlobalKey<FormState> formKey;

  late final TextEditingController urlController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    urlController = TextEditingController();
  }

  // region Methods

  void setServerUrl(WidgetRef ref) async {
    if (formKey.currentState!.validate()) {
      final url = urlController.text;

      final response = await ref.read(settingsRepositoryProvider).setServerUrl(url);

      if (response.isError) {
      } else {
        ref.invalidate(routerProvider);
      }
    }
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350, minHeight: 150, maxHeight: 250),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CasaText('URL-Konfiguration'),

                    const SizedBox(height: 16),

                    TextField(
                      controller: urlController,
                      decoration: InputDecoration(
                        labelText: 'Server-URL',
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () => setServerUrl(ref),
                      child: const CasaText('Verbinden'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
