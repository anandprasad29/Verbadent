import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../localization/content_language_provider.dart';

part 'tts_service.g.dart';

/// Service for text-to-speech functionality.
/// Used to speak library item captions when tapped.
/// Exposes speaking state for UI feedback.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  String _currentLanguage = 'en-US';

  /// Controller for speaking state changes
  final _speakingController = StreamController<bool>.broadcast();

  /// Stream of speaking state changes
  Stream<bool> get speakingStream => _speakingController.stream;

  /// Current speaking state
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  /// The text currently being spoken (null if not speaking)
  String? _currentText;
  String? get currentText => _currentText;

  /// Initialize the TTS engine with default settings.
  Future<void> init() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage(_currentLanguage);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    // Ensure speak completes before returning, helps with reliability
    await _flutterTts.awaitSpeakCompletion(true);

    // Set up completion handlers
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      _speakingController.add(true);
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _currentText = null;
      _speakingController.add(false);
    });

    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
      _currentText = null;
      _speakingController.add(false);
    });

    _flutterTts.setErrorHandler((error) {
      _isSpeaking = false;
      _currentText = null;
      _speakingController.add(false);
    });

    _isInitialized = true;
  }

  /// Set the TTS language based on ContentLanguage.
  Future<void> setLanguage(ContentLanguage language) async {
    _currentLanguage = language.ttsCode;
    await _flutterTts.setLanguage(_currentLanguage);
  }

  /// Speak the given text.
  /// Automatically initializes if not already done.
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await init();
    }
    _currentText = text;
    await _flutterTts.speak(text);
  }

  /// Stop any ongoing speech.
  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    _currentText = null;
    _speakingController.add(false);
  }

  /// Dispose of TTS resources.
  void dispose() {
    _flutterTts.stop();
    _speakingController.close();
  }
}

/// Provider for TtsService with automatic lifecycle management.
/// Pre-initializes on creation to avoid first-tap delays.
@riverpod
TtsService ttsService(Ref ref) {
  final service = TtsService();
  // Pre-initialize TTS to avoid first-tap delay from lazy initialization.
  // Browser autoplay policies and TTS engine warm-up can cause the first
  // speak() call to fail if initialization happens at the same time.
  service.init();
  ref.onDispose(() => service.dispose());
  return service;
}

/// Provider that exposes the current speaking state as a stream.
/// Updates whenever TTS starts or stops speaking.
@riverpod
Stream<bool> ttsSpeakingState(Ref ref) {
  final ttsService = ref.watch(ttsServiceProvider);
  return ttsService.speakingStream;
}

/// Provider that exposes the currently speaking text.
/// Returns null when not speaking.
@riverpod
String? ttsSpeakingText(Ref ref) {
  final ttsService = ref.watch(ttsServiceProvider);
  // Listen to state changes to trigger rebuilds
  ref.listen(ttsSpeakingStateProvider, (_, __) {});
  return ttsService.currentText;
}
