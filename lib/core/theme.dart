import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGold = Color(0xFFF6C453);
  static const Color darkBackground = Color(0xFF050B1B);
  static const Color secondaryDark = Color(0xFF0D1630);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFB8B8B8);
  static const Color borderColor = Color(0xFF2A3552);
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
      fillColor: Colors.white.withOpacity(0.04),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: AppColors.borderColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: AppColors.borderColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: AppColors.primaryGold,
          width: 1.2,
        ),
      ),
    ),
  );
}