import 'package:casa/src/core/utils/util.dart';
import 'package:casa/src/widgets/base/contextdialog.widget.dart';
import 'package:casa/src/widgets/base/panel.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

abstract class TypedUtil<T extends IEntity> extends Util {
  const TypedUtil();

  // region Dialog-Helper

  /// Returns true if the user wants to delete the entity.
  Future<bool> showDeleteDialog(BuildContext context, WidgetRef ref, T entity, {String? entityLabel}) async {
    final shouldDelete = await ContextDialog.open<bool>(
      context,
      ContextDialog(
        title: "Löschen",
        content: CasaText("Möchtest du '${entityLabel ?? entity.runtimeType}' wirklich löschen?"),
        actionsBuilder: (context, ref) {
          return [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Abbrechen"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Löschen"),
            ),
          ];
        },
      ),
    );

    if (shouldDelete == null) {
      return false;
    } else {
      return shouldDelete;
    }
  }

  Future<IValueResponse<T>?> showEditPanel({required BuildContext context, required Widget child, String? title}) async {
    final createResponse = await showPanel<IValueResponse<T>>(
      context: context,
      title: title,
      contentPadding: EdgeInsets.all(24),
      enableTopPadding: true,
      child: child,
    );

    return createResponse;
  }

  // endregion
}
