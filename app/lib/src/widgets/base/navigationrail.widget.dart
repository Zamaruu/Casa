import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:casa/src/core/interfaces/menu/i_routable_menu_item.dart';
import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:flutter/material.dart';

class CasaNavigationRail extends StatelessWidget {
  final List<IRoutableMenuItem> items;

  final String? location;

  const CasaNavigationRail({
    super.key,
    required this.items,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = items.indexWhere((item) => item.route == location);

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        final item = items[index];
        CasaNavigator.go(context, item.route);
      },
      labelType: NavigationRailLabelType.all,
      destinations: items
          .map(
            (item) => NavigationRailDestination(
              icon: Icon(item.icon),
              label: Text(item.title),
            ),
          )
          .toList(),
    );
  }
}
