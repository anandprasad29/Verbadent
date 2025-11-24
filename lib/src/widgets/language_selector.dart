import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/content_language_provider.dart';
import '../theme/app_colors.dart';

/// A dropdown button for selecting the content language.
/// Used on non-dashboard routes to control caption language and TTS.
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(contentLanguageNotifierProvider);
    final notifier = ref.read(contentLanguageNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ContentLanguage>(
          value: currentLanguage,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.primary,
          ),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          items: ContentLanguage.values.map((language) {
            return DropdownMenuItem<ContentLanguage>(
              value: language,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    language.flag,
                    style: const TextStyle(fontSize: 18),
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

