import 'package:casa/src/core/models/layout/layout.dart';
import 'package:flutter/material.dart';

class CasaLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Layout layout) builder;

  const CasaLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        final layout = Layout.fromConstraints(context, constraints);

        return builder(context, layout);
      },
    );
  }
}
