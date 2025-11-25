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
import '../services/tts_service.dart';
import 'library_search_provider.dart';
import 'widgets/library_card.dart';

/// Library page displaying a scrollable grid of dental-related images
/// with captions. Tapping an image triggers text-to-speech of the caption.
/// Includes search functionality with debouncing for performance.
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current search input value
    _searchController = TextEditingController(
      text: ref.read(librarySearchInputProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ttsService = ref.watch(ttsServiceProvider);
    final contentLanguage = ref.watch(contentLanguageNotifierProvider);
    final searchInput = ref.watch(librarySearchInputProvider);
    final filteredItems = ref.watch(filteredLibraryItemsProvider);

    // Watch speaking state to trigger rebuilds when TTS state changes
    final speakingText = ref.watch(ttsSpeakingTextProvider);

    // Update TTS language when content language changes
    ref.listen<ContentLanguage>(contentLanguageNotifierProvider,
        (previous, next) {
      ttsService.setLanguage(next);
    });

    // Sync controller text with provider (for external updates like clear)
    if (_searchController.text != searchInput) {
      _searchController.text = searchInput;
      // Move cursor to end
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchInput.length),
      );
    }

    return AppShell(
      child: _buildLibraryContent(
        context,
        ttsService,
        contentLanguage,
        speakingText,
        filteredItems,
        searchInput,
      ),
    );
  }

  Widget _buildLibraryContent(
    BuildContext context,
    TtsService ttsService,
    ContentLanguage contentLanguage,
    String? speakingText,
    List filteredItems,
    String searchInput,
  ) {
    final columnCount = Responsive.getGridColumnCount(context);
    final spacing = Responsive.getGridSpacing(context);
    final padding = Responsive.getContentPadding(context);
    final l10n = AppLocalizations.of(context);

    // Check if we're on desktop (wide screen with sidebar)
    final isDesktop =
        MediaQuery.of(context).size.width >= AppConstants.sidebarBreakpoint;

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
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding.left,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(context, l10n, searchInput),
                  const SizedBox(height: 8),
                  _buildResultCount(context, l10n, filteredItems.length, searchInput),
                ],
              ),
            ),
          ),
          // Grid of library items or empty state
          if (filteredItems.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: context.appNeutral,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n?.searchNoResults ?? 'No results found',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 18,
                        color: context.appTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: padding.copyWith(top: 0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: 0.7, // Square image + caption below
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filteredItems[index];
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
                  childCount: filteredItems.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the search bar TextField with debounced input
  Widget _buildSearchBar(
    BuildContext context,
    AppLocalizations? l10n,
    String searchInput,
  ) {
    final searchNotifier = ref.read(librarySearchNotifierProvider.notifier);

    return TextField(
      controller: _searchController,
      onChanged: (value) {
        searchNotifier.updateSearch(value);
      },
      decoration: InputDecoration(
        hintText: l10n?.searchPlaceholder ?? 'Search by caption...',
        hintStyle: TextStyle(
          fontFamily: 'InstrumentSans',
          color: context.appNeutral,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: context.appCardBorder,
        ),
        suffixIcon: searchInput.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: context.appNeutral,
                ),
                onPressed: () {
                  searchNotifier.clearSearch();
                  _searchController.clear();
                },
              )
            : null,
        filled: true,
        fillColor: context.appCardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.appCardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.appCardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.appPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: TextStyle(
        fontFamily: 'InstrumentSans',
        color: context.appTextSecondary,
      ),
    );
  }

  /// Builds the result count indicator
  Widget _buildResultCount(
    BuildContext context,
    AppLocalizations? l10n,
    int count,
    String searchInput,
  ) {
    // Only show count when there's an active search
    if (searchInput.isEmpty) {
      return const SizedBox.shrink();
    }

    final countText = l10n?.searchResultCount(count) ?? '$count items';

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        countText,
        style: TextStyle(
          fontFamily: 'InstrumentSans',
          fontSize: 14,
          color: context.appNeutral,
        ),
      ),
    );
  }
}
