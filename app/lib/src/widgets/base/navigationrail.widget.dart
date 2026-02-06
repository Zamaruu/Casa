import 'package:casa/src/core/interfaces/menu/i_routable_menu_item.dart';
import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:flutter/material.dart';

class CasaNavigationRail extends StatelessWidget {
  final List<IRoutableMenuItem> items;

  final String location;

  const CasaNavigationRail({
    super.key,
    required this.items,
    required this.location,
  });

  bool isRouteSelected(String route) {
    if (location == route) return true;

    // Segment-sicheres Prefix-Matching
    return location.startsWith('$route/');
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.where((item) => isRouteSelected(item.route));
    final selectedIndex = selectedItem.isEmpty ? -1 : items.indexOf(selectedItem.first);

    return NavigationRail(
      selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
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
