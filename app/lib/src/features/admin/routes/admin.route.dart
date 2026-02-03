import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRoute extends ConsumerWidget {
  const AdminRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold.builder(
      title: "Administration",
      builder: (context, ref) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text("Benutzer"),
                    onTap: () => CasaNavigator.go(context, "/admin/user"),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
