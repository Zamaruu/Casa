import 'package:casa/src/core/interfaces/menu/i_routable_menu_item.dart';
import 'package:flutter/material.dart';

class NavigationMenuItem implements IRoutableMenuItem {
  @override
  final String route;

  @override
  final IconData icon;

  @override
  final String title;

  const NavigationMenuItem({
    required this.route,
    required this.icon,
    required this.title,
  });

  @override
  bool get isIconOnly => title.isEmpty;
}
