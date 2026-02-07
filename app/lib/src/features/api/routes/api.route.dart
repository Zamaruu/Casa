import 'package:casa/src/core/api/api_service.dart';
import 'package:casa/src/core/constants/svg.constants.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:casa/src/core/utils/launcher.util.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            Card(
              child: Builder(
                builder: (context) {
                  final launcher = const LauncherUtil();
                  final url = services.get<ApiServiceManager>().url;
                  final swaggerUrl = "$url/swagger/ui";

                  return ListTile(
                    leading: SvgPicture.asset(
                      kSwaggerLogoSvg,
                      semanticsLabel: 'Swagger Logo',
                      colorFilter: ColorFilter.mode(Color(0xFF49a22b), BlendMode.srcIn),
                    ),
                    title: const CasaText("Swagger OpenAPI Documentation"),
                    subtitle: CasaText(swaggerUrl),

                    trailing: IconButton(
                      onPressed: () {
                        launcher.launchWebsite(context: context, url: swaggerUrl);
                      },
                      icon: Icon(Icons.open_in_new),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
