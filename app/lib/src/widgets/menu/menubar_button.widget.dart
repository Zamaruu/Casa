import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:flutter/material.dart';

class MenuBarButton extends StatelessWidget {
  final IMenuItem item;

  const MenuBarButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: item.onTap,
      label: Text(item.title),
      icon: Icon(item.icon),
    );
  }
}
