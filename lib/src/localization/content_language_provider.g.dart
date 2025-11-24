// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contentLanguageNotifierHash() =>
    r'8e7d67a0e1c6257365067412eabc973e7bc6281a';

/// Notifier that manages the currently selected content language.
/// This affects captions and TTS on non-dashboard routes.
///
/// Copied from [ContentLanguageNotifier].
@ProviderFor(ContentLanguageNotifier)
final contentLanguageNotifierProvider = AutoDisposeNotifierProvider<
    ContentLanguageNotifier, ContentLanguage>.internal(
  ContentLanguageNotifier.new,
  name: r'contentLanguageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contentLanguageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContentLanguageNotifier = AutoDisposeNotifier<ContentLanguage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
