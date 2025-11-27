import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../localization/content_language_provider.dart';

part 'tts_service.g.dart';

/// Service for text-to-speech functionality.
/// Used to speak library item captions when tapped.
/// Exposes speaking state for UI feedback.
/// 
/// TTS initialization is completely deferred to first speak() call
/// to prevent blocking the main thread on Android.
class TtsService {
  FlutterTts? _flutterTts;
  String _currentLanguage = 'en-US';

  /// Initialization completer to prevent race conditions.
  Completer<void>? _initCompleter;

  /// Whether initialization has been attempted
  bool _initAttempted = false;

  /// Whether TTS is available on this platform/device
  bool _isAvailable = true;
  bool get isAvailable => _isAvailable;

  /// Controller for speaking state changes
  final _speakingController = StreamController<bool>.broadcast();

  /// Stream of speaking state changes
  Stream<bool> get speakingStream => _speakingController.stream;

  /// Controller for speaking text changes
  final _speakingTextController = StreamController<String?>.broadcast();

  /// Stream of speaking text changes
  Stream<String?> get speakingTextStream => _speakingTextController.stream;

  /// Current speaking state
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  /// The text currently being spoken (null if not speaking)
  String? _currentText;
  String? get currentText => _currentText;

  /// Initialize the TTS engine lazily on first use.
  /// This prevents blocking the main thread during app startup.
  Future<void> _ensureInitialized() async {
    // If already initialized or attempted, return
    if (_initAttempted) {
      // Wait for any in-progress initialization
      if (_initCompleter != null && !_initCompleter!.isCompleted) {
        await _initCompleter!.future;
      }
      return;
    }

    _initAttempted = true;
    _initCompleter = Completer<void>();

    try {
      // Create TTS instance lazily
      _flutterTts = FlutterTts();

      // Set up completion handlers first (these don't block)
      _setupHandlers();

      // Configure TTS with timeout to prevent hangs
      await _configureWithTimeout();

      _isAvailable = true;
    } catch (e) {
      debugPrint('TTS initialization error: $e');
      _isAvailable = false;
    } finally {
      _initCompleter!.complete();
    }
  }

  /// Configure TTS with a timeout to prevent blocking
  Future<void> _configureWithTimeout() async {
    if (_flutterTts == null) return;

    try {
      // Use a short timeout for each operation
      await _flutterTts!.setLanguage(_currentLanguage).timeout(
        const Duration(seconds: 2),
        onTimeout: () => debugPrint('TTS setLanguage timed out'),
      );
      
      await _flutterTts!.setSpeechRate(0.5).timeout(
        const Duration(seconds: 1),
        onTimeout: () => debugPrint('TTS setSpeechRate timed out'),
      );
      
      await _flutterTts!.setVolume(1.0).timeout(
        const Duration(seconds: 1),
        onTimeout: () => debugPrint('TTS setVolume timed out'),
      );
      
      await _flutterTts!.setPitch(1.0).timeout(
        const Duration(seconds: 1),
        onTimeout: () => debugPrint('TTS setPitch timed out'),
      );

      // Don't await speak completion - it can block
      _flutterTts!.awaitSpeakCompletion(false);
    } catch (e) {
      debugPrint('TTS configuration error: $e');
      _isAvailable = false;
    }
  }

  /// Set up TTS event handlers (non-blocking)
  void _setupHandlers() {
    if (_flutterTts == null) return;

    _flutterTts!.setStartHandler(() {
      _isSpeaking = true;
      _speakingController.add(true);
      _speakingTextController.add(_currentText);
    });

    _flutterTts!.setCompletionHandler(() {
      _isSpeaking = false;
      _currentText = null;
      _speakingController.add(false);
      _speakingTextController.add(null);
    });

    _flutterTts!.setCancelHandler(() {
      _isSpeaking = false;
      _currentText = null;
      _speakingController.add(false);
      _speakingTextController.add(null);
    });

    _flutterTts!.setErrorHandler((error) {
      debugPrint('TTS error: $error');
      _isSpeaking = false;
      _currentText = null;
      _speakingController.add(false);
      _speakingTextController.add(null);
    });
  }

  /// Pre-warm the TTS engine without speaking.
  /// Call this early (e.g., when a TTS-enabled page loads) to eliminate
  /// first-speak delay. This runs initialization in the background.
  void warmUp() {
    // Fire and forget - don't block the caller
    _ensureInitialized().catchError((e) {
      debugPrint('TTS warmUp error: $e');
    });
  }

  /// Set the TTS language based on ContentLanguage.
  /// Non-blocking - fires and forgets if TTS not ready.
  void setLanguage(ContentLanguage language) {
    _currentLanguage = language.ttsCode;
    
    // If TTS is already initialized, update the language
    if (_flutterTts != null && _isAvailable) {
      _flutterTts!.setLanguage(_currentLanguage).catchError((e) {
        debugPrint('Failed to set TTS language: $e');
      });
    }
  }

  /// Speak the given text.
  /// Initializes TTS lazily on first call.
  /// Non-blocking - returns immediately while speech plays.
  Future<void> speak(String text) async {
    // Initialize lazily on first speak
    await _ensureInitialized();
    
    if (!_isAvailable || _flutterTts == null) {
      debugPrint('TTS not available - skipping speak');
      return;
    }
    
    _currentText = text;
    _speakingTextController.add(text);
    
    // Fire and forget - don't await speak
    _flutterTts!.speak(text).catchError((e) {
      debugPrint('TTS speak error: $e');
      _isSpeaking = false;
      _currentText = null;
      _speakingController.add(false);
      _speakingTextController.add(null);
    });
  }

  /// Stop any ongoing speech.
  Future<void> stop() async {
    if (_flutterTts != null) {
      try {
        await _flutterTts!.stop();
      } catch (e) {
        debugPrint('TTS stop error: $e');
      }
    }
    _isSpeaking = false;
    _currentText = null;
    _speakingController.add(false);
    _speakingTextController.add(null);
  }

  /// Dispose of TTS resources.
  void dispose() {
    if (_flutterTts != null) {
      try {
        _flutterTts!.stop();
      } catch (_) {}
    }
    _speakingController.close();
    _speakingTextController.close();
  }
}

/// Provider for TtsService with automatic lifecycle management.
/// Uses keepAlive to prevent disposal and re-initialization issues.
/// TTS is NOT pre-initialized - it initializes lazily on first speak().
@Riverpod(keepAlive: true)
TtsService ttsService(Ref ref) {
  final service = TtsService();
  // DO NOT pre-initialize TTS here - it blocks the main thread on Android
  // TTS will initialize lazily on first speak() call
  ref.onDispose(() => service.dispose());
  return service;
}

/// Provider that exposes the current speaking state as a stream.
/// Updates whenever TTS starts or stops speaking.
@Riverpod(keepAlive: true)
Stream<bool> ttsSpeakingState(Ref ref) {
  final ttsService = ref.watch(ttsServiceProvider);
  return ttsService.speakingStream;
}

/// Provider that exposes the currently speaking text as a stream.
/// Returns null when not speaking.
/// Uses stream-based approach instead of invalidateSelf for better performance.
@Riverpod(keepAlive: true)
Stream<String?> ttsSpeakingTextStream(Ref ref) {
  final ttsService = ref.watch(ttsServiceProvider);
  return ttsService.speakingTextStream;
}

/// Provider that exposes the currently speaking text synchronously.
/// Watches the stream provider for updates.
@riverpod
String? ttsSpeakingText(Ref ref) {
  final streamAsync = ref.watch(ttsSpeakingTextStreamProvider);
  return streamAsync.valueOrNull;
}
