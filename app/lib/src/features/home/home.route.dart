import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeRoute extends ConsumerWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold(
      title: "Home",
      builder: (context, ref) {
        return Center(
          child: Text("Home"),
        );
      },
    );
  }
}
