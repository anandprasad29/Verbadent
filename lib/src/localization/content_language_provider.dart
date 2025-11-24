import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_language_provider.g.dart';

/// Supported content languages for per-route content localization.
/// This is independent of the app-wide UI locale.
enum ContentLanguage {
  en('en-US', 'English', '🇺🇸'),
  es('es-ES', 'Español', '🇪🇸');

  const ContentLanguage(this.ttsCode, this.displayName, this.flag);

  /// The language code used for text-to-speech (e.g., 'en-US', 'es-ES')
  final String ttsCode;

  /// Human-readable display name
  final String displayName;

  /// Flag emoji for visual identification
  final String flag;

  /// Short language code (e.g., 'en', 'es')
  String get code => name;
}

/// Notifier that manages the currently selected content language.
/// This affects captions and TTS on non-dashboard routes.
@riverpod
class ContentLanguageNotifier extends _$ContentLanguageNotifier {
  @override
  ContentLanguage build() => ContentLanguage.en;

  /// Update the selected content language.
  void setLanguage(ContentLanguage language) {
    state = language;
  }
}
