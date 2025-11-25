import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';
import '../routing/routes.dart';
import '../theme/app_colors.dart';
import 'theme_toggle.dart';

/// Data class for sidebar navigation items.
/// Uses a localization key instead of hardcoded label.
class SidebarItemData {
  /// Localization key for the label (resolved at runtime)
  final String labelKey;
  final String route;
  final String testKey;

  const SidebarItemData({
    required this.labelKey,
    required this.route,
    required this.testKey,
  });

  /// Get the localized label using the provided AppLocalizations
  String getLabel(AppLocalizations? l10n) {
    switch (labelKey) {
      case 'navBeforeVisit':
        return l10n?.navBeforeVisit ?? 'Before the visit';
      case 'navDuringVisit':
        return l10n?.navDuringVisit ?? 'During the visit';
      case 'navBuildOwn':
        return l10n?.navBuildOwn ?? 'Build your own';
      case 'navLibrary':
        return l10n?.navLibrary ?? 'Library';
      default:
        return labelKey;
    }
  }
}

/// Configuration for sidebar navigation items.
class SidebarConfig {
  static const List<SidebarItemData> items = [
    SidebarItemData(
      labelKey: 'navBeforeVisit',
      route: Routes.beforeVisit,
      testKey: 'sidebar_item_before_visit',
    ),
    SidebarItemData(
      labelKey: 'navDuringVisit',
      route: Routes.duringVisit,
      testKey: 'sidebar_item_during_visit',
    ),
    SidebarItemData(
      labelKey: 'navBuildOwn',
      route: Routes.buildOwn,
      testKey: 'sidebar_item_build_own',
    ),
    SidebarItemData(
      labelKey: 'navLibrary',
      route: Routes.library,
      testKey: 'sidebar_item_library',
    ),
  ];

  // Private constructor
  SidebarConfig._();
}

/// Shared sidebar widget used across pages for navigation.
/// Contains navigation buttons for all main sections of the app.
/// Supports both light and dark themes.
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get localization
    final l10n = AppLocalizations.of(context);

    // Get current route to highlight active item
    // Safely access route state (may not exist in tests)
    String currentRoute = '';
    try {
      currentRoute = GoRouterState.of(context).uri.path;
    } catch (_) {
      // GoRouter not available (e.g., in tests), leave route empty
    }

    return Container(
      color: context.appSidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppConstants.sidebarTopSpacing),
          ...SidebarConfig.items.map((item) => Padding(
                padding: const EdgeInsets.only(
                    bottom: AppConstants.sidebarItemSpacing),
                child: SidebarItem(
                  key: Key(item.testKey),
                  label: item.getLabel(l10n),
                  isActive: currentRoute == item.route,
                  onTap: () {
                    // Close drawer if open (mobile)
                    if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
                      Navigator.of(context).pop();
                    }
                    context.go(item.route);
                  },
                ),
              )),
          const Spacer(),
          // Theme toggle at the bottom
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Center(
              child: ThemeToggle(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual sidebar navigation item.
/// Supports both light and dark themes.
class SidebarItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.sidebarItemHeight,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isActive
              ? context.appSidebarItemActive
              : context.appSidebarItemBackground,
          border:
              isActive ? Border.all(color: context.appPrimary, width: 2) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'KumarOne',
              fontSize: AppConstants.sidebarItemFontSize,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? context.appPrimary
                  : (isDark
                      ? AppColors.sidebarItemTextDark
                      : AppColors.sidebarItemText),
            ),
          ),
        ),
      ),
    );
  }
}
