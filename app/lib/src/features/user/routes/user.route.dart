import 'package:casa/src/features/user/data/repositories/user.repository.dart';
import 'package:casa/src/features/user/widgets/user_avatar.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class UserRoute extends ConsumerWidget {
  final String id;

  const UserRoute({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold<IValueResponse<IUser>>.future(
      title: "Benutzerdetails",
      showAppBar: false,
      future: ref.read(userRepositoryProvider).find(id),
      futureBuilder: (context, ref, response) {
        if (response.isSuccess && response.hasValue) {
          final user = response.value!;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserAvatar(user: user),
              SizedBox(height: 16),
              CasaText(user.username),
              CasaText(user.email),
              CasaText(user.id),
              CasaText(user.createdAt.toString()),
              CasaText(user.updatedAt.toString()),
            ],
          );
        } else {
          return Center(
            child: CasaText("No User with id $id found"),
          );
        }
      },
    );
  }
}
