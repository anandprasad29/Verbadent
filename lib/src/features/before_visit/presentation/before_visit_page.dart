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
    // Read TTS service (don't watch - only need for speak calls)
    final ttsService = ref.read(ttsServiceProvider);
    final contentLanguage = ref.watch(contentLanguageNotifierProvider);
    
    // Watch speaking text stream for UI feedback
    final speakingTextAsync = ref.watch(ttsSpeakingTextStreamProvider);
    final speakingText = speakingTextAsync.valueOrNull;

    // Update TTS language when content language changes
    ref.listen<ContentLanguage>(contentLanguageNotifierProvider,
        (previous, next) {
      ttsService.setLanguage(next);
    });

    return AppShell(
      child: _buildContent(
        context,
        ttsService,
        contentLanguage,
        speakingText,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TtsService ttsService,
    ContentLanguage contentLanguage,
    String? speakingText,
  ) {
    final columnCount = Responsive.getGridColumnCount(context);
    final spacing = Responsive.getGridSpacing(context);
    final padding = Responsive.getContentPadding(context);
    final aspectRatio = Responsive.getGridAspectRatio(context);
    final l10n = AppLocalizations.of(context);

    // Only show page header on desktop (mobile has AppBar from AppShell)
    final showHeader = Responsive.shouldShowPageHeader(context);
    final headerScale = Responsive.getHeaderExpandedScale(context);

    return Container(
      color: context.appBackground,
      child: CustomScrollView(
        slivers: [
          // Collapsible header with "Before the visit" title (desktop only)
          if (showHeader)
            SliverAppBar(
              expandedHeight: AppConstants.headerExpandedHeight,
              pinned: true,
              floating: false,
              backgroundColor: context.appBackground,
              automaticallyImplyLeading: false,
              // Language selector in actions
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: LanguageSelector(compact: true),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n?.pageHeaderBeforeVisit ?? 'Before the visit',
                    style: TextStyle(
                      fontFamily: 'KumarOne',
                      fontSize: AppConstants.headerFontSize,
                      color: context.appTextPrimary,
                    ),
                  ),
                ),
                expandedTitleScale: headerScale,
              ),
            ),
          // Story sequence section - fits same width as grid below
          SliverToBoxAdapter(
            child: StorySequence(
              items: BeforeVisitData.storyItems,
              contentLanguage: contentLanguage,
              padding: padding.copyWith(top: showHeader ? 16 : 24, bottom: 0),
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
                childAspectRatio: aspectRatio, // Responsive aspect ratio
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
                    isSpeaking: speakingText == translatedCaption,
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
