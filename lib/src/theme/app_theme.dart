import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// App theme configuration with responsive design support
class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    // Responsive font sizes
    final displayLargeSize = isDesktop ? 120.0 : (isTablet ? 100.0 : 85.0);
    final bodyLargeSize = isDesktop ? 16.0 : (isTablet ? 14.0 : 12.0);
    final appBarTitleSize = isDesktop ? 28.0 : (isTablet ? 26.0 : 24.0);
    
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
      
      // Text theme with responsive sizes
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: displayLargeSize,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: bodyLargeSize,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: bodyLargeSize,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: 'KumarOne',
          fontSize: appBarTitleSize,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
  
  /// Static theme for cases where context is not available
  static ThemeData get staticLightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        background: AppColors.background,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
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
      ),
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

