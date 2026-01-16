import 'package:casa/src/app/theme/casa_colors.dart';
import 'package:flutter/material.dart';

final TextTheme casaTextTheme = TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: CasaColors.textPrimary,
  ),
  headlineMedium: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: CasaColors.textPrimary,
  ),
  titleLarge: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: CasaColors.textPrimary,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    color: CasaColors.textPrimary,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    color: CasaColors.textSecondary,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CasaColors.textPrimary,
  ),
);
