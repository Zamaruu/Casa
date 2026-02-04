import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:flutter/material.dart';

class MenuBarOverflowButton extends StatelessWidget {
  final List<IMenuItem> items;

  const MenuBarOverflowButton({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<IMenuItem>(
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<IMenuItem>(
            value: item,
            onTap: item.onTap,
            child: Row(
              children: [
                Icon(item.icon),
                SizedBox(width: 8),
                Text(item.title),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
