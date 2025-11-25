import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/content_language_provider.dart';
import '../theme/app_colors.dart';

/// A dropdown button for selecting the content language.
/// Used on non-dashboard routes to control caption language and TTS.
/// Supports compact mode for mobile app bars.
class LanguageSelector extends ConsumerWidget {
  /// If true, shows only the flag without the language name
  final bool compact;
  
  const LanguageSelector({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(contentLanguageNotifierProvider);
    final notifier = ref.read(contentLanguageNotifierProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12, 
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: context.appCardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appCardBorder, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ContentLanguage>(
          value: currentLanguage,
          icon: Icon(
            Icons.arrow_drop_down,
            color: context.appPrimary,
            size: compact ? 20 : 24,
          ),
          isDense: compact,
          style: TextStyle(
            color: context.appTextPrimary,
            fontSize: compact ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: context.appCardBackground,
          borderRadius: BorderRadius.circular(8),
          // Show selected value
          selectedItemBuilder: compact 
              ? (context) => ContentLanguage.values.map((language) {
                  return Center(
                    child: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList()
              : null,
          items: ContentLanguage.values.map((language) {
            return DropdownMenuItem<ContentLanguage>(
              value: language,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    language.flag,
                    style: TextStyle(fontSize: compact ? 16 : 18),
                  ),
                  const SizedBox(width: 8),
                  Text(language.displayName),
                ],
              ),
            );
          }).toList(),
          onChanged: (ContentLanguage? newLanguage) {
            if (newLanguage != null) {
              notifier.setLanguage(newLanguage);
            }
          },
        ),
      ),
    );
  }
}

/// A responsive language selector that auto-adjusts based on available space.
/// Shows compact mode in constrained spaces (like app bars).
class ResponsiveLanguageSelector extends ConsumerWidget {
  const ResponsiveLanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use compact mode for narrower screens
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    
    return LanguageSelector(compact: isCompact);
  }
}

