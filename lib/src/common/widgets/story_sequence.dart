import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../localization/content_language_provider.dart';
import '../../localization/content_translations.dart';
import '../../theme/app_colors.dart';
import '../domain/dental_item.dart';
import 'tappable_card.dart';

/// A horizontal widget displaying dental items in a story sequence
/// with arrow connectors between each item. Used for showing step-by-step
/// dental visit flows. Items are sized to fit within the available width,
/// or scrollable if items would be too small.
class StorySequence extends StatelessWidget {
  final List<DentalItem> items;
  final void Function(DentalItem item)? onItemTap;

  /// Content language for translations
  final ContentLanguage? contentLanguage;

  /// Padding around the sequence (should match grid padding)
  final EdgeInsets padding;

  /// Horizontal padding between arrow and adjacent images
  final double arrowPadding;

  /// Width of the arrow line (excluding padding)
  final double arrowWidth;

  /// Minimum item size to ensure captions are readable
  static const double _minItemSize = 100.0;

  const StorySequence({
    super.key,
    required this.items,
    this.onItemTap,
    this.contentLanguage,
    this.padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
    this.arrowPadding = 8,
    this.arrowWidth = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final itemCount = items.length;
          final arrowCount = itemCount - 1;

          // Total space taken by arrows (arrow width + padding on both sides)
          final totalArrowSpace = arrowCount * (arrowWidth + arrowPadding * 2);

          // Calculate item size to fit all items in available width
          final calculatedItemSize = (availableWidth - totalArrowSpace) / itemCount;
          
          // Use minimum size if calculated size is too small
          final itemSize = calculatedItemSize < _minItemSize 
              ? _minItemSize 
              : calculatedItemSize;
          
          // Check if we need to scroll (items don't fit in available width)
          final needsScroll = calculatedItemSize < _minItemSize;

          final content = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: needsScroll ? MainAxisSize.min : MainAxisSize.max,
            children: _buildSequenceItems(itemSize),
          );

          // Wrap in horizontal scroll view if items don't fit
          if (needsScroll) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: content,
            );
          }

          return content;
        },
      ),
    );
  }

  List<Widget> _buildSequenceItems(double itemSize) {
    final List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      // Get translated caption if language is provided
      final caption = contentLanguage != null
          ? ContentTranslations.getCaption(items[i].id, contentLanguage!)
          : items[i].caption;

      // Add the story item
      widgets.add(_StoryItem(
        item: items[i],
        caption: caption,
        size: itemSize,
        onTap: onItemTap != null ? () => onItemTap!(items[i]) : null,
      ));

      // Add arrow between items (not after the last one)
      if (i < items.length - 1) {
        widgets.add(_ArrowConnector(
          width: arrowWidth,
          horizontalPadding: arrowPadding,
          imageSize: itemSize,
        ));
      }
    }

    return widgets;
  }
}

/// Individual item in the story sequence with image and caption.
/// Includes tap feedback animation.
class _StoryItem extends StatelessWidget {
  final DentalItem item;
  final String caption;
  final double size;
  final VoidCallback? onTap;

  const _StoryItem({
    required this.item,
    required this.caption,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: caption,
      button: true,
      child: TappableCard(
        onTap: onTap,
        child: SizedBox(
          width: size,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image container with blue border
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.appCardBorder,
                    width: AppConstants.cardBorderWidth,
                  ),
                  borderRadius:
                      BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.cardBorderRadius -
                        AppConstants.cardBorderWidth,
                  ),
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: context.appBackground,
                        child: Icon(
                          Icons.medical_services_outlined,
                          size: 48,
                          color: context.appCardBorder,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Caption text
              Text(
                caption,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.captionFontSize,
                  color: context.appTextSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Arrow connector between story items with horizontal padding.
class _ArrowConnector extends StatelessWidget {
  final double width;
  final double horizontalPadding;
  final double imageSize;

  const _ArrowConnector({
    required this.width,
    required this.horizontalPadding,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        width: width,
        // Center arrow vertically with the image (half of image size)
        child: Padding(
          padding: EdgeInsets.only(top: imageSize / 2 - 8),
          child: CustomPaint(
            size: Size(width, 16),
            painter: _ArrowPainter(color: context.appCardBorder),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for drawing an arrow pointing right.
class _ArrowPainter extends CustomPainter {
  final Color color;

  _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final arrowHeadSize = size.height * 0.5;
    final centerY = size.height / 2;

    // Draw the line
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width - arrowHeadSize, centerY),
      paint,
    );

    // Draw the arrow head
    final arrowPath = Path()
      ..moveTo(size.width - arrowHeadSize, centerY - arrowHeadSize)
      ..lineTo(size.width, centerY)
      ..lineTo(size.width - arrowHeadSize, centerY + arrowHeadSize);

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
