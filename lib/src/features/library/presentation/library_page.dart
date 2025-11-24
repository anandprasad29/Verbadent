import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_constants.dart';
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

  /// Get the number of grid columns based on screen width
  int _getColumnCount(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return AppConstants.gridColumnsDesktop;
    } else if (Responsive.isTablet(context)) {
      return AppConstants.gridColumnsTablet;
    } else {
      return AppConstants.gridColumnsMobile;
    }
  }

  /// Get grid spacing based on screen width
  double _getGridSpacing(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return AppConstants.gridSpacingDesktop;
    } else if (Responsive.isTablet(context)) {
      return AppConstants.gridSpacingTablet;
    } else {
      return AppConstants.gridSpacingMobile;
    }
  }

  /// Get content padding based on screen width
  EdgeInsets _getContentPadding(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return AppConstants.contentPaddingDesktop;
    } else if (Responsive.isTablet(context)) {
      return AppConstants.contentPaddingTablet;
    } else {
      return AppConstants.contentPaddingMobile;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsService = ref.watch(ttsServiceProvider);
    
    return AppShell(
      child: _buildLibraryContent(context, ttsService),
    );
  }

  Widget _buildLibraryContent(BuildContext context, TtsService ttsService) {
    final columnCount = _getColumnCount(context);
    final spacing = _getGridSpacing(context);
    final padding = _getContentPadding(context);

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
                'Library',
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
                  return LibraryCard(
                    item: item,
                    onTap: () => ttsService.speak(item.caption),
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
