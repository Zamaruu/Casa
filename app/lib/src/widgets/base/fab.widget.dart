import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class CasaFab extends StatelessWidget {
  // region Parameters

  final List<IMenuItem> items;

  // endregion

  // region Getter

  bool get isSingle => items.length == 1;

  // endregion

  // region Constructors

  const CasaFab._({
    // ignore: unused_element_parameter
    super.key,
    required this.items,
  });

  factory CasaFab.single({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return CasaFab._(
      items: [MenuItem.icon(icon: icon, onTap: onPressed)],
    );
  }

  factory CasaFab.multiple({
    required List<IMenuItem> items,
  }) {
    return CasaFab._(
      items: items,
    );
  }

  // endregion

  // region Widgets

  List<Widget> _buildChildren() {
    return items.map((item) {
      return FloatingActionButton.small(
        onPressed: item.onTap,
        tooltip: item.title,
        child: Icon(item.icon),
      );
    }).toList();
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    if (isSingle) {
      final item = items.first;

      return FloatingActionButton(
        onPressed: item.onTap,
        child: Icon(item.icon),
      );
    } else {
      return ExpandableFab(
        type: ExpandableFabType.up,
        pos: ExpandableFabPos.right,
        distance: 60,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.menu),
          fabSize: ExpandableFabSize.regular,
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.small,
        ),
        children: _buildChildren(),
      );
    }
  }
}
