// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ttsServiceHash() => r'3a0c6cf3bd4969b92b6e34a33e184f42002daa76';

/// Provider for TtsService with automatic lifecycle management.
/// Pre-initializes on creation to avoid first-tap delays.
///
/// Copied from [ttsService].
@ProviderFor(ttsService)
final ttsServiceProvider = AutoDisposeProvider<TtsService>.internal(
  ttsService,
  name: r'ttsServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ttsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TtsServiceRef = AutoDisposeProviderRef<TtsService>;
String _$ttsSpeakingStateHash() => r'02f1ac8af569e3daae31603721fc9c6b2041a3aa';

/// Provider that exposes the current speaking state as a stream.
/// Updates whenever TTS starts or stops speaking.
///
/// Copied from [ttsSpeakingState].
@ProviderFor(ttsSpeakingState)
final ttsSpeakingStateProvider = AutoDisposeStreamProvider<bool>.internal(
  ttsSpeakingState,
  name: r'ttsSpeakingStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ttsSpeakingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TtsSpeakingStateRef = AutoDisposeStreamProviderRef<bool>;
String _$ttsSpeakingTextHash() => r'9add1ad1755344cd00e694f29e2fffa5dc3af410';

/// Provider that exposes the currently speaking text.
/// Returns null when not speaking.
///
/// Copied from [ttsSpeakingText].
@ProviderFor(ttsSpeakingText)
final ttsSpeakingTextProvider = AutoDisposeProvider<String?>.internal(
  ttsSpeakingText,
  name: r'ttsSpeakingTextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ttsSpeakingTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TtsSpeakingTextRef = AutoDisposeProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
