import 'package:casa/src/features/todos/widgets/tiles/todo_list_tile.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class TodoListsContent extends StatelessWidget {
  final List<ITodoList> lists;
  final void Function(ITodoList list) onTap;

  const TodoListsContent({
    super.key,
    required this.lists,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (lists.isEmpty) {
      return const Center(child: CasaText('Keine Todo-Listen gefunden'));
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: lists.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        final list = lists[index];
        return TodoListTile(
          list: list,
          onTap: () => onTap(list),
        );
      },
    );
  }
}
