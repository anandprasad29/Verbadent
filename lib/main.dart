import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'utils/responsive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations for mobile/tablet
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(const VerbadentApp());
}

class VerbadentApp extends StatelessWidget {
  const VerbadentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verbadent CareQuest',
      // Use static theme initially, will be updated in HomePage
      theme: AppTheme.staticLightTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

