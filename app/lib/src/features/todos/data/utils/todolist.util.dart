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
  Future<IValueResponse<ITodoList>?> create(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final todoListResponse = await ContextDialog.open<IValueResponse<ITodoList>>(
      context,
      ContextDialog(
        title: "Todo-Liste erstellen",
        content: const TodoListEditDialog(),
      ),
    );

    if (todoListResponse != null && context.mounted) {
      if (todoListResponse.isSuccess && todoListResponse.hasValue) {
        final todoList = todoListResponse.value!;
        CasaSnackbars.showDefaultSnackbar(
          message: "Todo-Liste '${todoList.name}' angelegt",
          context: context,
          type: ESnackbarType.success,
        );

        await refresh(context, ref);
      }

      return todoListResponse;
    }

    return null;
  }

  @override
  Future<IResponse> delete(
    BuildContext context,
    WidgetRef ref,
    ITodoList entity,
  ) {
    return runGuarded(() async {
      final shouldDelete = await showDeleteDialog(
        context,
        ref,
        entity,
        entityLabel: entity.name,
      );

      if (!shouldDelete || !context.mounted) {
        return Response.success();
      } else {
        final repo = ref.read(todoListRepositoryProvider);

        final initialDeleteResponse = await repo.deleteWithTodoAction(entity.id);

        if (initialDeleteResponse.isSuccess) {
          CasaSnackbars.showDefaultSnackbar(
            message: "Todo-Liste '${entity.name}' gelöscht",
            context: context,
            type: ESnackbarType.success,
          );
          await refresh(context, ref);
          return Response.success();
        }

        final needsTodoAction = initialDeleteResponse.httpStatus == EHttpStatus.badRequest;
        if (!needsTodoAction) {
          CasaSnackbars.showDefaultSnackbar(
            message: initialDeleteResponse.message ?? "Fehler beim Löschen der Todo-Liste",
            context: context,
            type: ESnackbarType.error,
          );
          return Response.failure(
            message: initialDeleteResponse.message ?? 'Delete failed',
          );
        }

        final todoAction = await _showTodoDeleteActionDialog(
          context,
          entity.name,
        );
        if (todoAction == null || !context.mounted) {
          return Response.success();
        }

        final resolvedDeleteResponse = await repo.deleteWithTodoAction(
          entity.id,
          todoAction: todoAction,
        );

        if (resolvedDeleteResponse.isSuccess) {
          CasaSnackbars.showDefaultSnackbar(
            message: "Todo-Liste '${entity.name}' gelöscht",
            context: context,
            type: ESnackbarType.success,
          );
          await refresh(context, ref);
          return Response.success();
        }

        CasaSnackbars.showDefaultSnackbar(
          message: resolvedDeleteResponse.message ?? "Fehler beim Löschen der Todo-Liste",
          context: context,
          type: ESnackbarType.error,
        );
        return Response.failure(
          message: resolvedDeleteResponse.message ?? 'Delete failed',
        );
      }
    });
  }

  @override
  Future<IValueResponse<ITodoList>?> edit(
    BuildContext context,
    WidgetRef ref,
    ITodoList entity,
  ) {
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

  Future<void> deleteFromMenubar(BuildContext context, WidgetRef ref) async {
    final listsResponse = await ref.read(todoListsProvider.future);
    if (!context.mounted) return;

    final lists = listsResponse.value ?? const <ITodoList>[];
    if (lists.isEmpty) {
      CasaSnackbars.showDefaultSnackbar(
        message: 'Keine Todo-Listen zum Löschen vorhanden',
        context: context,
        type: ESnackbarType.info,
      );
      return;
    }

    final selectedList = await _showTodoListSelectionDialog(context, lists);
    if (!context.mounted || selectedList == null) {
      return;
    }

    await delete(context, ref, selectedList);
  }

  Future<ITodoList?> _showTodoListSelectionDialog(
    BuildContext context,
    List<ITodoList> lists,
  ) {
    return ContextDialog.open<ITodoList>(
      context,
      ContextDialog(
        title: 'Todo-Liste auswählen',
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: lists
                  .map(
                    (list) => ListTile(
                      title: Text(list.name),
                      subtitle: list.description.isNotEmpty ? Text(list.description) : null,
                      onTap: () => Navigator.of(context).pop(list),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _showTodoDeleteActionDialog(
    BuildContext context,
    String listName,
  ) {
    return ContextDialog.open<String>(
      context,
      ContextDialog(
        title: 'Liste enthält Todos',
        content: Text(
          "Die Liste '$listName' enthält noch Todos. "
          'Sollen diese gelöscht oder von der Liste gelöst werden?',
        ),
        actionsBuilder: (context, ref) {
          return [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('detach'),
              child: Text('Todos lösen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('delete'),
              child: Text('Todos löschen'),
            ),
          ];
        },
      ),
    );
  }
}
