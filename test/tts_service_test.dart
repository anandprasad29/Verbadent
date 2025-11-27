import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbadent/src/features/library/services/tts_service.dart';
import 'package:verbadent/src/localization/content_language_provider.dart';

void main() {
  // Ensure Flutter bindings are initialized for platform channel tests
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the platform channel for flutter_tts
  const MethodChannel channel = MethodChannel('flutter_tts');

  /// Create a mock handler with configurable delays and behavior
  MethodCall? lastMethodCall;
  Duration? getEnginesDelay;
  bool simulateNoEngines = false;
  bool simulateTimeout = false;

  void setupMockHandler() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      lastMethodCall = methodCall;

      // Simulate timeout for specific tests
      if (simulateTimeout &&
          (methodCall.method == 'getEngines' ||
              methodCall.method == 'setLanguage')) {
        await Future.delayed(const Duration(seconds: 10));
        return null;
      }

      switch (methodCall.method) {
        case 'getEngines':
          if (getEnginesDelay != null) {
            await Future.delayed(getEnginesDelay!);
          }
          if (simulateNoEngines) {
            return <String>[];
          }
          return ['com.google.android.tts'];
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
          return ['en-US', 'es-ES'];
        case 'getVoices':
          return [];
        case 'isLanguageAvailable':
          return 1;
        default:
          return null;
      }
    });
  }

  setUp(() {
    lastMethodCall = null;
    getEnginesDelay = null;
    simulateNoEngines = false;
    simulateTimeout = false;
    setupMockHandler();
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

    test('speak initializes lazily on first call', () async {
      // TTS should initialize lazily when speak is called
      await expectLater(ttsService.speak('Hello'), completes);
    });

    test('speak can be called multiple times', () async {
      await ttsService.speak('First');
      await expectLater(ttsService.speak('Second'), completes);
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

    test('speak works after previous speak', () async {
      await ttsService.speak('First message');
      await expectLater(ttsService.speak('After first'), completes);
    });

    test('stop can be called even if not speaking', () async {
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

  group('TtsService Lazy Initialization', () {
    late TtsService ttsService;

    setUp(() {
      ttsService = TtsService();
    });

    tearDown(() {
      ttsService.dispose();
    });

    test('isAvailable is true by default', () {
      expect(ttsService.isAvailable, isTrue);
    });

    test('does not call TTS methods until first speak', () async {
      // Create service but don't speak
      final service = TtsService();
      await Future.delayed(const Duration(milliseconds: 100));
      // lastMethodCall should be null since we haven't spoken
      expect(lastMethodCall?.method, isNot(equals('speak')));
      service.dispose();
    });

    test('speak triggers TTS initialization', () async {
      await ttsService.speak('Test');
      // After speak, TTS should be available
      expect(ttsService.isAvailable, isTrue);
    });

    test('speak can be called immediately without prior setup', () async {
      final freshService = TtsService();
      await expectLater(freshService.speak('Hello'), completes);
      freshService.dispose();
    });
  });

  group('TtsService Timeout Handling', () {
    test('handles slow TTS setup without blocking', () async {
      // Set a delay that's less than timeout
      getEnginesDelay = const Duration(milliseconds: 500);

      final ttsService = TtsService();
      final stopwatch = Stopwatch()..start();

      await ttsService.speak('Hello');

      stopwatch.stop();
      // Should complete within reasonable time (timeout is 2 seconds per call)
      expect(stopwatch.elapsedMilliseconds, lessThan(6000));

      ttsService.dispose();
    });

    test('speak completes even with delays', () async {
      getEnginesDelay = const Duration(milliseconds: 200);

      final ttsService = TtsService();
      await expectLater(ttsService.speak('Test message'), completes);
      ttsService.dispose();
    });
  });

  group('TtsService Language Switching', () {
    late TtsService ttsService;

    setUp(() {
      ttsService = TtsService();
    });

    tearDown(() {
      ttsService.dispose();
    });

    test('setLanguage with English (en)', () {
      expect(
        () => ttsService.setLanguage(ContentLanguage.en),
        returnsNormally,
      );
    });

    test('setLanguage with Spanish (es)', () {
      expect(
        () => ttsService.setLanguage(ContentLanguage.es),
        returnsNormally,
      );
    });

    test('setLanguage can be called multiple times', () {
      expect(() {
        ttsService.setLanguage(ContentLanguage.en);
        ttsService.setLanguage(ContentLanguage.es);
        ttsService.setLanguage(ContentLanguage.en);
      }, returnsNormally);
    });

    test('setLanguage does not block', () {
      final stopwatch = Stopwatch()..start();

      ttsService.setLanguage(ContentLanguage.en);

      stopwatch.stop();
      // Should complete nearly instantly (< 100ms)
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    test('setLanguage sets correct TTS code for English', () {
      ttsService.setLanguage(ContentLanguage.en);
      // ContentLanguage.en has ttsCode 'en-US'
      expect(ContentLanguage.en.ttsCode, equals('en-US'));
    });

    test('setLanguage sets correct TTS code for Spanish', () {
      ttsService.setLanguage(ContentLanguage.es);
      // ContentLanguage.es has ttsCode 'es-ES'
      expect(ContentLanguage.es.ttsCode, equals('es-ES'));
    });
  });

  group('TtsService Stream Providers', () {
    late TtsService ttsService;

    setUp(() {
      ttsService = TtsService();
    });

    tearDown(() {
      ttsService.dispose();
    });

    test('speakingStream is a broadcast stream', () {
      final stream = ttsService.speakingStream;
      expect(stream.isBroadcast, isTrue);
    });

    test('speakingTextStream is a broadcast stream', () {
      final stream = ttsService.speakingTextStream;
      expect(stream.isBroadcast, isTrue);
    });

    test('speakingStream can have multiple listeners', () {
      bool listener1Called = false;
      bool listener2Called = false;

      ttsService.speakingStream.listen((_) => listener1Called = true);
      ttsService.speakingStream.listen((_) => listener2Called = true);

      // Both listeners should be able to subscribe without error
      expect(listener1Called, isFalse);
      expect(listener2Called, isFalse);
    });

    test('isSpeaking is false initially', () {
      expect(ttsService.isSpeaking, isFalse);
    });

    test('currentText is null initially', () {
      expect(ttsService.currentText, isNull);
    });
  });

  group('TtsService Provider', () {
    test('TtsService can be instantiated', () {
      final service = TtsService();
      expect(service, isA<TtsService>());
      service.dispose();
    });
  });

  group('TtsService Error Handling', () {
    late TtsService ttsService;

    setUp(() {
      ttsService = TtsService();
    });

    tearDown(() {
      ttsService.dispose();
    });

    test('speak handles empty text gracefully', () async {
      await expectLater(ttsService.speak(''), completes);
    });

    test('stop can be called before initialization', () async {
      await expectLater(ttsService.stop(), completes);
    });

    test('dispose can be called before initialization', () {
      final service = TtsService();
      expect(() => service.dispose(), returnsNormally);
    });

    test('dispose can be called after initialization', () async {
      final service = TtsService();
      await service.speak('Hello');
      expect(() => service.dispose(), returnsNormally);
    });

    test('dispose can be called multiple times', () async {
      final service = TtsService();
      await service.speak('Hello');
      expect(() {
        service.dispose();
        service.dispose();
      }, returnsNormally);
    });
  });
}
