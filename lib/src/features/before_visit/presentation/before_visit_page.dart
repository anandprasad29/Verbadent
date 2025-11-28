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
    for (final item in BeforeVisitData.storyItems) {
      precacheImage(AssetImage(item.imagePath), context);
    }
    // Precache tools grid images
    for (final item in BeforeVisitData.toolsItems) {
      precacheImage(AssetImage(item.imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read TTS service (don't watch - only need for speak calls)
    final ttsService = ref.read(ttsServiceProvider);
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
      child: _buildContent(context, ttsService, contentLanguage, speakingText),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TtsService ttsService,
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
              items: BeforeVisitData.storyItems,
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
                  final item = BeforeVisitData.toolsItems[index];
                  final translatedCaption = ContentTranslations.getCaption(
                    item.id,
                    contentLanguage,
                  );
                  return LibraryCard(
                    key: ValueKey(item.id),
                    item: item,
                    caption: translatedCaption,
                    onTap: () => ttsService.speak(translatedCaption),
                    isSpeaking: speakingText == translatedCaption,
                  );
                },
                childCount: BeforeVisitData.toolsItems.length,
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
