import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:flutter/material.dart';

class MenuBarIconButton extends StatelessWidget {
  final IMenuItem item;

  const MenuBarIconButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: item.onTap,
      icon: Icon(item.icon),
    );
  }
}
