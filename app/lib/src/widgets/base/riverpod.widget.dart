import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodBuilder extends ConsumerWidget {
  final Widget Function(WidgetRef ref) builder;

  const RiverpodBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return builder(ref);
  }
}
