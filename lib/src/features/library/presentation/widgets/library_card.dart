import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../domain/library_item.dart';

/// A card widget displaying a library item with image and caption.
/// Tapping the card triggers the onTap callback for TTS playback.
class LibraryCard extends StatelessWidget {
  final LibraryItem item;
  final VoidCallback? onTap;

  const LibraryCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: item.caption,
      button: true,
      child: GestureDetector(
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
                item.caption,
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
