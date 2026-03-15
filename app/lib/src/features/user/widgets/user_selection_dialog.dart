import 'package:casa/src/features/user/data/provider/users_list_provider.dart';
import 'package:casa/src/features/user/widgets/user_avatar.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class UserSelectionDialog extends ConsumerWidget {
  final String? selectedUserId;

  const UserSelectionDialog({
    super.key,
    this.selectedUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);

    return usersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => CasaText('Fehler beim Laden der Benutzer: $error'),
      data: (response) {
        final users = response.value ?? const <IUser>[];

        if (users.isEmpty) {
          return const CasaText('Keine Benutzer vorhanden');
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: users
                .map(
                  (user) => ListTile(
                    leading: UserAvatar(user: user),
                    title: Text(user.username),
                    subtitle: Text(user.email),
                    onTap: () => Navigator.of(context).pop(user),
                    selected: user.id == selectedUserId,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
