import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/features/user/widgets/user_avatar.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class DrawerProfile extends StatelessWidget {
  final IUser user;

  const DrawerProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CasaText(user.email),
                UserAvatar(user: user),
              ],
            ),
            CasaText("Hallo, ${user.username}"),
          ],
        ),
      ),
    );
  }
}
