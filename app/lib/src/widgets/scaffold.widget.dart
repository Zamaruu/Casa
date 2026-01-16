import 'package:casa/src/app/interfaces/i_menu_item.dart';
import 'package:casa/src/widgets/appbar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CasaScaffold extends ConsumerStatefulWidget {
  final String title;

  final Widget Function(BuildContext context, WidgetRef ref) builder;

  final List<IMenuItem> menuItems;

  const CasaScaffold({
    super.key,
    required this.title,
    required this.builder,
    this.menuItems = const [],
  });

  @override
  ConsumerState<CasaScaffold> createState() => _CasaScaffoldState();
}

class _CasaScaffoldState extends ConsumerState<CasaScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CasaAppBar(title: widget.title),
      body: Builder(
        builder: (context) => widget.builder(context, ref),
      ),
    );
  }
}
