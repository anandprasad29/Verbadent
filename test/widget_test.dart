// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verbident/app.dart';

void main() {
  setUpAll(() {
    // Initialize SharedPreferences mock for tests
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: VerbidentApp()));

    // Wait for the router to navigate and any splash screen/TTS timers to complete
    // The TTS service has a 3-second configuration timeout, so we need to wait longer
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify that the dashboard title is present
    expect(find.text('VERBIDENT'), findsOneWidget);

    // Pump additional frames to ensure all pending timers complete
    await tester.pump(const Duration(seconds: 2));
  });
}
