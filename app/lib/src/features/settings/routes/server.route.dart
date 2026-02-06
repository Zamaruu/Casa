import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/router/casa_router.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
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
  late bool isLoading;

  late final GlobalKey<FormState> formKey;

  late final TextEditingController urlController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    urlController = TextEditingController();
    isLoading = false;
  }

  // region Methods

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void setServerUrl(WidgetRef ref) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);

      final url = urlController.text;

      final response = await ref.read(settingsRepositoryProvider).setServerUrl(url);

      if (response.isError) {
        if (mounted) {
          setLoading(false);
          final message = response.message ?? 'Unexpected error while setting server url.';
          CasaSnackbars.showDefaultSnackbar(message: message, context: context, type: ESnackbarType.error);
        }
      } else {
        final versionInfo = await ref.read(settingsRepositoryProvider).getVersionInfo();

        setLoading(false);

        if (versionInfo.isSuccess && versionInfo.hasValue) {
          if (mounted) {
            final message = 'Server erfolgreich verbunden!';
            CasaSnackbars.showDefaultSnackbar(message: message, context: context, type: ESnackbarType.success);
          }
          ref.invalidate(routerProvider);
        } else {
          if (mounted) {
            final message = versionInfo.message ?? 'Unexpected error while getting server version info.';
            CasaSnackbars.showDefaultSnackbar(message: message, context: context, type: ESnackbarType.error);
          }
        }
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

                    TextFormField(
                      controller: urlController,
                      decoration: InputDecoration(
                        labelText: 'Server-URL',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte eine URL eingeben.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () => setServerUrl(ref),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CasaText(
                            'Verbinden',
                            textAlign: TextAlign.center,
                          ),
                          if (isLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
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
