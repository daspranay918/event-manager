import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGold = Color(0xFFF6C453);
  static const Color darkBackground = Color(0xFF090909);
  static const Color secondaryDark = Color(0xFF0D1630);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFB8B8B8);
  static const Color borderColor = Color(0xFF2A3552);
  static const Color cardBackground = Color(0xFF111111);
  static const Color gold = Color(0xFFF6C453);
  static const Color divider = Color(0xFF2C2C2C);
  static const Color success = Color(0xFF30D158);
  static const Color danger = Color(0xFFFF453A);
  static const Color blue = Color(0xFF3A86FF);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFFF9F0A);
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryGold,
      surface: AppColors.darkBackground,
    ),

    fontFamily: 'Poppins',

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha:0.04),

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
      ),
    ),
  );
}
