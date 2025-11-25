import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../theme/app_colors.dart';

/// A skeleton loading placeholder for library cards.
/// Shows a shimmering animation while content is loading.
class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

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
    final baseColor =
        isDark ? AppColors.skeletonBaseDark : AppColors.skeletonBase;
    final highlightColor =
        isDark ? AppColors.skeletonHighlightDark : AppColors.skeletonHighlight;

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Square image placeholder
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.cardBorderRadius),
                  gradient: LinearGradient(
                    begin: Alignment(_shimmerAnimation.value - 1, 0),
                    end: Alignment(_shimmerAnimation.value, 0),
                    colors: [
                      baseColor,
                      highlightColor,
                      baseColor,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Caption placeholder - two lines
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment(_shimmerAnimation.value - 1, 0),
                  end: Alignment(_shimmerAnimation.value, 0),
                  colors: [
                    baseColor,
                    highlightColor,
                    baseColor,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 14,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment(_shimmerAnimation.value - 1, 0),
                  end: Alignment(_shimmerAnimation.value, 0),
                  colors: [
                    baseColor,
                    highlightColor,
                    baseColor,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        );
      },
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
