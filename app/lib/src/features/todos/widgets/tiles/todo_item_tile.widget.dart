import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class TodoItemTile extends StatelessWidget {
  final ITodo item;
  final VoidCallback? onTap;

  const TodoItemTile({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = <String>[
      if (item.description.isNotEmpty) item.description,
      'Status: ${item.status.name}',
      'Priorität: ${item.priority.name}',
      if (item.dueDate != null) 'Fällig: ${item.dueDate!.toIso8601String()}',
    ].join(' | ');

    return CasaTile(
      onTap: onTap,
      leading: Icon(item.status == ETodoStatus.done ? Icons.check_circle_outline : Icons.radio_button_unchecked),
      title: CasaText(item.title),
      subtitle: CasaText(subtitle),
      thirdTitle: CasaText('Erstellt von: ${item.createdByUserId}'),
      trailing: CasaText('${item.attachmentIds.length} Anhänge'),
    );
  }
}
