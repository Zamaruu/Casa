import 'package:casa/src/app/interfaces/i_menu_item.dart';
import 'package:flutter/material.dart';

class SimpleMenuItem implements IMenuItem {
  @override
  final String title;

  @override
  final IconData icon;

  @override
  final VoidCallback onTap;

  @override
  final List<IMenuItem> children;

  SimpleMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.children = const [],
  });
}
