import 'package:flutter/material.dart';

enum ESnackbarType {
  info(Icons.info_outline, Colors.blue),
  success(Icons.check_circle, Colors.green),
  warning(Icons.warning_amber_rounded, Colors.amber),
  error(Icons.error_outline, Colors.red);

  final IconData icon;

  final Color color;

  const ESnackbarType(this.icon, this.color);
}
