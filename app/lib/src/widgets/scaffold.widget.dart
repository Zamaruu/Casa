import 'package:casa/src/app/interfaces/i_menu_item.dart';
import 'package:casa/src/core/utils/menu.utils.dart';
import 'package:casa/src/widgets/appbar.widget.dart';
import 'package:casa/src/widgets/drawer.widget.dart';
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
  late List<IMenuItem> navigationItems;

  @override
  void initState() {
    super.initState();
    navigationItems = MenuUtils().buildDrawerItems(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CasaAppBar(title: widget.title),
      drawer: CasaDrawer(items: navigationItems),
      body: Builder(
        builder: (context) => widget.builder(context, ref),
      ),
    );
  }
}
