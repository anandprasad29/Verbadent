import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import 'language_selector.dart';
import 'sidebar.dart';
import 'theme_toggle.dart';

/// Shared application shell that provides consistent layout across pages.
/// Handles responsive design with sidebar (desktop) or drawer (mobile).
class AppShell extends StatelessWidget {
  /// The main content of the page
  final Widget child;

  /// Optional app bar title for mobile layout
  final String? title;

  /// Whether to show the hamburger menu on mobile (defaults to true)
  final bool showDrawer;

  /// Whether to show the language selector (defaults to true)
  /// Set to false for dashboard page
  final bool showLanguageSelector;

  const AppShell({
    super.key,
    required this.child,
    this.title,
    this.showDrawer = true,
    this.showLanguageSelector = true,
  });

  @override
  Widget build(BuildContext context) {
    final isWideScreen =
        MediaQuery.of(context).size.width >= AppConstants.sidebarBreakpoint;

    if (isWideScreen) {
      return _buildDesktopLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  /// Desktop layout with permanent sidebar
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: Row(
        children: [
          const SizedBox(
            width: AppConstants.sidebarWidth,
            child: Sidebar(),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: context.appBackground,
                  child: child,
                ),
                if (showLanguageSelector)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LanguageSelector(),
                        const SizedBox(width: 8),
                        const ThemeToggleCompact(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile layout with hamburger menu and drawer
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: context.appSidebarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'KumarOne',
                ),
              )
            : null,
        leading: showDrawer
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        actions: [
          if (showLanguageSelector)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: LanguageSelector(),
            ),
          const ThemeToggleCompact(),
          const SizedBox(width: 4),
        ],
      ),
      drawer: showDrawer
          ? const Drawer(
              width: AppConstants.sidebarWidth,
              child: Sidebar(),
            )
          : null,
      body: Container(
        color: context.appBackground,
        child: child,
      ),
    );
  }
}
