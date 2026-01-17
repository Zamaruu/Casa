import 'package:flutter/material.dart';

extension ContextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}
