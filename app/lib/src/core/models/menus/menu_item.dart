import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:flutter/material.dart';

class MenuItem implements IMenuItem {
  @override
  final String title;

  @override
  final IconData icon;

  @override
  final VoidCallback onTap;

  @override
  final List<IMenuItem> children;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.children = const [],
  });

  const MenuItem.icon({
    required this.icon,
    required this.onTap,
  }) : children = const [],
       title = '';

  @override
  bool get isIconOnly => title.isEmpty;
}
