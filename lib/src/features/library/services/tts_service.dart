import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tts_service.g.dart';

/// Service for text-to-speech functionality.
/// Used to speak library item captions when tapped.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  /// Initialize the TTS engine with default settings.
  Future<void> init() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _isInitialized = true;
  }

  /// Speak the given text.
  /// Automatically initializes if not already done.
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await init();
    }
    await _flutterTts.speak(text);
  }

  /// Stop any ongoing speech.
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Dispose of TTS resources.
  void dispose() {
    _flutterTts.stop();
  }
}

/// Provider for TtsService with automatic lifecycle management.
@riverpod
TtsService ttsService(Ref ref) {
  final service = TtsService();
  ref.onDispose(() => service.dispose());
  return service;
}
