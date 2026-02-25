import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/features/todos/data/provider/todo_lists_provider.dart';
import 'package:casa/src/features/todos/data/utils/todolist.util.dart';
import 'package:casa/src/features/todos/widgets/content/todo_lists_content.widget.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodosRoute extends ConsumerStatefulWidget {
  const TodosRoute({super.key});

  @override
  ConsumerState<TodosRoute> createState() => _TodosRouteState();
}

class _TodosRouteState extends ConsumerState<TodosRoute> {
  late final IMenu menu;

  late final TodoListUtil todoListUtil;

  @override
  void initState() {
    super.initState();
    menu = setupMenu();
    todoListUtil = TodoListUtil();
  }

  IMenu setupMenu() {
    return Menu(
      mainItems: [
        MenuItem(
          title: 'Neue Liste',
          icon: Icons.add,
          onTap: () => todoListUtil.create(context, ref),
        ),
        MenuItem(
          title: 'Aktualisieren',
          icon: Icons.refresh,
          onTap: () => ref.invalidate(todoListsProvider),
        ),
        MenuItem(
          title: 'Liste löschen',
          icon: Icons.delete_outline,
          onTap: () => todoListUtil.deleteFromMenubar(context, ref),
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

  @override
  Widget build(BuildContext context) {
    return CasaScaffold<IValueResponse<List<ITodoList>>>.future(
      title: 'Todos',
      menu: menu,
      future: ref.watch(todoListsProvider.future),
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final lists = response.value!;

          return TodoListsContent(
            lists: lists,
            onTap: (list) => CasaNavigator.go(context, '/todos/${list.id}'),
          );
        }

        return const Center(
          child: CasaText('Fehler beim Laden der Todo-Listen'),
        );
      },
    );
  }
}
