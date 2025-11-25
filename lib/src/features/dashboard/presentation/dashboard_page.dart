import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_shell.dart';

/// Main dashboard page displaying the VERBADENT title.
/// The title scales to fit the available width to handle landscape orientation.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= AppConstants.sidebarBreakpoint;
    
    // Calculate available content width (accounting for sidebar on wide screens)
    final contentWidth = isWideScreen 
        ? screenWidth - AppConstants.sidebarWidth 
        : screenWidth;

    return AppShell(
      showLanguageSelector: false,
      child: Container(
        key: const Key('dashboard_content'),
        color: context.appBackground,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'VERBADENT',
                style: TextStyle(
                  fontFamily: 'KumarOne',
                  // Use larger base size, FittedBox will scale down if needed
                  fontSize: _calculateFontSize(contentWidth),
                  fontWeight: FontWeight.bold,
                  color: context.appTextTitle,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Calculate optimal font size based on available content width.
  /// Returns a size that should fit well, with FittedBox handling edge cases.
  double _calculateFontSize(double contentWidth) {
    // Target: text should be about 70% of content width
    // VERBADENT has 9 characters, Kumar One is a wide font
    // Approximate character width ratio for Kumar One: ~0.7
    const charCount = 9;
    const charWidthRatio = 0.7;
    
    // Calculate font size that would fill ~70% of width
    final targetWidth = contentWidth * 0.7;
    final calculatedSize = targetWidth / (charCount * charWidthRatio);
    
    // Clamp between min and max reasonable sizes
    return calculatedSize.clamp(
      AppConstants.titleFontSizeMobile,
      AppConstants.titleFontSizeDesktop,
    );
  }
}
