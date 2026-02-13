import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/features/todos/data/provider/todo_items_provider.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoListRoute extends ConsumerWidget {
  final String listId;

  const TodoListRoute({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold<IValueResponse<List<ITodoItem>>>.future(
      title: 'Todo-Liste',
      future: ref.watch(todoItemsByListProvider(listId).future),
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final items = response.value!;

          if (items.isEmpty) {
            return const Center(child: CasaText('Keine Todo-Items gefunden'));
          }

          return ListView.separated(
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];

              final subtitle = <String>[
                if (item.description.isNotEmpty) item.description,
                'Status: ${item.status.name}',
                'Priorität: ${item.priority.name}',
                if (item.dueDate != null) 'Fällig: ${item.dueDate!.toIso8601String()}',
              ].join(' | ');

              return CasaTile(
                onTap: () => CasaNavigator.go(context, '/todos/$listId/item/${item.id}'),
                leading: Icon(item.status == ETodoStatus.done ? Icons.check_circle_outline : Icons.radio_button_unchecked),
                title: CasaText(item.title),
                subtitle: CasaText(subtitle),
                thirdTitle: CasaText('Erstellt von: ${item.createdByUserId}'),
                trailing: CasaText('${item.attachmentIds.length} Anhänge'),
              );
            },
          );
        }

        return Center(child: CasaText('Fehler beim Laden der Todo-Items für $listId'));
      },
    );
  }
}
