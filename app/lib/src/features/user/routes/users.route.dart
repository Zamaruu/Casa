import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/features/user/widgets/user_avatar.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

import '../data/repositories/user.repository.dart';

class UsersRoute extends ConsumerWidget {
  const UsersRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold<IValueResponse<List<IUser>>>.future(
      title: "Benutzer",
      future: ref.read(userRepositoryProvider).findAll(),
      futureBuilder: (context, ref, response) {
        if (response.isSuccess && response.hasValue) {
          final users = response.value!;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CasaText(
                "Benutzer",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    onTap: () => CasaNavigator.go(context, "/admin/user/${user.id}"),
                    leading: UserAvatar(user: user),
                    title: CasaText(user.username),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CasaText(user.email),
                        CasaText(user.id, style: Theme.of(context).textTheme.bodySmall),
                      ],
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
