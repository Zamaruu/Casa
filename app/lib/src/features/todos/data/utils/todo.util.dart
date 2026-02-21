import 'package:casa/src/core/interfaces/utils/i_crud_util.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/core/utils/typed.util.dart';
import 'package:casa/src/features/todos/data/provider/todo_lists_provider.dart';
import 'package:casa/src/features/todos/data/repositories/todo_list.repository.dart';
import 'package:casa/src/features/todos/widgets/dialogs/todo_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TodoUtil extends TypedUtil<ITodo> implements ICachedCrudUtil<ITodo> {
  const TodoUtil();

  @override
  Future<IValueResponse<ITodo>?> create(BuildContext context, WidgetRef ref, {String? listId}) async {
    if (listId == null) {
      CasaSnackbars.showDefaultSnackbar(
        message: "Ungültige Listen-ID",
        context: context,
        type: ESnackbarType.success,
      );

      return null;
    }

    final createResponse = await showEditPanel(
      context: context,
      title: 'Neues Todo',
      child: TodoEditDialog(todoListId: listId),
    );

    if (createResponse != null && context.mounted) {
      if (createResponse.isSuccess && createResponse.hasValue) {
        final entity = createResponse.value!;
        CasaSnackbars.showDefaultSnackbar(message: "Todo '${entity.title}' angelegt", context: context, type: ESnackbarType.success);

        await refresh(context, ref);
      }

      return createResponse;
    }

    return null;
  }

  @override
  Future<IResponse> delete(BuildContext context, WidgetRef ref, ITodo entity) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<IValueResponse<ITodo>?> edit(BuildContext context, WidgetRef ref, ITodo entity) async {
    return runGuardedNullableValue(() async {
      final editResponse = await showEditPanel(
        context: context,
        title: 'Todo bearbeiten',
        child: TodoEditDialog(todo: entity, todoListId: entity.listId),
      );

      return editResponse;
    });
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
