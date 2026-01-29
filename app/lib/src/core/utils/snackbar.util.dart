import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_platform/universal_platform.dart';

abstract class CasaSnackbars {
  static void showDefaultSnackbar({
    required String message,
    required BuildContext context,
    ESnackbarType type = ESnackbarType.info,
    Duration autoCloseAfter = const Duration(milliseconds: 3500),
  }) {
    final isMobile = UniversalPlatform.isMobile;

    toastification.show(
      context: context,
      icon: Icon(type.icon),
      title: Text(message),
      showProgressBar: true,
      autoCloseDuration: autoCloseAfter,
      primaryColor: type.color,
      alignment: isMobile ? Alignment.bottomCenter : Alignment.topRight,
    );
  }
}
