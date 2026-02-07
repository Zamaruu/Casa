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

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: null,
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
