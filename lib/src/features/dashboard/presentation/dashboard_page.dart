import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/responsive.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use responsive theme
    final theme = AppTheme.lightTheme(context);
    
    return Theme(
      data: theme,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: Responsive.getResponsivePadding(
                context,
                mobile: const EdgeInsets.all(16.0),
                tablet: const EdgeInsets.all(32.0),
                desktop: const EdgeInsets.all(48.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'VERBADENT',
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Show device type for debugging (remove in production)
                  if (Responsive.isMobile(context))
                    Text(
                      'Mobile View',
                      style: theme.textTheme.bodyLarge,
                    )
                  else if (Responsive.isTablet(context))
                    Text(
                      'Tablet View',
                      style: theme.textTheme.bodyLarge,
                    )
                  else
                    Text(
                      'Desktop/Web View',
                      style: theme.textTheme.bodyLarge,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

