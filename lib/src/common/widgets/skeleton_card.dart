import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../theme/app_colors.dart';

/// A skeleton loading placeholder for library cards.
/// Shows a shimmering animation while content is loading.
/// Uses TickerMode to automatically pause animation when not visible.
class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  // Cache gradient stops to avoid repeated allocations
  static const _gradientStops = [0.0, 0.5, 1.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? AppColors.skeletonBaseDark
        : AppColors.skeletonBase;
    final highlightColor = isDark
        ? AppColors.skeletonHighlightDark
        : AppColors.skeletonHighlight;
    final colors = [baseColor, highlightColor, baseColor];

    // RepaintBoundary isolates this animation from causing unnecessary repaints
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        // Pre-build static children to avoid rebuilding them every frame
        child: const _SkeletonLayout(),
        builder: (context, child) {
          final shimmerValue = _shimmerAnimation.value;
          final gradient = LinearGradient(
            begin: Alignment(shimmerValue - 1, 0),
            end: Alignment(shimmerValue, 0),
            colors: colors,
            stops: _gradientStops,
          );

          return _ShimmerGradientProvider(gradient: gradient, child: child!);
        },
      ),
    );
  }
}

/// Inherited widget to pass gradient down without rebuilding the tree
class _ShimmerGradientProvider extends InheritedWidget {
  final LinearGradient gradient;

  const _ShimmerGradientProvider({
    required this.gradient,
    required super.child,
  });

  static LinearGradient of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ShimmerGradientProvider>()!
        .gradient;
  }

  @override
  bool updateShouldNotify(_ShimmerGradientProvider oldWidget) {
    return gradient != oldWidget.gradient;
  }
}

/// Static layout for skeleton card - built once, uses InheritedWidget for gradient
class _SkeletonLayout extends StatelessWidget {
  const _SkeletonLayout();

  // Cache border radius values
  static final _cardBorderRadius = BorderRadius.circular(
    AppConstants.cardBorderRadius,
  );
  static final _captionBorderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Square image placeholder
        AspectRatio(
          aspectRatio: 1.0,
          child: _ShimmerBox(borderRadius: _cardBorderRadius),
        ),
        const SizedBox(height: 12),
        // Caption placeholder - two lines
        _ShimmerBox(
          borderRadius: _captionBorderRadius,
          height: 14,
          width: double.infinity,
        ),
        const SizedBox(height: 6),
        _ShimmerBox(borderRadius: _captionBorderRadius, height: 14, width: 80),
      ],
    );
  }
}

/// Individual shimmer box that reads gradient from InheritedWidget
class _ShimmerBox extends StatelessWidget {
  final BorderRadius borderRadius;
  final double? height;
  final double? width;

  const _ShimmerBox({required this.borderRadius, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final gradient = _ShimmerGradientProvider.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: borderRadius, gradient: gradient),
      child: SizedBox(height: height, width: width),
    );
  }
}

/// A skeleton grid showing multiple skeleton cards
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double spacing;
  final EdgeInsets padding;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 3,
    this.spacing = 16,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 0.7,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => const SkeletonCard(),
      ),
    );
  }
}
