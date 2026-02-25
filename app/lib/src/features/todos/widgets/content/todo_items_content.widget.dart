import 'package:casa/src/features/todos/widgets/tiles/todo_item_tile.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class TodoItemsContent extends StatelessWidget {
  final List<ITodo> items;
  final void Function(ITodo item) onTap;
  final void Function(ITodo item)? onMarkDone;
  final bool Function(ITodo item)? isMarkDoneLoading;

  const TodoItemsContent({
    super.key,
    required this.items,
    required this.onTap,
    this.onMarkDone,
    this.isMarkDoneLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: CasaText('Keine Todo-Items gefunden'));
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        final item = items[index];
        return TodoItemTile(
          item: item,
          onTap: () => onTap(item),
          onMarkDone: onMarkDone != null ? () => onMarkDone!(item) : null,
          markDoneLoading: isMarkDoneLoading?.call(item) ?? false,
        );
      },
    );
  }
}
