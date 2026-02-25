import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

bool canMarkTodoAsDone({
  required ITodo item,
  required bool markDoneLoading,
}) {
  return item.status != ETodoStatus.done && !markDoneLoading;
}

class TodoItemTile extends StatelessWidget {
  final ITodo item;
  final VoidCallback? onTap;
  final VoidCallback? onMarkDone;
  final bool markDoneLoading;

  const TodoItemTile({
    super.key,
    required this.item,
    this.onTap,
    this.onMarkDone,
    this.markDoneLoading = false,
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
      leading: IconButton(
        icon: markDoneLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                item.status == ETodoStatus.done
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
              ),
        onPressed:
            canMarkTodoAsDone(
              item: item,
              markDoneLoading: markDoneLoading,
            )
            ? onMarkDone
            : null,
        tooltip: item.status == ETodoStatus.done
            ? 'Erledigt'
            : 'Als erledigt markieren',
      ),
      title: CasaText(item.title),
      subtitle: CasaText(subtitle),
      thirdTitle: CasaText('Erstellt von: ${item.createdByUserId}'),
      trailing: CasaText('${item.attachmentIds.length} Anhänge'),
    );
  }
}
