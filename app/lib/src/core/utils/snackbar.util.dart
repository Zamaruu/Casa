import 'package:casa/src/core/models/enums/e_snackbar_type.dart';
import 'package:flutter/material.dart';

abstract class CasaSnackbars {
  static void showDefaultSnackbar({
    required String message,
    required BuildContext context,
    ESnackbarType type = ESnackbarType.info,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(type.icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: type.color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
