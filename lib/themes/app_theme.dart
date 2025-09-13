import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightText,
      error: AppColors.error,
      onError: Colors.white,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkText,
      error: AppColors.error,
      onError: Colors.white,
    ),
  );
}
