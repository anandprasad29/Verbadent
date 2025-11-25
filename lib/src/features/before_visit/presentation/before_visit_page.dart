import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/story_sequence.dart';
import '../../../constants/app_constants.dart';
import '../../../localization/app_localizations.dart';
import '../../../localization/content_language_provider.dart';
import '../../../localization/content_translations.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/app_shell.dart';
import '../../../widgets/language_selector.dart';
import '../../library/presentation/widgets/library_card.dart';
import '../../library/services/tts_service.dart';
import '../data/before_visit_data.dart';

/// Before Visit page displaying dental visit preparation content.
/// Shows a story sequence with arrows and a tools grid below.
/// Tapping any item triggers text-to-speech of the caption.
class BeforeVisitPage extends ConsumerWidget {
  const BeforeVisitPage({super.key});

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
      child: _buildContent(context, ttsService, contentLanguage),
    );
  }

  Widget _buildContent(
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
          // Collapsible header with "Before the visit" title
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
                l10n?.pageHeaderBeforeVisit ?? 'Before the visit',
                style: TextStyle(
                  fontFamily: 'KumarOne',
                  fontSize: AppConstants.headerFontSize,
                  color: context.appTextPrimary,
                ),
              ),
              expandedTitleScale: AppConstants.headerExpandedScale,
            ),
          ),
          // Story sequence section - fits same width as grid below
          SliverToBoxAdapter(
            child: StorySequence(
              items: BeforeVisitData.storyItems,
              contentLanguage: contentLanguage,
              padding: padding.copyWith(top: 16, bottom: 0),
              onItemTap: (item) {
                final translatedCaption = ContentTranslations.getCaption(
                  item.id,
                  contentLanguage,
                );
                ttsService.speak(translatedCaption);
              },
            ),
          ),
          // Spacer between sections
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
          // Tools grid section
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
                  final item = BeforeVisitData.toolsItems[index];
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
                childCount: BeforeVisitData.toolsItems.length,
              ),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}
