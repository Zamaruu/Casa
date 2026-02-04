import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/widgets/menu/menubar_button.widget.dart';
import 'package:casa/src/widgets/menu/menubar_icon_button.dart';
import 'package:casa/src/widgets/menu/menubar_overflow_button.widget.dart';
import 'package:flutter/material.dart';

class Menubar extends StatefulWidget {
  final IMenu menu;

  const Menubar({
    super.key,
    required this.menu,
  });

  @override
  State<Menubar> createState() => _MenubarState();
}

class _MenubarState extends State<Menubar> {
  // region Widgets
  List<Widget> buildMainItems() {
    final items = <Widget>[];

    for (final item in widget.menu.mainItems) {
      if (item.isIconOnly) {
        final button = MenuBarIconButton(item: item);
        items.add(button);
      } else {
        final button = MenuBarButton(item: item);
        items.add(button);
      }
    }

    return items;
  }

  List<Widget> buildFarItems() {
    final items = <Widget>[];

    for (final item in widget.menu.farItems) {
      if (item.isIconOnly) {
        final button = MenuBarIconButton(item: item);
        items.add(button);
      } else {
        final button = MenuBarButton(item: item);
        items.add(button);
      }
    }

    return items;
  }

  Widget buildOverflowButton() {
    if (widget.menu.overflowItems.isNotEmpty) {
      return MenuBarOverflowButton(
        items: widget.menu.overflowItems,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // endregion
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...buildMainItems(),
                buildOverflowButton(),
                const Spacer(),
                ...buildFarItems(),
              ],
            ),
          ),
        );
      },
    );
  }
}
