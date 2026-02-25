import 'package:casa/src/features/user/data/provider/users_list_provider.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoAssigneeSelectionDialog extends ConsumerWidget {
  final String? selectedUserId;

  const TodoAssigneeSelectionDialog({
    super.key,
    this.selectedUserId,
  });

  static Future<IUser?> open(
    BuildContext context, {
    String? selectedUserId,
  }) {
    return showDialog<IUser>(
      context: context,
      builder: (context) => TodoAssigneeSelectionDialog(
        selectedUserId: selectedUserId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);

    return AlertDialog(
      title: const CasaText('Benutzer auswählen'),
      content: SizedBox(
        width: 420,
        child: usersAsync.when(
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
                        title: CasaText(user.username),
                        subtitle: CasaText(user.email),
                        onTap: () => Navigator.of(context).pop(user),
                        selected: user.id == selectedUserId,
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    );
  }
}
