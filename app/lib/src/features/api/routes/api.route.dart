import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/features/api/widgets/swagger_info_card.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiRoute extends ConsumerStatefulWidget {
  const ApiRoute({super.key});

  @override
  ConsumerState<ApiRoute> createState() => _ApiRouteState();
}

class _ApiRouteState extends ConsumerState<ApiRoute> {
  late final IMenu menu;

  // region LifeCycle

  @override
  void initState() {
    super.initState();
    menu = setupMenu();
  }

  // endregion

  // region Methods

  IMenu setupMenu() {
    return Menu(
      mainItems: [
        MenuItem(
          title: "API-Schlüssel",
          icon: Icons.add,
          onTap: () {},
        ),
        MenuItem(
          title: "Aktualisieren",
          icon: Icons.refresh,
          onTap: () {},
        ),
        MenuItem(
          title: "Suchen",
          icon: Icons.search,
          onTap: () {},
        ),
      ],
      farItems: [
        MenuItem.icon(
          icon: Icons.filter_alt_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return CasaScaffold.builder(
      title: "Casa API",
      showAppBar: false,
      menu: menu,
      builder: (context, ref, layout) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SwaggerInfoCard(),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: CasaText("Noch keine API-Schlüssel erstellt"),
              ),
            ),
          ],
        );
      },
    );
  }
}
