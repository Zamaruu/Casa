import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/features/api/data/provider/apikeys_list_provider.dart';
import 'package:casa/src/features/api/widgets/swagger_info_card.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
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
          onTap: () => ref.invalidate(apiKeysListProvider),
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
    return CasaScaffold.future(
      title: "Casa API",
      showAppBar: false,
      menu: menu,
      future: ref.watch(apiKeysListProvider.future),
      futureBuilder: (context, ref, response, layout) {
        final apiKeys = response.value ?? [];

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SwaggerInfoCard(),
            SizedBox(height: 16),
            if (apiKeys.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: apiKeys.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
                  itemBuilder: (context, index) {
                    final apiKey = apiKeys[index];

                    return CasaTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CasaText(apiKey.name),
                          CasaText(
                            " (${apiKey.keyHash.substring(0, 16)}...)",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      subtitle: apiKey.description != null ? CasaText(apiKey.description!) : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (apiKeys.isEmpty)
              Expanded(
                child: Center(
                  child: CasaText("Keine API-Schlüssel gefunden"),
                ),
              ),
          ],
        );
      },
    );
  }
}
