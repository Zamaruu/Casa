import 'package:casa/src/core/extensions/context.extension.dart';
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
            Text(user.email),
            Text("Hallo, ${user.username}"),
          ],
        ),
      ),
    );
  }
}
