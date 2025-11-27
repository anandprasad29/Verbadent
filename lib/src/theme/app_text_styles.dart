import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_constants.dart';

/// Centralized text styles for the application.
/// Use these instead of inline TextStyle definitions.
class AppTextStyles {
  // Main title style (VERBADENT)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'KumarOne',
    fontSize: AppConstants.titleFontSizeDesktop,
    fontWeight: FontWeight.bold,
    color: AppColors.textTitle,
  );

  static const TextStyle titleMobile = TextStyle(
    fontFamily: 'KumarOne',
    fontSize: AppConstants.titleFontSizeMobile,
    fontWeight: FontWeight.bold,
    color: AppColors.textTitle,
  );

  // Page header style (Library, Before Visit, etc.)
  static const TextStyle pageHeader = TextStyle(
    fontFamily: 'KumarOne',
    fontSize: AppConstants.headerFontSize,
    color: AppColors.textPrimary,
  );

  // Sidebar item text style
  static const TextStyle sidebarItem = TextStyle(
    fontFamily: 'KumarOne',
    fontSize: AppConstants.sidebarItemFontSize,
    fontWeight: FontWeight.bold,
    color: AppColors.sidebarItemText,
  );

  // Active sidebar item text style
  static const TextStyle sidebarItemActive = TextStyle(
    fontFamily: 'KumarOne',
    fontSize: AppConstants.sidebarItemFontSize,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Caption text style (below images)
  static const TextStyle caption = TextStyle(
    fontFamily: 'InstrumentSans',
    fontWeight: FontWeight.bold,
    fontSize: AppConstants.captionFontSize,
    color: AppColors.textSecondary,
  );

  // Body text style
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'KumarOne',
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  // Private constructor to prevent instantiation
  AppTextStyles._();
}




