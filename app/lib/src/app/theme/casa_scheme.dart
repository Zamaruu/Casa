import 'package:casa/src/app/theme/casa_colors.dart';
import 'package:flutter/material.dart';

final ColorScheme casaColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: CasaColors.primary,
  onPrimary: Colors.white,

  primaryContainer: CasaColors.primaryDark,
  onPrimaryContainer: Colors.white,

  secondary: CasaColors.secondary,
  onSecondary: CasaColors.textPrimary,

  surface: CasaColors.background,
  onSurface: CasaColors.textPrimary,

  error: CasaColors.error,
  onError: Colors.white,
);
