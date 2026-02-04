import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRoute extends ConsumerWidget {
  const AdminRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: CasaText("Dashboard"),
    );
  }
}
