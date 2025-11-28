import 'package:flutter/material.dart';

/// Minimum touch target size recommended by accessibility guidelines.
/// Both iOS and Android recommend at least 44x44 points, Material Design recommends 48x48.
const double kMinTouchTargetSize = 48.0;

/// Wraps a child widget to ensure it meets minimum touch target size requirements.
/// This helps ensure accessibility compliance for interactive elements.
///
/// Usage:
/// ```dart
/// AccessibleTapTarget(
///   onTap: () => doSomething(),
///   child: Icon(Icons.close, size: 24),
/// )
/// ```
class AccessibleTapTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final double minSize;

  const AccessibleTapTarget({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.minSize = kMinTouchTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// An IconButton that ensures minimum touch target size for accessibility.
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double iconSize;
  final double minTouchSize;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.iconSize = 24.0,
    this.minTouchSize = kMinTouchTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(minTouchSize / 2),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minTouchSize,
              minHeight: minTouchSize,
            ),
            child: Center(
              child: Icon(icon, size: iconSize, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to easily make any widget accessible with proper touch targets
extension AccessibleWidget on Widget {
  /// Wraps this widget with accessible tap target sizing
  Widget withAccessibleTapTarget({
    VoidCallback? onTap,
    String? semanticLabel,
    double minSize = kMinTouchTargetSize,
  }) {
    return AccessibleTapTarget(
      onTap: onTap,
      semanticLabel: semanticLabel,
      minSize: minSize,
      child: this,
    );
  }
}
