import 'package:flutter/material.dart';

/// Responsive breakpoints and utilities
class Responsive {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if the screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if the screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if the screen is desktop/web
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Get responsive width based on screen size
  static double getResponsiveWidth(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context) && mobile != null) {
      return mobile;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    return MediaQuery.of(context).size.width;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isMobile(context) && mobile != null) {
      return mobile;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    return const EdgeInsets.all(16.0);
  }

  /// Get responsive font size based on screen size
  static double getResponsiveFontSize(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context) && mobile != null) {
      return mobile;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    return 16.0;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
}

