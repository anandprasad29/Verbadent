import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_constants.dart';
import '../../../localization/app_localizations.dart';
import '../../../localization/content_language_provider.dart';
import '../../../localization/content_translations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/app_shell.dart';
import '../data/library_data.dart';
import '../services/tts_service.dart';
import 'widgets/library_card.dart';

/// Library page displaying a scrollable grid of dental-related images
/// with captions. Tapping an image triggers text-to-speech of the caption.
class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsService = ref.watch(ttsServiceProvider);
    final contentLanguage = ref.watch(contentLanguageNotifierProvider);

    // Update TTS language when content language changes
    ref.listen<ContentLanguage>(contentLanguageNotifierProvider,
        (previous, next) {
      ttsService.setLanguage(next);
    });

    return AppShell(
      child: _buildLibraryContent(context, ttsService, contentLanguage),
    );
  }

  Widget _buildLibraryContent(
    BuildContext context,
    TtsService ttsService,
    ContentLanguage contentLanguage,
  ) {
    final columnCount = Responsive.getGridColumnCount(context);
    final spacing = Responsive.getGridSpacing(context);
    final padding = Responsive.getContentPadding(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      color: AppColors.background,
      child: CustomScrollView(
        slivers: [
          // Collapsible header with "Library" title
          SliverAppBar(
            expandedHeight: AppConstants.headerExpandedHeight,
            pinned: true,
            floating: false,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Text(
                l10n?.pageHeaderLibrary ?? 'Library',
                style: AppTextStyles.pageHeader,
              ),
              expandedTitleScale: AppConstants.headerExpandedScale,
            ),
          ),
          // Grid of library items
          SliverPadding(
            padding: padding,
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: 0.7, // Square image + caption below
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = LibraryData.sampleItems[index];
                  final translatedCaption = ContentTranslations.getCaption(
                    item.id,
                    contentLanguage,
                  );
                  return LibraryCard(
                    item: item,
                    caption: translatedCaption,
                    onTap: () => ttsService.speak(translatedCaption),
                  );
                },
                childCount: LibraryData.sampleItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
