import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/utils/menu.util.dart';
import 'package:casa/src/features/user/widgets/user_avatar.dart';
import 'package:casa/src/widgets/base/riverpod.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class CasaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final MenuUtils menuUtils;

  const CasaAppBar({
    super.key,
    required this.title,
    this.menuUtils = const MenuUtils(),
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  // region Methods

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];

    if (UniversalPlatform.isWeb) {
      actions.add(
        RiverpodBuilder(
          builder: (ref) {
            final user = ref.watch(authUserProvider);

            return UserAvatar(
              user: user,
              fontSize: 16,
              onTap: () => menuUtils.openUserContextMenu(ref.context),
            );
          },
        ),
      );
    }

    return actions;
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CasaText(title),
      actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
      actions: _buildActions(context),
    );
  }
}
