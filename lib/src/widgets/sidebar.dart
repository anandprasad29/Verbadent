import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../routing/routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Data class for sidebar navigation items.
class SidebarItemData {
  final String label;
  final String route;
  final String testKey;

  const SidebarItemData({
    required this.label,
    required this.route,
    required this.testKey,
  });
}

/// Configuration for sidebar navigation items.
class SidebarConfig {
  static const List<SidebarItemData> items = [
    SidebarItemData(
      label: 'Before the visit',
      route: Routes.beforeVisit,
      testKey: 'sidebar_item_before_visit',
    ),
    SidebarItemData(
      label: 'During the visit',
      route: Routes.duringVisit,
      testKey: 'sidebar_item_during_visit',
    ),
    SidebarItemData(
      label: 'Build your own',
      route: Routes.buildOwn,
      testKey: 'sidebar_item_build_own',
    ),
    SidebarItemData(
      label: 'Library',
      route: Routes.library,
      testKey: 'sidebar_item_library',
    ),
  ];

  // Private constructor
  SidebarConfig._();
}

/// Shared sidebar widget used across pages for navigation.
/// Contains navigation buttons for all main sections of the app.
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current route to highlight active item
    // Safely access route state (may not exist in tests)
    String currentRoute = '';
    try {
      currentRoute = GoRouterState.of(context).uri.path;
    } catch (_) {
      // GoRouter not available (e.g., in tests), leave route empty
    }

    return Container(
      color: AppColors.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppConstants.sidebarTopSpacing),
          ...SidebarConfig.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.sidebarItemSpacing),
            child: SidebarItem(
              key: Key(item.testKey),
              label: item.label,
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
        ],
      ),
    );
  }
}

/// Individual sidebar navigation item.
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.sidebarItemHeight,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.sidebarItemActive 
              : AppColors.sidebarItemBackground,
          border: isActive 
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: isActive 
                ? AppTextStyles.sidebarItemActive 
                : AppTextStyles.sidebarItem,
          ),
        ),
      ),
    );
  }
}
