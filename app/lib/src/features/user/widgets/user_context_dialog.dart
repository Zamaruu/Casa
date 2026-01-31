import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/constants/link.constants.dart';
import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/utils/launcher.util.dart';
import 'package:casa/src/features/user/widgets/user_avatar.dart';
import 'package:casa/src/widgets/base/contextdialog.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserContextDialog extends ConsumerWidget {
  const UserContextDialog({super.key});

  // region Methods

  void _openSupport(BuildContext context) {
    Navigator.of(context).pop();

    final launcherUtil = const LauncherUtil();

    ContextDialog.openDialog(
      context,
      ContextDialog(
        title: 'Unterstützung & Feedback',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CasaText(
              "Offizielle Casa Quellen",
            ),
            SizedBox(height: 8),

            TextButton.icon(
              onPressed: () => launcherUtil.launchWebsite(context: context, url: kGithubCasa),
              label: Text("Quellcode"),
              icon: Icon(MdiIcons.github),
            ),
            SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => launcherUtil.launchWebsite(context: context, url: kGithubCasaCreateIssue),
              label: Text("Fehler & Verbesserungsvorschläge"),
              icon: Icon(Icons.bug_report_outlined),
            ),
          ],
        ),
      ),
    );
  }

  // endregion

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar(user: user),
        SizedBox(height: 16),
        CasaText(
          user.username,
          style: TextStyle(
            fontSize: 18,
            color: context.theme.primaryColor.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
        CasaText(
          user.email,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 16),

        ElevatedButton.icon(
          onPressed: () => context.go('/settings'),
          icon: Icon(Icons.settings),
          label: Text("Profileinstellungen"),
        ),

        SizedBox(height: 8),

        ElevatedButton.icon(
          onPressed: () => ref.read(authProvider.notifier).logout(),
          icon: Icon(Icons.logout),
          label: Text("Abmelden"),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: context.theme.primaryColor.withValues(alpha: 0.5),
          ),
        ),

        TextButton(
          onPressed: () => _openSupport(context),
          child: Text(
            "Unterstützung & Feedback",
          ),
        ),
      ],
    );
  }
}
