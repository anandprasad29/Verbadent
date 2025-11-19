import 'package:flutter/material.dart';
import 'src/features/dashboard/presentation/dashboard_page.dart';
import 'src/theme/app_theme.dart';

class VerbadentApp extends StatelessWidget {
  const VerbadentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verbadent CareQuest',
      // Use static theme initially, will be updated in HomePage
      theme: AppTheme.staticLightTheme,
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
