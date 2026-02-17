import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/features/todos/data/provider/todo_items_provider.dart';
import 'package:casa/src/features/todos/data/utils/todo.util.dart';
import 'package:casa/src/features/todos/widgets/dialogs/todo_detail.dialog.dart';
import 'package:casa/src/features/todos/widgets/content/todo_items_content.widget.dart';
import 'package:casa/src/widgets/base/panel.widget.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoListRoute extends ConsumerStatefulWidget {
  final String listId;

  const TodoListRoute({super.key, required this.listId});

  @override
  ConsumerState<TodoListRoute> createState() => _TodoListRouteState();
}

class _TodoListRouteState extends ConsumerState<TodoListRoute> {
  late final IMenu menu;

  late final TodoUtil todoUtils;

  @override
  void initState() {
    super.initState();
    menu = setupMenu();
    todoUtils = const TodoUtil();
  }

  IMenu setupMenu() {
    return Menu(
      mainItems: [
        MenuItem(
          title: 'Neues Item',
          icon: Icons.add_task,
          onTap: () => todoUtils.create(context, ref, listId: widget.listId),
        ),
        MenuItem(
          title: 'Aktualisieren',
          icon: Icons.refresh,
          onTap: () => ref.invalidate(todoItemsByListProvider(widget.listId)),
        ),
      ],
      farItems: [
        MenuItem.icon(
          icon: Icons.search,
          onTap: () {},
        ),
      ],
    );
  }

  void showTodoDetails(ITodo todo) {
    showPanel(
      title: todo.title,
      context: context,
      size: EPanelSize.medium,
      enableTopPadding: true,
      child: TodoDetailDialog(
        listId: todo.listId,
        itemId: todo.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CasaScaffold<IValueResponse<List<ITodo>>>.future(
      title: 'Todo-Liste',
      menu: menu,
      future: ref.watch(todoItemsByListProvider(widget.listId).future),
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final items = response.value!;

          return TodoItemsContent(
            items: items,
            onTap: (item) => showTodoDetails(item),
          );
        }

        return Center(child: CasaText('Fehler beim Laden der Todo-Items für ${widget.listId}'));
      },
    );
  }
}
