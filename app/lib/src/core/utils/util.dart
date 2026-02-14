import 'package:casa/src/core/interfaces/utils/i_util.dart';
import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/widgets/base/panel.widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:shared/shared.dart';

abstract class Util extends GuardedOperations implements IUtil {
  final PanelController panelController;

  // region Constructors

  Util({
    PanelController? panelController,
  }) : panelController = panelController ?? PanelController();

  // endregion

  @override
  void dispose() {
    panelController.dispose();
  }

  @override
  Future<void> guardedErrorCallback(String message, Object error, StackTrace stackTrace) async {
    appLog(message: message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<String> loadMarkdownAsset(String assetPath) async {
    return runCustomGuarded(
      () async => rootBundle.loadString(assetPath),
      onError: (message, error, stackTrace) {
        return '# Fehler\\n\\nDie Hilfe-Datei konnte nicht geladen werden.\\n\\n$assetPath';
      },
      operationErrorMessage: 'Error while loading markdown asset $assetPath',
    );
  }

  @override
  Future<void> openHelpFromAsset({
    required BuildContext context,
    String? title,
    EPanelSize size = EPanelSize.medium,
    required String assetPath,
  }) async {
    final markdown = await loadMarkdownAsset(assetPath);

    if (!context.mounted) return;

    panelController.show(
      context,
      title: title,
      size: size,
      child: MarkdownBody(data: markdown),
    );
  }
}
