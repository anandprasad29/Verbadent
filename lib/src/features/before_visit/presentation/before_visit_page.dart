import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/data/dental_items.dart';
import '../../../common/services/analytics_service.dart';
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

/// Before Visit page displaying dental visit preparation content.
/// Shows a story sequence with arrows and a tools grid below.
/// Tapping any item triggers text-to-speech of the caption.
class BeforeVisitPage extends ConsumerStatefulWidget {
  const BeforeVisitPage({super.key});

  @override
  ConsumerState<BeforeVisitPage> createState() => _BeforeVisitPageState();
}

class _BeforeVisitPageState extends ConsumerState<BeforeVisitPage> {
  bool _imagesPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache all images on first load to eliminate decode jank during scroll
    if (!_imagesPrecached) {
      _imagesPrecached = true;
      _precacheImages();
    }
  }

  /// Precache all before visit images for smoother scrolling performance
  void _precacheImages() {
    // Precache story sequence images
    for (final item in DentalItems.beforeVisitStoryItems) {
      precacheImage(AssetImage(item.imagePath), context);
    }
    // Precache tools grid images
    for (final item in DentalItems.beforeVisitToolsItems) {
      precacheImage(AssetImage(item.imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read services (don't watch - only need for method calls)
    final ttsService = ref.read(ttsServiceProvider);
    final analytics = ref.read(analyticsServiceProvider);
    final contentLanguage = ref.watch(contentLanguageNotifierProvider);

    // Watch speaking text stream for UI feedback
    final speakingTextAsync = ref.watch(ttsSpeakingTextStreamProvider);
    final speakingText = speakingTextAsync.valueOrNull;

    // Update TTS language when content language changes
    ref.listen<ContentLanguage>(contentLanguageNotifierProvider, (
      previous,
      next,
    ) {
      ttsService.setLanguage(next);
    });

    return AppShell(
      child: _buildContent(
        context,
        ttsService,
        analytics,
        contentLanguage,
        speakingText,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TtsService ttsService,
    AnalyticsService analytics,
    ContentLanguage contentLanguage,
    String? speakingText,
  ) {
    // Single MediaQuery call for all layout values (performance optimization)
    final layout = Responsive.getGridLayout(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      color: context.appBackground,
      child: CustomScrollView(
        slivers: [
          // Collapsible header with "Before the visit" title (desktop only)
          if (layout.showHeader)
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
                expandedTitleScale: layout.headerScale,
              ),
            ),
          // Story sequence section - fits same width as grid below
          SliverToBoxAdapter(
            child: StorySequence(
              items: DentalItems.beforeVisitStoryItems,
              contentLanguage: contentLanguage,
              padding: layout.padding.copyWith(
                top: layout.showHeader ? 16 : 24,
                bottom: 0,
              ),
              onItemTap: (item) {
                final translatedCaption = ContentTranslations.getCaption(
                  item.id,
                  contentLanguage,
                );
                // Log analytics events
                final position = DentalItems.beforeVisitStoryItems.indexOf(item);
                analytics.logStoryItemTapped(item.id, position);
                analytics.logStoryTtsPlayed(item.id, contentLanguage.code);
                // Play TTS
                ttsService.speak(translatedCaption);
              },
            ),
          ),
          // Spacer between sections
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // Tools grid section
          SliverPadding(
            padding: layout.padding,
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: layout.columnCount,
                mainAxisSpacing: layout.spacing,
                crossAxisSpacing: layout.spacing,
                childAspectRatio: layout.aspectRatio, // Responsive aspect ratio
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = DentalItems.beforeVisitToolsItems[index];
                  final translatedCaption = ContentTranslations.getCaption(
                    item.id,
                    contentLanguage,
                  );
                  return LibraryCard(
                    key: ValueKey(item.id),
                    item: item,
                    caption: translatedCaption,
                    onTap: () {
                      // Log analytics events
                      analytics.logToolsItemTapped(item.id);
                      analytics.logToolsTtsPlayed(item.id, contentLanguage.code);
                      // Play TTS
                      ttsService.speak(translatedCaption);
                    },
                    isSpeaking: speakingText == translatedCaption,
                  );
                },
                childCount: DentalItems.beforeVisitToolsItems.length,
                // Optimize memory for grids
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
              ),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
