import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../domain/dental_item.dart';

/// A card widget displaying a dental item with image and caption.
/// Tapping the card triggers the onTap callback for TTS playback.
///
/// This is a shared component used by Library, Before Visit, and other pages.
class ImageCard extends StatelessWidget {
  final DentalItem item;
  final VoidCallback? onTap;

  /// Optional caption override for translations.
  /// If null, uses item.caption.
  final String? caption;

  /// Optional fixed size for the image. If null, uses AspectRatio of 1:1.
  final double? imageSize;

  const ImageCard({
    super.key,
    required this.item,
    this.onTap,
    this.caption,
    this.imageSize,
  });

  /// The displayed caption (uses override if provided, otherwise item.caption)
  String get displayCaption => caption ?? item.caption;

  @override
  Widget build(BuildContext context) {
    // Cache pixel ratio once at the top of build to avoid repeated lookups
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return Semantics(
      label: displayCaption,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Square image container with blue border
            _buildImageContainer(context, pixelRatio),
            const SizedBox(height: 8),
            // Caption text below the image
            Flexible(
              child: Text(
                displayCaption,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, double pixelRatio) {
    if (imageSize != null) {
      // Calculate cache size based on fixed image size
      // Ensure cacheSize is at least 1 (required by Image.asset) or null if size is 0
      final calculatedSize = (imageSize! * pixelRatio).ceil();
      final cacheSize = calculatedSize > 0 ? calculatedSize : null;
      return SizedBox(
        width: imageSize,
        height: imageSize,
        child: _buildImageWidget(context, cacheSize),
      );
    }

    // Use LayoutBuilder to get actual display size for optimal caching
    return AspectRatio(
      aspectRatio: 1.0, // Square
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Ensure cacheSize is at least 1 (required by Image.asset) or null if constraints are 0
          final calculatedSize = (constraints.maxWidth * pixelRatio).ceil();
          final cacheSize = calculatedSize > 0 ? calculatedSize : null;
          return _buildImageWidget(context, cacheSize);
        },
      ),
    );
  }

  /// Builds the image widget with optimized caching.
  /// The cacheSize parameter reduces memory usage by ~70-90% for oversized images.
  /// Pass null to skip caching (uses original image size).
  Widget _buildImageWidget(BuildContext context, int? cacheSize) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.cardBorder,
          width: AppConstants.cardBorderWidth,
        ),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          AppConstants.cardBorderRadius - AppConstants.cardBorderWidth,
        ),
        child: Image.asset(
          item.imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          // Decode image at display size to reduce memory usage
          cacheWidth: cacheSize,
          cacheHeight: cacheSize,
          errorBuilder: (context, error, stackTrace) {
            // Placeholder for missing images
            return Container(
              color: AppColors.background,
              child: const Icon(
                Icons.medical_services_outlined,
                size: 48,
                color: AppColors.cardBorder,
              ),
            );
          },
        ),
      ),
    );
  }
}
