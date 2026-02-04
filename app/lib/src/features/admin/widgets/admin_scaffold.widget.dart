import 'package:casa/src/core/interfaces/menu/i_routable_menu_item.dart';
import 'package:casa/src/core/models/menus/nav_menu_item.dart';
import 'package:casa/src/widgets/base/navigationrail.widget.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:flutter/material.dart';

class CasaAdminScaffold extends StatefulWidget {
  final Widget child;

  final String location;

  const CasaAdminScaffold({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  State<CasaAdminScaffold> createState() => _CasaAdminScaffoldState();
}

class _CasaAdminScaffoldState extends State<CasaAdminScaffold> {
  late List<IRoutableMenuItem> navItems;

  @override
  void initState() {
    super.initState();
    navItems = setupNavItems();
  }

  // region Methods

  List<IRoutableMenuItem> setupNavItems() {
    final navItems = <IRoutableMenuItem>[
      NavigationMenuItem(
        route: "/admin",
        icon: Icons.dashboard,
        title: "Dashboard",
      ),
      NavigationMenuItem(
        route: "/admin/user",
        icon: Icons.person,
        title: "Benutzer",
      ),
      NavigationMenuItem(
        route: "/admin/roles",
        icon: Icons.lock_person,
        title: "Rollen",
      ),
      NavigationMenuItem(
        route: "/admin/automation",
        icon: Icons.flash_auto,
        title: "Automation",
      ),
      NavigationMenuItem(
        route: "/admin/authentication",
        icon: Icons.lock,
        title: "Authenthication",
      ),
      NavigationMenuItem(
        route: "/admin/api",
        icon: Icons.api,
        title: "API-Zugriff",
      ),
      NavigationMenuItem(
        route: "/admin/system",
        icon: Icons.info,
        title: "Systeminformationen",
      ),
    ];

    return navItems;
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return CasaScaffold.builder(
          title: "Administration",
          bodyPadding: EdgeInsets.zero,
          builder: (context, ref) {
            return Row(
              children: [
                if (!isMobile)
                  CasaNavigationRail(
                    location: widget.location,
                    items: navItems,
                  ),
                Expanded(child: widget.child),
              ],
            );
          },
        );
      },
    );
  }
}
