import 'package:casa/src/core/interfaces/menu/i_routable_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CasaNavigationBar extends StatelessWidget {
  final String location;

  final List<IRoutableMenuItem> items;

  const CasaNavigationBar({
    super.key,
    required this.location,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = items.indexWhere((item) => location.startsWith(item.route));

    return NavigationBar(
      selectedIndex: currentIndex == -1 ? 0 : currentIndex,
      onDestinationSelected: (index) {
        context.go(items[index].route);
      },
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            label: item.title,
          ),
      ],
    );
  }
}
