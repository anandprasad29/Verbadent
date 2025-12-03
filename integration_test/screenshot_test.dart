import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:verbident/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Store Screenshots', () {
    testWidgets('Capture all screens for App Store', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Screenshot 1: Dashboard
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await binding.takeScreenshot('01_Dashboard');
      
      // Navigate to Before the Visit
      final beforeVisitButton = find.text('Before the Visit');
      if (beforeVisitButton.evaluate().isNotEmpty) {
        await tester.tap(beforeVisitButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await binding.takeScreenshot('02_BeforeVisit');
      }
      
      // Navigate to Library
      final libraryButton = find.text('Library');
      if (libraryButton.evaluate().isNotEmpty) {
        await tester.tap(libraryButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await binding.takeScreenshot('03_Library');
      }
      
      // Navigate to Build Your Own (if exists)
      final buildButton = find.text('Build Your Own');
      if (buildButton.evaluate().isNotEmpty) {
        await tester.tap(buildButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await binding.takeScreenshot('04_BuildYourOwn');
      }
      
      // Return to Dashboard
      final dashboardButton = find.text('Dashboard');
      if (dashboardButton.evaluate().isNotEmpty) {
        await tester.tap(dashboardButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
    });
  });
}
