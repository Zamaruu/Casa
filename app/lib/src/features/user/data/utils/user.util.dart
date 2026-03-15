import 'package:casa/src/core/interfaces/utils/i_crud_util.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/core/utils/typed.util.dart';
import 'package:casa/src/features/user/data/provider/users_list_provider.dart';
import 'package:casa/src/features/user/data/repositories/user.repository.dart';
import 'package:casa/src/features/user/widgets/user_edit_dialog.dart';
import 'package:casa/src/widgets/base/contextdialog.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class UserUtil extends TypedUtil<IUser> implements ICachedCrudUtil<IUser> {
  UserUtil();

  @override
  Future<IValueResponse<IUser>?> create(BuildContext context, WidgetRef ref) async {
    final userResponse = await ContextDialog.open<IValueResponse<IUser>>(
      context,
      ContextDialog(
        title: "Benutzer erstellen",
        content: const UserEditDialog(),
      ),
    );

    if (userResponse != null && context.mounted) {
      if (userResponse.isSuccess && userResponse.hasValue) {
        final user = userResponse.value!;
        CasaSnackbars.showDefaultSnackbar(message: "Benutzer '${user.username}' angelegt", context: context, type: ESnackbarType.success);

        ref.invalidate(usersListProvider); // Auto-refresh of the users list
      }

      return userResponse;
    }

    return null;
  }

  @override
  Future<IValueResponse<IUser>?> edit(BuildContext context, WidgetRef ref, IUser entity) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<IResponse> delete(BuildContext context, WidgetRef ref, IUser entity) {
    return runGuarded(() async {
      final shouldDelete = await showDeleteDialog(
        context,
        ref,
        entity,
        entityLabel: entity.username,
      );

      if (shouldDelete == false) {
        return Response.skipped();
      }

      final response = await ref.read(userRepositoryProvider).delete(entity);

      if (context.mounted) {
        if (response.isSuccess) {
          CasaSnackbars.showDefaultSnackbar(
            context: context,
            message: "Benutzer '${entity.username}' gelöscht",
            type: ESnackbarType.success,
          );

          await refresh(context, ref);
        } else {
          CasaSnackbars.showDefaultSnackbar(
            context: context,
            message: "Fehler beim Löschen des Benutzer '${entity.username}'",
            type: ESnackbarType.error,
          );
        }
      }

      return response;
    });
  }

  @override
  Future<IResponse> refresh(BuildContext context, WidgetRef ref) {
    return runGuarded(() async {
      ref.read(userRepositoryProvider).clearCache();
      ref.invalidate(usersListProvider);

      return Response.success();
    });
  }
}
