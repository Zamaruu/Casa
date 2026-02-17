import 'package:casa/src/core/interfaces/utils/i_crud_util.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/core/utils/typed.util.dart';
import 'package:casa/src/features/todos/data/provider/todo_lists_provider.dart';
import 'package:casa/src/features/todos/data/repositories/todo_list.repository.dart';
import 'package:casa/src/features/todos/widgets/dialogs/todolist_edit_dialog.dart';
import 'package:casa/src/widgets/base/contextdialog.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoListUtil extends TypedUtil<ITodoList> implements ICachedCrudUtil<ITodoList> {
  TodoListUtil();

  @override
  Future<IValueResponse<ITodoList>?> create(BuildContext context, WidgetRef ref) async {
    final todoListResponse = await ContextDialog.openDialog<IValueResponse<ITodoList>>(
      context,
      ContextDialog(
        title: "Todo-Liste erstellen",
        content: const TodoListEditDialog(),
      ),
    );

    if (todoListResponse != null && context.mounted) {
      if (todoListResponse.isSuccess && todoListResponse.hasValue) {
        final todoList = todoListResponse.value!;
        CasaSnackbars.showDefaultSnackbar(message: "Todo-Liste '${todoList.name}' angelegt", context: context, type: ESnackbarType.success);

        await refresh(context, ref);
      }

      return todoListResponse;
    }

    return null;
  }

  @override
  Future<IResponse> delete(BuildContext context, WidgetRef ref, ITodoList entity) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<ITodoList>?> edit(BuildContext context, WidgetRef ref, ITodoList entity) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<IResponse> refresh(BuildContext context, WidgetRef ref) {
    return runGuarded(() async {
      ref.read(todoListRepositoryProvider).clearCache();
      ref.invalidate(todoListsProvider);

      return Response.success();
    });
  }
}
