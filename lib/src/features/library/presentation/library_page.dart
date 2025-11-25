import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_constants.dart';
import '../../../localization/app_localizations.dart';
import '../../../localization/content_language_provider.dart';
import '../../../localization/content_translations.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/app_shell.dart';
import '../../../widgets/language_selector.dart';
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

    // Check if we're on desktop (wide screen with sidebar)
    final isDesktop = MediaQuery.of(context).size.width >= AppConstants.sidebarBreakpoint;
    
    return Container(
      color: context.appBackground,
      child: CustomScrollView(
        slivers: [
          // Collapsible header with "Library" title
          SliverAppBar(
            expandedHeight: AppConstants.headerExpandedHeight,
            pinned: true,
            floating: false,
            backgroundColor: context.appBackground,
            automaticallyImplyLeading: false,
            // Language selector in actions (only on desktop, mobile uses app bar)
            actions: isDesktop
                ? [
                    Padding(
                      padding: const EdgeInsets.only(right: 16, top: 8),
                      child: LanguageSelector(compact: true),
                    ),
                  ]
                : null,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Text(
                l10n?.pageHeaderLibrary ?? 'Library',
                style: TextStyle(
                  fontFamily: 'KumarOne',
                  fontSize: AppConstants.headerFontSize,
                  color: context.appTextPrimary,
                ),
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
                    isSpeaking: ttsService.isSpeaking &&
                        ttsService.currentText == translatedCaption,
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
