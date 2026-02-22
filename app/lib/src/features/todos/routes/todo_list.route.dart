import 'package:casa/src/core/extensions/list.extensions.dart';
import 'package:casa/src/core/interfaces/widgets/i_menu_widget.dart';
import 'package:casa/src/core/interfaces/widgets/i_routable_widget.dart';
import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/core/router/casa_navigator.dart';
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

  final String? openItemId;

  const TodoListRoute({
    super.key,
    required this.listId,
    this.openItemId,
  });

  @override
  ConsumerState<TodoListRoute> createState() => _TodoListRouteState();
}

class _TodoListRouteState extends ConsumerState<TodoListRoute>
    implements IMenuWidget, IRoutableWidget<ITodo> {
  late final IMenu menu;

  late final TodoUtil todoUtils;
  late final String? _initialOpenItemId;
  bool _hasHandledInitialQueryOpen = false;

  @override
  void initState() {
    super.initState();
    menu = setupMenu();
    todoUtils = const TodoUtil();
    _initialOpenItemId = widget.openItemId;
  }

  // region Methods

  @override
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

  @override
  void openItemNavigate(BuildContext context, WidgetRef ref, ITodo? item) {
    if (item != null) {
      showTodoDetails(item);
    }
  }

  void _openInitialQueryItemOnce(List<ITodo> items) {
    if (_hasHandledInitialQueryOpen) {
      return;
    }

    _hasHandledInitialQueryOpen = true;
    final itemId = _initialOpenItemId;
    if (itemId == null) {
      return;
    }

    final item = items.firstWhereOrNull((todo) => todo.id == itemId);
    if (item == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      showTodoDetails(item);
    });
  }

  void showTodoDetails(ITodo todo) {
    CasaNavigator.go(context, '/todos/${todo.listId}?itemId=${todo.id}');

    showPanel(
      title: todo.title,
      context: context,
      size: EPanelSize.medium,
      enableTopPadding: true,
      onClose: () => CasaNavigator.removeQuery(context),
      child: TodoDetailDialog(
        listId: todo.listId,
        itemId: todo.id,
      ),
    );
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return CasaScaffold<IValueResponse<List<ITodo>>>.future(
      title: 'Todo-Liste',
      menu: menu,
      future: ref.watch(todoItemsByListProvider(widget.listId).future),
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final items = response.value!;
          _openInitialQueryItemOnce(items);

          return TodoItemsContent(
            items: items,
            onTap: (item) => showTodoDetails(item),
          );
        }

        return Center(
          child: CasaText(
            'Fehler beim Laden der Todo-Items für ${widget.listId}',
          ),
        );
      },
    );
  }
}
