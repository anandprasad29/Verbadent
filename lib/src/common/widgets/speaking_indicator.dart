import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// An animated indicator showing that TTS is currently speaking.
/// Displays pulsing sound wave bars.
class SpeakingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const SpeakingIndicator({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  State<SpeakingIndicator> createState() => _SpeakingIndicatorState();
}

class _SpeakingIndicatorState extends State<SpeakingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = widget.color ?? context.appSpeakingIndicator;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Stagger the animations for each bar
              final delay = index * 0.2;
              final progress = (_controller.value + delay) % 1.0;
              final height = 0.3 + (0.7 * _calculateHeight(progress));

              return Container(
                width: widget.size * 0.15,
                height: widget.size * height,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(widget.size * 0.1),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  double _calculateHeight(double progress) {
    // Use a sine wave for smooth animation
    return (1 + (progress * 3.14159 * 2).sin()) / 2;
  }
}

/// Extension for sin function
extension on double {
  double sin() => _sin(this);
}

double _sin(double radians) {
  // Simple sin approximation for animation
  // Using dart:math would be cleaner but this keeps it self-contained
  double x = radians % (2 * 3.14159);
  if (x > 3.14159) x -= 2 * 3.14159;

  // Taylor series approximation
  double result = x;
  double term = x;
  for (int i = 1; i <= 5; i++) {
    term *= -x * x / ((2 * i) * (2 * i + 1));
    result += term;
  }
  return result;
}

/// A badge overlay that shows when an item is speaking.
/// Wraps any widget and shows a speaking indicator in the corner.
class SpeakingBadge extends StatelessWidget {
  final Widget child;
  final bool isSpeaking;
  final double indicatorSize;

  const SpeakingBadge({
    super.key,
    required this.child,
    required this.isSpeaking,
    this.indicatorSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isSpeaking)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(indicatorSize),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SpeakingIndicator(size: indicatorSize),
            ),
          ),
      ],
    );
  }
}
