import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../features/build_own/presentation/build_own_providers.dart';
import '../localization/app_localizations.dart';
import '../routing/routes.dart';
import '../theme/app_colors.dart';

/// Data class for sidebar navigation items.
/// Uses a localization key instead of hardcoded label.
class SidebarItemData {
  /// Localization key for the label (resolved at runtime)
  final String labelKey;
  final String route;
  final String testKey;

  /// If true, this is a custom template item (uses label directly)
  final bool isCustomTemplate;

  const SidebarItemData({
    required this.labelKey,
    required this.route,
    required this.testKey,
    this.isCustomTemplate = false,
  });

  /// Get the localized label using the provided AppLocalizations
  String getLabel(AppLocalizations? l10n) {
    // Custom templates use labelKey directly as the name
    if (isCustomTemplate) {
      return labelKey;
    }

    switch (labelKey) {
      case 'navBeforeVisit':
        return l10n?.navBeforeVisit ?? 'Before the visit';
      case 'navDuringVisit':
        return l10n?.navDuringVisit ?? 'During the visit';
      case 'navBuildOwn':
        return l10n?.navBuildOwn ?? 'Build your own';
      case 'navLibrary':
        return l10n?.navLibrary ?? 'Library';
      case 'navSettings':
        return l10n?.navSettings ?? 'Settings';
      case 'navVisitWorkflow':
        return l10n?.navVisitWorkflow ?? 'Visit Workflow';
      default:
        return labelKey;
    }
  }
}

/// Configuration for sidebar navigation items.
class SidebarConfig {
  /// Items inside the "Visit Workflow" accordion
  static const List<SidebarItemData> visitWorkflowItems = [
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
  ];

  /// Routes that belong to the Visit Workflow group (for auto-expand)
  static const List<String> visitWorkflowRoutes = [
    Routes.beforeVisit,
    Routes.duringVisit,
    Routes.buildOwn,
  ];

  /// Standalone items (not inside any accordion)
  static const List<SidebarItemData> standaloneItems = [
    SidebarItemData(
      labelKey: 'navLibrary',
      route: Routes.library,
      testKey: 'sidebar_item_library',
    ),
    SidebarItemData(
      labelKey: 'navSettings',
      route: Routes.settings,
      testKey: 'sidebar_item_settings',
    ),
  ];

  /// Legacy getters for backward compatibility with tests
  static const List<SidebarItemData> topItems = [
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
  ];

  static const List<SidebarItemData> bottomItems = [
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
    SidebarItemData(
      labelKey: 'navSettings',
      route: Routes.settings,
      testKey: 'sidebar_item_settings',
    ),
  ];

  static List<SidebarItemData> get items => [...topItems, ...bottomItems];

  // Private constructor
  SidebarConfig._();
}

/// Shared sidebar widget used across pages for navigation.
/// Contains navigation buttons for all main sections of the app.
/// Supports both light and dark themes.
/// Dynamically renders custom templates inside the Visit Workflow accordion.
class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> {
  bool _isExpanded = false;
  bool _hasAutoExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Get localization
    final l10n = AppLocalizations.of(context);

    // Watch only what's needed for the sidebar display (selective watching)
    final customTemplates = ref.watch(
      customTemplatesNotifierProvider.select(
        (templates) => templates.map((t) => (id: t.id, name: t.name)).toList(),
      ),
    );
    final isLoading = ref.watch(templatesLoadingProvider);
    final error = ref.watch(templatesErrorProvider);

    // Get current route to highlight active item
    String currentRoute = '';
    try {
      currentRoute = GoRouterState.of(context).uri.path;
    } catch (_) {
      // GoRouter not available (e.g., in tests), leave route empty
    }

    // Auto-expand if current route is a child of the accordion
    final isChildRouteActive =
        SidebarConfig.visitWorkflowRoutes.contains(currentRoute) ||
            currentRoute.startsWith('/template/');
    if (isChildRouteActive && !_hasAutoExpanded) {
      _isExpanded = true;
      _hasAutoExpanded = true;
    }

    // Build dynamic custom template items
    final customTemplateItems = customTemplates
        .map(
          (template) => SidebarItemData(
            labelKey: template.name,
            route: Routes.customTemplatePath(template.id),
            testKey: 'sidebar_item_template_${template.id}',
            isCustomTemplate: true,
          ),
        )
        .toList();

    return Container(
      color: context.appSidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppConstants.sidebarTopSpacing),
          // Scrollable area for nav items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Visit Workflow accordion header
                  _buildAccordionHeader(context, l10n),
                  // Accordion children (visible when expanded)
                  if (_isExpanded) ...[
                    // Static workflow items (indented)
                    ...SidebarConfig.visitWorkflowItems.map(
                      (item) => _buildSidebarItem(
                        context,
                        item,
                        l10n,
                        currentRoute,
                        indented: true,
                      ),
                    ),
                    // Loading indicator for custom templates
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.appSidebarItemText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Error indicator
                    if (error != null && !isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                      ),
                    // Dynamic custom template items (indented)
                    if (!isLoading)
                      ...customTemplateItems.map(
                        (item) => _buildSidebarItem(
                          context,
                          item,
                          l10n,
                          currentRoute,
                          indented: true,
                        ),
                      ),
                  ],
                  // Standalone items (Library, Settings)
                  ...SidebarConfig.standaloneItems.map(
                    (item) =>
                        _buildSidebarItem(context, item, l10n, currentRoute),
                  ),
                ],
              ),
            ),
          ),
          // Bottom padding
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAccordionHeader(BuildContext context, AppLocalizations? l10n) {
    final isDark = context.isDarkMode;
    final label = l10n?.navVisitWorkflow ?? 'Visit Workflow';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.sidebarItemSpacing),
      child: GestureDetector(
        key: const Key('sidebar_visit_workflow'),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Container(
          height: AppConstants.sidebarItemHeight,
          decoration: BoxDecoration(
            color: context.appSidebarItemBackground,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isExpanded
                      ? Icons.expand_more
                      : Icons.chevron_right,
                  size: 20,
                  color: isDark
                      ? AppColors.sidebarItemTextDark
                      : AppColors.sidebarItemText,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'KumarOne',
                      fontSize: AppConstants.sidebarItemFontSize,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.sidebarItemTextDark
                          : AppColors.sidebarItemText,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    SidebarItemData item,
    AppLocalizations? l10n,
    String currentRoute, {
    bool indented = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppConstants.sidebarItemSpacing,
        left: indented ? 20 : 0,
      ),
      child: SidebarItem(
        key: Key(item.testKey),
        label: item.getLabel(l10n),
        isActive: currentRoute == item.route,
        isCustomTemplate: item.isCustomTemplate,
        onTap: () {
          // Close drawer if open (mobile)
          if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
            Navigator.of(context).pop();
          }
          context.go(item.route);
        },
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
  final bool isCustomTemplate;

  const SidebarItem({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isCustomTemplate = false,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Custom template indicator icon (star)
              if (isCustomTemplate) ...[
                Icon(
                  Icons.star,
                  size: 16,
                  color: isActive
                      ? context.appPrimary
                      : (isDark
                          ? AppColors.sidebarItemTextDark
                          : AppColors.sidebarItemText),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
