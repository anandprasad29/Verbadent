import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

/// Centralized analytics service for tracking user events and properties.
/// Uses Firebase Analytics for anonymous, privacy-respecting metrics.
///
/// Events tracked:
/// - Library: item_tapped, tts_played, search
/// - Before Visit: story_item_tapped, story_tts_played, tools_item_tapped, tools_tts_played
/// - Build Your Own: template_created, template_played
/// - Settings: language_changed
///
/// User properties:
/// - preferred_language: en/es
/// - device_type: phone/tablet
class AnalyticsService {
  /// Lazy-loaded Firebase Analytics instance.
  /// Returns null if Firebase isn't initialized (e.g., in tests).
  FirebaseAnalytics? get _analytics {
    try {
      if (Firebase.apps.isEmpty) return null;
      return FirebaseAnalytics.instance;
    } catch (e) {
      return null;
    }
  }

  /// Whether analytics is enabled (can be disabled for testing)
  bool _enabled = true;

  /// Enable or disable analytics
  void setEnabled(bool enabled) {
    _enabled = enabled;
    _analytics?.setAnalyticsCollectionEnabled(enabled);
  }

  // ==========================================================================
  // Screen Tracking
  // ==========================================================================

  /// Log a screen view event
  Future<void> logScreenView(String screenName) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logScreenView(screenName: screenName);
      _debugLog('screen_view: $screenName');
    } catch (e) {
      debugPrint('Analytics error (screen_view): $e');
    }
  }

  // ==========================================================================
  // Library Events
  // ==========================================================================

  /// Log when a library item is tapped
  Future<void> logLibraryItemTapped(String itemId) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'library_item_tapped',
        parameters: {'item_id': itemId},
      );
      _debugLog('library_item_tapped: $itemId');
    } catch (e) {
      debugPrint('Analytics error (library_item_tapped): $e');
    }
  }

  /// Log when TTS plays a library item caption
  Future<void> logLibraryTtsPlayed(String itemId, String language) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'library_tts_played',
        parameters: {'item_id': itemId, 'language': language},
      );
      _debugLog('library_tts_played: $itemId ($language)');
    } catch (e) {
      debugPrint('Analytics error (library_tts_played): $e');
    }
  }

  /// Log when a library search is performed
  Future<void> logLibrarySearch(int queryLength, int resultsCount) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'library_search',
        parameters: {
          'query_length': queryLength,
          'results_count': resultsCount,
        },
      );
      _debugLog('library_search: length=$queryLength, results=$resultsCount');
    } catch (e) {
      debugPrint('Analytics error (library_search): $e');
    }
  }

  // ==========================================================================
  // Before Visit Events
  // ==========================================================================

  /// Log when a story item is tapped
  Future<void> logStoryItemTapped(String itemId, int position) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'story_item_tapped',
        parameters: {'item_id': itemId, 'position': position},
      );
      _debugLog('story_item_tapped: $itemId (pos: $position)');
    } catch (e) {
      debugPrint('Analytics error (story_item_tapped): $e');
    }
  }

  /// Log when TTS plays a story item caption
  Future<void> logStoryTtsPlayed(String itemId, String language) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'story_tts_played',
        parameters: {'item_id': itemId, 'language': language},
      );
      _debugLog('story_tts_played: $itemId ($language)');
    } catch (e) {
      debugPrint('Analytics error (story_tts_played): $e');
    }
  }

  /// Log when a tools item is tapped
  Future<void> logToolsItemTapped(String itemId) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'tools_item_tapped',
        parameters: {'item_id': itemId},
      );
      _debugLog('tools_item_tapped: $itemId');
    } catch (e) {
      debugPrint('Analytics error (tools_item_tapped): $e');
    }
  }

  /// Log when TTS plays a tools item caption
  Future<void> logToolsTtsPlayed(String itemId, String language) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'tools_tts_played',
        parameters: {'item_id': itemId, 'language': language},
      );
      _debugLog('tools_tts_played: $itemId ($language)');
    } catch (e) {
      debugPrint('Analytics error (tools_tts_played): $e');
    }
  }

  // ==========================================================================
  // Build Your Own Events
  // ==========================================================================

  /// Log when a template is created
  Future<void> logTemplateCreated(int itemCount) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'template_created',
        parameters: {'item_count': itemCount},
      );
      _debugLog('template_created: $itemCount items');
    } catch (e) {
      debugPrint('Analytics error (template_created): $e');
    }
  }

  /// Log when a template is played (user views and interacts with it)
  Future<void> logTemplatePlayed(int itemCount) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'template_played',
        parameters: {'item_count': itemCount},
      );
      _debugLog('template_played: $itemCount items');
    } catch (e) {
      debugPrint('Analytics error (template_played): $e');
    }
  }

  // ==========================================================================
  // Settings Events
  // ==========================================================================

  /// Log when the language is changed
  Future<void> logLanguageChanged(String fromLanguage, String toLanguage) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: 'language_changed',
        parameters: {
          'from_language': fromLanguage,
          'to_language': toLanguage,
        },
      );
      _debugLog('language_changed: $fromLanguage -> $toLanguage');
    } catch (e) {
      debugPrint('Analytics error (language_changed): $e');
    }
  }

  // ==========================================================================
  // User Properties
  // ==========================================================================

  /// Set the user's preferred language
  Future<void> setPreferredLanguage(String language) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.setUserProperty(
        name: 'preferred_language',
        value: language,
      );
      _debugLog('user_property: preferred_language=$language');
    } catch (e) {
      debugPrint('Analytics error (setPreferredLanguage): $e');
    }
  }

  /// Set the user's device type (phone/tablet)
  Future<void> setDeviceType(String deviceType) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics!.setUserProperty(name: 'device_type', value: deviceType);
      _debugLog('user_property: device_type=$deviceType');
    } catch (e) {
      debugPrint('Analytics error (setDeviceType): $e');
    }
  }

  // ==========================================================================
  // Helpers
  // ==========================================================================

  /// Debug logging helper (only logs in debug mode)
  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[Analytics] $message');
    }
  }
}

/// Provider for AnalyticsService with automatic lifecycle management.
/// Uses keepAlive to ensure consistent tracking across navigation.
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService();
}

