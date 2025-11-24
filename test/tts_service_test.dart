import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbadent/src/features/library/services/tts_service.dart';

void main() {
  // Ensure Flutter bindings are initialized for platform channel tests
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the platform channel for flutter_tts
  const MethodChannel channel = MethodChannel('flutter_tts');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'speak':
          return 1; // Success
        case 'stop':
          return 1; // Success
        case 'setLanguage':
          return 1;
        case 'setSpeechRate':
          return 1;
        case 'setVolume':
          return 1;
        case 'setPitch':
          return 1;
        case 'awaitSpeakCompletion':
          return 1;
        case 'getLanguages':
          return ['en-US'];
        case 'getVoices':
          return [];
        case 'isLanguageAvailable':
          return 1;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('TtsService', () {
    late TtsService ttsService;

    setUp(() {
      ttsService = TtsService();
    });

    tearDown(() {
      ttsService.dispose();
    });

    test('creates instance successfully', () {
      expect(ttsService, isNotNull);
    });

    test('init completes without error', () async {
      await expectLater(ttsService.init(), completes);
    });

    test('init is idempotent (can be called multiple times)', () async {
      await ttsService.init();
      await expectLater(ttsService.init(), completes);
    });

    test('speak initializes if not already initialized', () async {
      await expectLater(ttsService.speak('Hello'), completes);
    });

    test('speak accepts non-empty string', () async {
      await expectLater(ttsService.speak('Test message'), completes);
    });

    test('speak accepts empty string', () async {
      await expectLater(ttsService.speak(''), completes);
    });

    test('stop completes without error', () async {
      await expectLater(ttsService.stop(), completes);
    });

    test('dispose can be called safely', () {
      expect(() => ttsService.dispose(), returnsNormally);
    });

    test('speak works after init', () async {
      await ttsService.init();
      await expectLater(ttsService.speak('After init'), completes);
    });

    test('stop can be called even if not speaking', () async {
      await ttsService.init();
      await expectLater(ttsService.stop(), completes);
    });

    test('speak handles long text', () async {
      final longText = 'This is a very long text. ' * 50;
      await expectLater(ttsService.speak(longText), completes);
    });

    test('speak handles special characters', () async {
      await expectLater(
        ttsService.speak("The dentist's chair & equipment!"),
        completes,
      );
    });

    test('multiple speak calls work', () async {
      await ttsService.speak('First');
      await expectLater(ttsService.speak('Second'), completes);
    });
  });

  group('TtsService Provider', () {
    test('TtsService can be instantiated', () {
      final service = TtsService();
      expect(service, isA<TtsService>());
      service.dispose();
    });
  });
}
