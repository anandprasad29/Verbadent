import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:verbadent/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify app launches and displays title', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that "VERBADENT" is shown on screen
      expect(find.text('VERBADENT'), findsOneWidget);
    });
  });
}
