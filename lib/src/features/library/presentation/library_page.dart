import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/data/dental_items.dart';
import '../../../common/domain/dental_item.dart';
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
  bool _imagesPrecached = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current search input value
    _searchController = TextEditingController(
      text: ref.read(librarySearchInputProvider),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache all library images on first load to eliminate decode jank during scroll
    // Only do this once to avoid redundant precaching
    if (!_imagesPrecached) {
      _imagesPrecached = true;
      _precacheImages();
    }
  }

  /// Precache all library images for smoother scrolling performance
  void _precacheImages() {
    for (final item in DentalItems.all) {
      precacheImage(AssetImage(item.imagePath), context);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read TTS service (don't watch - only need for speak calls)
    final ttsService = ref.read(ttsServiceProvider);

    // Watch only what's needed for UI updates
    final contentLanguage = ref.watch(contentLanguageNotifierProvider);
    final searchInput = ref.watch(librarySearchInputProvider);
    final filteredItems = ref.watch(filteredLibraryItemsProvider);

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
    List<DentalItem> filteredItems,
    String searchInput,
  ) {
    // Single MediaQuery call for all layout values (performance optimization)
    final layout = Responsive.getGridLayout(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      color: context.appBackground,
      child: CustomScrollView(
        slivers: [
          // Collapsible header with "Library" title (desktop only)
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
                    l10n?.pageHeaderLibrary ?? 'Library',
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
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: layout.padding.left,
                right: layout.padding.right,
                top: layout.showHeader ? 16 : 24,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(context, l10n, searchInput),
                  const SizedBox(height: 8),
                  _buildResultCount(
                    context,
                    l10n,
                    filteredItems.length,
                    searchInput,
                  ),
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
                    Icon(Icons.search_off, size: 64, color: context.appNeutral),
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
              padding: layout.padding.copyWith(top: 0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: layout.columnCount,
                  mainAxisSpacing: layout.spacing,
                  crossAxisSpacing: layout.spacing,
                  childAspectRatio:
                      layout.aspectRatio, // Responsive aspect ratio
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filteredItems[index];
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
                  childCount: filteredItems.length,
                  // Disable automatic keep-alives to reduce memory on large lists
                  addAutomaticKeepAlives: false,
                  // Keep repaint boundaries for scroll performance
                  addRepaintBoundaries: true,
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
        prefixIcon: Icon(Icons.search, color: context.appCardBorder),
        suffixIcon: searchInput.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: context.appNeutral),
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
