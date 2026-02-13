import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/features/todos/data/provider/todo_lists_provider.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodosRoute extends ConsumerWidget {
  const TodosRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold<IValueResponse<List<ITodoList>>>.future(
      title: 'Todos',
      future: ref.watch(todoListsProvider.future),
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final lists = response.value!;

          if (lists.isEmpty) {
            return const Center(child: CasaText('Keine Todo-Listen gefunden'));
          }

          return ListView.separated(
            shrinkWrap: true,
            itemCount: lists.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final list = lists[index];

              return CasaTile(
                onTap: () => CasaNavigator.go(context, '/todos/${list.id}'),
                leading: Icon(list.isShared ? Icons.groups : Icons.person_outline),
                title: CasaText(list.name),
                subtitle: CasaText(list.description.isEmpty ? 'Keine Beschreibung' : list.description),
                thirdTitle: CasaText('Owner: ${list.ownerUserId}'),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          );
        }

        return const Center(child: CasaText('Fehler beim Laden der Todo-Listen'));
      },
    );
  }
}
