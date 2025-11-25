import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';

/// A toggle button for switching between light and dark mode.
/// Shows a sun/moon icon with smooth animation.
class ThemeToggle extends ConsumerWidget {
  final double size;

  const ThemeToggle({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final notifier = ref.read(themeModeNotifierProvider.notifier);
    final isDark = themeMode == AppThemeMode.dark;

    return GestureDetector(
      onTap: () => notifier.toggle(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.sidebarItemActiveDark
              : AppColors.sidebarItemActive,
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              key: ValueKey(isDark),
              size: size * 0.5,
              color: isDark ? AppColors.primaryDarkMode : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// A more compact theme toggle for app bar placement
class ThemeToggleCompact extends ConsumerWidget {
  const ThemeToggleCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final notifier = ref.read(themeModeNotifierProvider.notifier);
    final isDark = themeMode == AppThemeMode.dark;

    return IconButton(
      onPressed: () => notifier.toggle(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          key: ValueKey(isDark),
          color: isDark ? AppColors.primaryDarkMode : AppColors.primary,
        ),
      ),
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
    );
  }
}
