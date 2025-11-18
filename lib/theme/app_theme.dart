import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        background: AppColors.background,
        surface: AppColors.background,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: AppColors.background,
      
      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: 85,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: 12,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: 12,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: 24,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

