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
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Screenshot 1: Dashboard
      await binding.takeScreenshot('01_Dashboard');

      // Helper to navigate via sidebar or drawer
      Future<void> navigateToItem(String testKey) async {
        // Try to find the item directly (wide screen with sidebar)
        var item = find.byKey(Key(testKey));
        if (item.evaluate().isEmpty) {
          // On phone layout, open the drawer first
          final scaffoldState = tester.firstState<ScaffoldState>(
            find.byType(Scaffold),
          );
          scaffoldState.openDrawer();
          await tester.pumpAndSettle(const Duration(seconds: 1));
          item = find.byKey(Key(testKey));
        }
        if (item.evaluate().isNotEmpty) {
          await tester.tap(item);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }

      // Screenshot 2: Before the Visit
      await navigateToItem('sidebar_item_before_visit');
      await binding.takeScreenshot('02_BeforeVisit');

      // Screenshot 3: During the Visit
      await navigateToItem('sidebar_item_during_visit');
      await binding.takeScreenshot('03_DuringVisit');

      // Screenshot 4: Library
      await navigateToItem('sidebar_item_library');
      await binding.takeScreenshot('04_Library');

      // Screenshot 5: Build Your Own
      await navigateToItem('sidebar_item_build_own');
      await binding.takeScreenshot('05_BuildYourOwn');
    });
  });
}
