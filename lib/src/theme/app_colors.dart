import 'package:flutter/material.dart';

/// App color constants based on Figma design.
/// Centralized color definitions for consistent theming.
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF5483F5); // Blue for sidebar and accents
  static const Color primaryDark = Color(0xFF4284F3); // Darker blue variant
  
  // Background colors
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFFFFFFF); // White surface
  
  // Text colors
  static const Color textPrimary = Color(0xFF0A2D6D); // Dark blue for headers
  static const Color textTitle = Color(0xFF1B2B57); // Navy for main titles
  static const Color textSecondary = Color(0xFF000000); // Black for body text
  
  // Sidebar colors
  static const Color sidebarBackground = Color(0xFF5483F5); // Blue sidebar
  static const Color sidebarItemBackground = Color(0xFFD9D9D9); // Gray buttons
  static const Color sidebarItemActive = Color(0xFFFFFFFF); // White for active
  static const Color sidebarItemText = Color(0xFF000000); // Black text
  
  // Card colors
  static const Color cardBorder = Color(0xFF5483F5); // Blue border
  static const Color cardBackground = Color(0xFFFFFFFF); // White background
  
  // Neutral colors
  static const Color neutral = Color(0xFFD9D9D9); // Light gray
  static const Color divider = Color(0xFFE0E0E0); // Divider gray
  
  // Private constructor to prevent instantiation
  AppColors._();
}
