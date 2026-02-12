import 'package:casa/src/core/interfaces/utils/i_crud_util.dart';
import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:casa/src/features/api/data/provider/apikeys_list_provider.dart';
import 'package:casa/src/features/api/data/repositories/api.repository.dart';
import 'package:casa/src/features/api/widgets/apikey_edit_dialog.dart';
import 'package:casa/src/widgets/base/contextdialog.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class ApiKeyUtil extends GuardedOperations implements ICachedCrudUtil<IApiKey> {
  const ApiKeyUtil();

  @override
  Future<void> guardedErrorCallback(String message, Object error, StackTrace stackTrace) async {
    appLog(message: message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<IResponse> refresh(BuildContext context, WidgetRef ref) async {
    return runGuarded(() async {
      ref.read(apiKeyRepositoryProvider).clearCache();
      ref.invalidate(apiKeysListProvider);

      return Response.success();
    });
  }

  @override
  Future<IValueResponse<IApiKey>?> create(BuildContext context, WidgetRef ref) async {
    final userResponse = await ContextDialog.openDialog<IValueResponse<IApiKey>>(
      context,
      ContextDialog(
        title: "API-Schlüssel erstellen",
        content: const ApiKeyEditDialog(),
      ),
    );

    if (userResponse != null && context.mounted) {
      if (userResponse.isSuccess && userResponse.hasValue) {
        final key = userResponse.value!;
        CasaSnackbars.showDefaultSnackbar(message: "API-Schlüssel '${key.name}' angelegt", context: context, type: ESnackbarType.success);

        ref.invalidate(apiKeysListProvider); // Auto-refresh of the users list
      }

      return userResponse;
    }

    return null;
  }

  @override
  Future<IValueResponse<IApiKey>?> edit(BuildContext context, WidgetRef ref, IApiKey entity) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<IResponse> delete(BuildContext context, WidgetRef ref, IApiKey entity) async {
    return runGuarded(() async {
      final response = await ref.read(apiKeyRepositoryProvider).delete(entity);

      if (context.mounted) {
        if (response.isSuccess) {
          CasaSnackbars.showDefaultSnackbar(
            context: context,
            message: "API-Schlüssel '${entity.name}' gelöscht",
            type: ESnackbarType.success,
          );

          await refresh(context, ref);
        } else {
          CasaSnackbars.showDefaultSnackbar(
            context: context,
            message: "Fehler beim Löschen des API-Schlüssel '${entity.name}'",
            type: ESnackbarType.error,
          );
        }
      }

      return response;
    });
  }
}
