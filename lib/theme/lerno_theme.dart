import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lerno_colors.dart';
import 'lerno_text_styles.dart';

export 'lerno_colors.dart';
export 'lerno_text_styles.dart';

class LernoTheme {
  LernoTheme._();

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: LernoColors.scaffoldDark,
    primaryColor: LernoColors.coral,
    colorScheme: const ColorScheme.dark(
      primary: LernoColors.coral,
      secondary: LernoColors.teal,
      surface: LernoColors.cardDark,
      onPrimary: LernoColors.plumDeep,
      onSecondary: LernoColors.white,
      onSurface: LernoColors.white,
    ),
    fontFamily: 'Montserrat',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LernoColors.inputFill,
      hintStyle: LernoTextStyles.body.copyWith(
        color: LernoColors.textSecondary,
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
        const BorderSide(color: LernoColors.coral, width: 1.5),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: LernoColors.scaffoldDark,
      selectedItemColor: LernoColors.coral,
      unselectedItemColor: LernoColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      elevation: 0,
    ),
  );
}