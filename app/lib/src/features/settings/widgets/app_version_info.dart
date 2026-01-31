import 'package:casa/src/core/provider/version.provider.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppVersionInfo extends ConsumerWidget {
  const AppVersionInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versions = ref.watch(versionAsyncProvider);

    return Padding(
      padding: EdgeInsets.all(8),
      child: Builder(
        builder: (context) {
          if (versions.isLoading) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 8),
                Text('App Version: Loading...'),
              ],
            );
          } else {
            final version = versions.value!;
            return Center(
              child: CasaText(
                'App Version: ${version.appVersion.version}',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
