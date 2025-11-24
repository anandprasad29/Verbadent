import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:verbadent/src/features/library/presentation/library_page.dart';
import 'package:verbadent/src/features/library/presentation/widgets/library_card.dart';

void main() {
  // Load fonts for golden tests
  setUpAll(() async {
    await loadAppFonts();
  });

  /// Creates a test router with LibraryPage as the initial route
  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/library',
      routes: [
        GoRoute(
          path: '/library',
          name: 'library',
          builder: (context, state) => const LibraryPage(),
        ),
      ],
    );
  }

  group('LibraryPage Widget Tests', () {
    testWidgets('renders Library header in SliverAppBar', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find the SliverAppBar
      expect(find.byType(SliverAppBar), findsOneWidget);

      // Find the Library header text within FlexibleSpaceBar
      final flexSpaceBarFinder = find.byType(FlexibleSpaceBar);
      expect(flexSpaceBarFinder, findsOneWidget);

      // Verify the title text exists within the FlexibleSpaceBar
      expect(
        find.descendant(
          of: flexSpaceBarFinder,
          matching: find.text('Library'),
        ),
        findsOneWidget,
      );

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders 5 columns on desktop (>=1200px)', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find the SliverGrid
      final gridFinder = find.byType(SliverGrid);
      expect(gridFinder, findsOneWidget);

      // Verify grid has 5 columns by checking the delegate
      final grid = tester.widget<SliverGrid>(gridFinder);
      final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(5));

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders 3 columns on tablet (600-1199px)', (tester) async {
      tester.view.physicalSize = const Size(900, 700);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find the SliverGrid
      final gridFinder = find.byType(SliverGrid);
      expect(gridFinder, findsOneWidget);

      // Verify grid has 3 columns
      final grid = tester.widget<SliverGrid>(gridFinder);
      final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders 2 columns on mobile (<600px)', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find the SliverGrid
      final gridFinder = find.byType(SliverGrid);
      expect(gridFinder, findsOneWidget);

      // Verify grid has 2 columns
      final grid = tester.widget<SliverGrid>(gridFinder);
      final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(2));

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('displays LibraryCard items in grid', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Verify LibraryCard widgets are rendered
      expect(find.byType(LibraryCard), findsWidgets);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses SliverAppBar for collapsible header', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Verify SliverAppBar is present
      final appBarFinder = find.byType(SliverAppBar);
      expect(appBarFinder, findsOneWidget);

      // Verify SliverAppBar is pinned (stays visible when scrolled)
      final appBar = tester.widget<SliverAppBar>(appBarFinder);
      expect(appBar.pinned, isTrue);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('header collapses on scroll', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Get initial SliverAppBar expanded height
      final appBarFinder = find.byType(SliverAppBar);
      final appBar = tester.widget<SliverAppBar>(appBarFinder);
      expect(appBar.expandedHeight, isNotNull);
      expect(appBar.expandedHeight, greaterThan(0));

      // Scroll down
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Header should still be visible (pinned) but collapsed
      expect(appBarFinder, findsOneWidget);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses CustomScrollView for scrolling', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Verify CustomScrollView is present
      expect(find.byType(CustomScrollView), findsOneWidget);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('displays sample dental content', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Verify at least some dental-related captions are present
      expect(
        find.textContaining('dentist'),
        findsWidgets,
      );

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
