import 'package:casa/src/app/theme/casa_colors.dart';
import 'package:casa/src/app/theme/casa_scheme.dart';
import 'package:casa/src/app/theme/casa_text_theme.dart';
import 'package:flutter/material.dart';

class CasaTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: casaColorScheme,
      textTheme: casaTextTheme,

      scaffoldBackgroundColor: CasaColors.background,

      appBarTheme: AppBarTheme(
        backgroundColor: CasaColors.surface,
        foregroundColor: CasaColors.textPrimary,
        elevation: 0,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CasaColors.primary,
        foregroundColor: Colors.white,
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(CasaColors.primary),
        ),
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: CasaColors.surface,
        selectedIconTheme: const IconThemeData(color: CasaColors.primary),
        unselectedIconTheme: const IconThemeData(color: CasaColors.textSecondary),
        selectedLabelTextStyle: const TextStyle(color: CasaColors.primary),
        unselectedLabelTextStyle: const TextStyle(color: CasaColors.textSecondary),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: CasaColors.surface,
      ),

      cardTheme: CardThemeData(
        color: CasaColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
