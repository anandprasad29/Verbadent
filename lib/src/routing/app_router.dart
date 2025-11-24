import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/library/presentation/library_page.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.home,
        name: 'home',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: Routes.library,
        name: 'library',
        builder: (context, state) => const LibraryPage(),
      ),
      // Placeholder routes for future pages
      GoRoute(
        path: Routes.beforeVisit,
        name: 'beforeVisit',
        builder: (context, state) =>
            const DashboardPage(), // TODO: Create BeforeVisitPage
      ),
      GoRoute(
        path: Routes.duringVisit,
        name: 'duringVisit',
        builder: (context, state) =>
            const DashboardPage(), // TODO: Create DuringVisitPage
      ),
      GoRoute(
        path: Routes.buildOwn,
        name: 'buildOwn',
        builder: (context, state) =>
            const DashboardPage(), // TODO: Create BuildOwnPage
      ),
    ],
  );
}
