import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/extensions/string.extensions.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/features/user/widgets/user_avatar.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

import '../data/repositories/user.repository.dart';

class UsersRoute extends ConsumerStatefulWidget {
  const UsersRoute({super.key});

  @override
  ConsumerState<UsersRoute> createState() => _UsersRouteState();
}

class _UsersRouteState extends ConsumerState<UsersRoute> {
  late final IMenu menu;

  @override
  void initState() {
    super.initState();
    menu = setupMenu();
  }

  // region Methods

  IMenu setupMenu() {
    return Menu(
      mainItems: [
        MenuItem(
          title: "Benutzer",
          icon: Icons.person_add_alt,
          onTap: () => CasaNavigator.go(context, "/admin/user/create"),
        ),
        MenuItem(
          title: "Rollen",
          icon: Icons.lock_person_outlined,
          onTap: () => CasaNavigator.go(context, "/admin/user/roles"),
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
        MenuItem.icon(
          icon: Icons.dashboard_outlined,
          onTap: () {},
        ),
        MenuItem.icon(
          icon: Icons.info_outline,
          onTap: () => CasaNavigator.go(context, "/admin/user/info"),
        ),
      ],
    );
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return CasaScaffold<IValueResponse<List<IUser>>>.future(
      title: "Benutzer",
      showAppBar: false,
      future: ref.read(userRepositoryProvider).findAll(),
      menu: menu,
      futureBuilder: (context, ref, response) {
        if (response.isSuccess && response.hasValue) {
          final users = response.value!;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: users.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return CasaTile(
                    onTap: () => CasaNavigator.go(context, "/admin/user/${user.id}"),
                    leading: UserAvatar(user: user),
                    title: CasaText(user.username),
                    subtitle: CasaText(user.email),
                    thirdTitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        user.groups.length,
                        (index) {
                          final group = user.groups[index];
                          final isLast = index == user.groups.length - 1;

                          return CasaText(
                            "${group.asCapitalized}${isLast ? "" : ", "}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          color: context.theme.primaryColor,
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          color: context.theme.primaryColor,
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {},
                          color: context.theme.primaryColor,
                          icon: const Icon(Icons.info),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        } else {
          return Center(
            child: CasaText("No Users found"),
          );
        }
      },
    );
  }
}
