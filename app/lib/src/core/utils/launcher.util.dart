import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:casa/src/core/utils/logger.util.dart';
import 'package:casa/src/core/utils/snackbar.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LauncherUtil {
  const LauncherUtil();

  void launchWebsite({required BuildContext context, required String url}) async {
    try {
      final canLaunch = await canLaunchUrlString(url);

      if (canLaunch) {
        await launchUrlString(url);
      } else {
        final message = "Could not launch website: $url.";

        appLog(message: message);

        if (context.mounted) {
          CasaSnackbars.showDefaultSnackbar(
            context: context,
            message: message,
            type: ESnackbarType.warning,
          );
        }
      }
    } catch (e, st) {
      final message = "Unexpected error while launching website: $url.";

      appLog(message: message, error: e, stackTrace: st);

      if (context.mounted) {
        CasaSnackbars.showDefaultSnackbar(
          context: context,
          message: message,
          type: ESnackbarType.error,
        );
      }
    }
  }
}
