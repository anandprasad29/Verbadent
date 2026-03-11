import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final screenshotDir = Platform.environment['SCREENSHOT_DIR'] ??
      'build/screenshots';

  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
      final file = File('$screenshotDir/$name.png');
      file.createSync(recursive: true);
      file.writeAsBytesSync(bytes);
      print('Screenshot saved: ${file.path}');
      return true;
    },
  );
}
