import 'package:flutter/material.dart';
import '../../../../common/domain/dental_item.dart';
import '../../../../common/widgets/tappable_card.dart';
import '../../../../constants/app_constants.dart';
import '../../../../theme/app_colors.dart';

/// A selectable version of the library card for template building.
/// Shows a checkmark overlay when selected and highlights the border.
/// Includes smooth animations for selection state changes.
class SelectableLibraryCard extends StatelessWidget {
  final DentalItem item;
  final String caption;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableLibraryCard({
    super.key,
    required this.item,
    required this.caption,
    required this.isSelected,
    required this.onTap,
  });

  static const _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$caption${isSelected ? ', selected' : ''}',
      button: true,
      child: TappableCard(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Square image container with selection state
            AspectRatio(
              aspectRatio: 1.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate optimal cache size based on display size and pixel ratio
                  final displaySize = constraints.maxWidth;
                  final pixelRatio = MediaQuery.devicePixelRatioOf(context);
                  final cacheSize = (displaySize * pixelRatio).ceil();

                  return Stack(
                    children: [
                      // Image container with animated border
                      AnimatedContainer(
                        duration: _animationDuration,
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? context.appPrimary
                                : context.appCardBorder,
                            width: isSelected
                                ? AppConstants.cardBorderWidth + 1
                                : AppConstants.cardBorderWidth,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.cardBorderRadius,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.cardBorderRadius -
                                AppConstants.cardBorderWidth,
                          ),
                          child: Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            cacheWidth: cacheSize,
                            cacheHeight: cacheSize,
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
                      // Animated selection overlay
                      Positioned.fill(
                        child: AnimatedOpacity(
                          duration: _animationDuration,
                          opacity: isSelected ? 1.0 : 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.appPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                AppConstants.cardBorderRadius,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Animated badge (checkmark or plus)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: AnimatedSwitcher(
                          duration: _animationDuration,
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: isSelected
                              ? Container(
                                  key: const ValueKey('selected'),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.appPrimary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              : Container(
                                  key: const ValueKey('unselected'),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.appCardBackground.withValues(
                                      alpha: 0.8,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.appCardBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: context.appNeutral,
                                    size: 14,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Caption text with animated color
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: _animationDuration,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.captionFontSize,
                  color: isSelected
                      ? context.appPrimary
                      : context.appTextSecondary,
                ),
                child: Text(
                  caption,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A removable version of the library card for edit mode.
/// Shows an X overlay when in edit mode to indicate tap-to-remove.
class RemovableLibraryCard extends StatelessWidget {
  final DentalItem item;
  final String caption;
  final bool showRemoveOverlay;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const RemovableLibraryCard({
    super.key,
    required this.item,
    required this.caption,
    this.showRemoveOverlay = false,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: caption,
      button: true,
      child: TappableCard(
        onTap: showRemoveOverlay ? onRemove : onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final displaySize = constraints.maxWidth;
                  final pixelRatio = MediaQuery.devicePixelRatioOf(context);
                  final cacheSize = (displaySize * pixelRatio).ceil();

                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: showRemoveOverlay
                                ? context.appError
                                : context.appCardBorder,
                            width: AppConstants.cardBorderWidth,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.cardBorderRadius,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.cardBorderRadius -
                                AppConstants.cardBorderWidth,
                          ),
                          child: Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            cacheWidth: cacheSize,
                            cacheHeight: cacheSize,
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
                      // Remove overlay
                      if (showRemoveOverlay)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: context.appError,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
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
            ),
          ],
        ),
      ),
    );
  }
}

/// A draggable version of the library card for reordering in edit mode.
/// Shows drag handle and remove button. Can be dragged to reorder.
class DraggableLibraryCard extends StatelessWidget {
  final DentalItem item;
  final String caption;
  final VoidCallback onRemove;
  final int index;

  const DraggableLibraryCard({
    super.key,
    required this.item,
    required this.caption,
    required this.onRemove,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final displaySize = constraints.maxWidth;
              final pixelRatio = MediaQuery.devicePixelRatioOf(context);
              final cacheSize = (displaySize * pixelRatio).ceil();

              return Stack(
                children: [
                  // Image container
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.appPrimary,
                        width: AppConstants.cardBorderWidth,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.cardBorderRadius,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.cardBorderRadius -
                            AppConstants.cardBorderWidth,
                      ),
                      child: Image.asset(
                        item.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        cacheWidth: cacheSize,
                        cacheHeight: cacheSize,
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
                  // Drag handle indicator at top left
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.appCardBackground.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.drag_indicator,
                        color: context.appNeutral,
                        size: 18,
                      ),
                    ),
                  ),
                  // Remove button at top right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.appError,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Order number badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.appPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.captionFontSize,
            color: context.appTextSecondary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// A reorderable wrap widget that allows drag-and-drop reordering of children.
/// Wraps children in a flow layout and supports reordering via drag.
/// Works on both mobile (long-press to drag) and web/desktop (click to drag).
///
/// **Important**: Children must be `SizedBox` widgets with explicit width and height
/// so the drag feedback can maintain proper dimensions during drag operations.
class ReorderableWrap extends StatefulWidget {
  /// Children must be SizedBox widgets with explicit width/height for drag feedback.
  final List<SizedBox> children;
  final double spacing;
  final double runSpacing;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ReorderableWrap({
    super.key,
    required this.children,
    required this.onReorder,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  @override
  State<ReorderableWrap> createState() => _ReorderableWrapState();
}

class _ReorderableWrapState extends State<ReorderableWrap> {
  int? _draggedIndex;
  int? _targetIndex;

  /// Check if we're on a touch-primary platform (mobile/tablet)
  bool _isTouchPlatform(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    final isTouchPlatform = _isTouchPlatform(context);

    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final sizedChild = entry.value;

        return DragTarget<int>(
          onWillAcceptWithDetails: (details) {
            setState(() {
              _targetIndex = index;
            });
            return details.data != index;
          },
          onLeave: (_) {
            setState(() {
              _targetIndex = null;
            });
          },
          onAcceptWithDetails: (details) {
            widget.onReorder(details.data, index);
            setState(() {
              _targetIndex = null;
            });
          },
          builder: (context, candidateData, rejectedData) {
            final isTarget = _targetIndex == index && _draggedIndex != index;
            final isDragging = _draggedIndex == index;

            final feedbackWidget = Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
              child: Opacity(
                opacity: 0.9,
                child: SizedBox(
                  width: sizedChild.width,
                  height: sizedChild.height,
                  child: sizedChild.child,
                ),
              ),
            );

            final childWhenDraggingWidget = Opacity(
              opacity: 0.3,
              child: sizedChild,
            );

            final decoratedChild = AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: isDragging
                  ? Matrix4.identity()
                  : (isTarget
                        ? (Matrix4.identity()..scale(1.05, 1.05, 1.0))
                        : Matrix4.identity()),
              decoration: isTarget
                  ? BoxDecoration(
                      border: Border.all(color: context.appPrimary, width: 3),
                      borderRadius: BorderRadius.circular(
                        AppConstants.cardBorderRadius,
                      ),
                    )
                  : null,
              child: sizedChild,
            );

            // Use LongPressDraggable on touch platforms for better UX
            // Use regular Draggable on web/desktop for click-to-drag
            if (isTouchPlatform) {
              return LongPressDraggable<int>(
                data: index,
                delay: const Duration(milliseconds: 200),
                hapticFeedbackOnStart: true,
                feedback: feedbackWidget,
                childWhenDragging: childWhenDraggingWidget,
                onDragStarted: () {
                  setState(() {
                    _draggedIndex = index;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    _draggedIndex = null;
                    _targetIndex = null;
                  });
                },
                child: decoratedChild,
              );
            } else {
              return Draggable<int>(
                data: index,
                feedback: feedbackWidget,
                childWhenDragging: childWhenDraggingWidget,
                onDragStarted: () {
                  setState(() {
                    _draggedIndex = index;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    _draggedIndex = null;
                    _targetIndex = null;
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: decoratedChild,
                ),
              );
            }
          },
        );
      }).toList(),
    );
  }
}
