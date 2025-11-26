import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/before_visit/presentation/before_visit_page.dart';
import '../features/build_own/presentation/build_own_page.dart';
import '../features/build_own/presentation/custom_template_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/library/presentation/library_page.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Page transition duration
const _transitionDuration = Duration(milliseconds: 300);

/// Creates a custom page with fade transition
CustomTransitionPage<void> _buildPageWithTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: _transitionDuration,
    reverseTransitionDuration: _transitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade transition with subtle slide from right
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.03, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}

/// GoRouter provider with keepAlive to prevent disposal during navigation.
/// AutoDispose would cause router recreation and navigation issues.
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.home,
        name: 'home',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const DashboardPage(),
        ),
      ),
      GoRoute(
        path: Routes.library,
        name: 'library',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const LibraryPage(),
        ),
      ),
      GoRoute(
        path: Routes.beforeVisit,
        name: 'beforeVisit',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const BeforeVisitPage(),
        ),
      ),
      // Placeholder routes for future pages
      GoRoute(
        path: Routes.duringVisit,
        name: 'duringVisit',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const DashboardPage(), // TODO: Create DuringVisitPage
        ),
      ),
      GoRoute(
        path: Routes.buildOwn,
        name: 'buildOwn',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const BuildOwnPage(),
        ),
      ),
      // Dynamic route for custom templates
      GoRoute(
        path: '/template/:id',
        name: 'customTemplate',
        pageBuilder: (context, state) {
          final templateId = state.pathParameters['id']!;
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: CustomTemplatePage(templateId: templateId),
          );
        },
      ),
    ],
  );
}
