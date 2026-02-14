import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:flutter/cupertino.dart';

abstract interface class IUtil {
  /// Loads markdown content from a configured Flutter asset path.
  Future<String> loadMarkdownAsset(String assetPath);

  /// Loads markdown from [assetPath] and opens it in the help panel.
  Future<void> openHelpFromAsset({
    required BuildContext context,
    String? title,
    EPanelSize size = EPanelSize.medium,
    required String assetPath,
  });

  void dispose();
}
