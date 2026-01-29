import 'package:casa/src/app/interfaces/i_menu_item.dart';
import 'package:casa/src/app/layout/simple_menu_file.dart';
import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/features/profile/widgets/drawerprofile.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class MenuUtils {
  List<IMenuItem> buildDrawerItems(BuildContext context) {
    final items = <IMenuItem>[
      SimpleMenuItem(
        title: 'Kalender',
        icon: Icons.calendar_today,
        onTap: () => context.go('/calendar'),
      ),
      SimpleMenuItem(
        title: 'Todos',
        icon: Icons.checklist,
        onTap: () => context.go('/todos'),
      ),
      SimpleMenuItem(
        title: 'Rezepte',
        icon: Icons.restaurant,
        onTap: () => context.go('/recipes'),
      ),
    ];

    return items;
  }

  List<IMenuItem> buildServiceItems(WidgetRef ref) {
    final context = ref.context;

    final items = <IMenuItem>[
      SimpleMenuItem(
        title: 'Einstellungen',
        icon: Icons.settings,
        onTap: () => context.go('/settings'),
      ),
      SimpleMenuItem(
        title: 'Abmelden',
        icon: Icons.logout,
        onTap: () => ref.read(authProvider.notifier).logout(),
      ),
    ];

    return items;
  }

  Widget buildProfile(BuildContext context, IUser user) {
    return DrawerProfile(user: user);
  }
}
