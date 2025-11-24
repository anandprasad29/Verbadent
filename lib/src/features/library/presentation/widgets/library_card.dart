import 'package:flutter/material.dart';
import '../../../../common/domain/dental_item.dart';
import '../../../../common/widgets/tappable_card.dart';
import '../../../../constants/app_constants.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

/// A card widget displaying a library item with image and caption.
/// Tapping the card triggers the onTap callback for TTS playback.
/// Includes visual tap feedback with scale animation.
class LibraryCard extends StatelessWidget {
  final DentalItem item;
  final VoidCallback? onTap;
  
  /// Optional caption override for translations. 
  /// If null, uses item.caption.
  final String? caption;

  const LibraryCard({
    super.key,
    required this.item,
    this.onTap,
    this.caption,
  });

  /// The displayed caption (uses override if provided, otherwise item.caption)
  String get displayCaption => caption ?? item.caption;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: displayCaption,
      button: true,
      child: TappableCard(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Square image container with blue border
            AspectRatio(
              aspectRatio: 1.0, // Square
              child: Container(
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
                    errorBuilder: (context, error, stackTrace) {
                      // Placeholder for missing images
                      return Container(
                        color: AppColors.background,
                        child: Icon(
                          Icons.medical_services_outlined,
                          size: 48,
                          color: AppColors.cardBorder,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
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
}
