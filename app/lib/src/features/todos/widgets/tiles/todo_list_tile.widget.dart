import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class TodoListTile extends StatelessWidget {
  final ITodoList list;
  final VoidCallback? onTap;

  const TodoListTile({
    super.key,
    required this.list,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CasaTile(
      onTap: onTap,
      leading: Icon(list.isShared ? Icons.groups : Icons.person_outline),
      title: CasaText(list.name),
      subtitle: CasaText(list.description.isEmpty ? 'Keine Beschreibung' : list.description),
      thirdTitle: CasaText('Owner: ${list.ownerUserId}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CasaText('${list.memberUserIds.length} Mitglieder'),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
