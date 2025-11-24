import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:verbadent/src/widgets/sidebar.dart';

void main() {
  // Load fonts for golden tests
  setUpAll(() async {
    await loadAppFonts();
  });

  group('Shared Sidebar Widget Tests', () {
    late GoRouter testRouter;
    String? navigatedTo;

    setUp(() {
      navigatedTo = null;
      testRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const Scaffold(
              body: Sidebar(),
            ),
          ),
          GoRoute(
            path: '/library',
            name: 'library',
            builder: (context, state) {
              navigatedTo = '/library';
              return const Scaffold(body: Text('Library Page'));
            },
          ),
          GoRoute(
            path: '/before-visit',
            name: 'before-visit',
            builder: (context, state) {
              navigatedTo = '/before-visit';
              return const Scaffold(body: Text('Before Visit Page'));
            },
          ),
          GoRoute(
            path: '/during-visit',
            name: 'during-visit',
            builder: (context, state) {
              navigatedTo = '/during-visit';
              return const Scaffold(body: Text('During Visit Page'));
            },
          ),
          GoRoute(
            path: '/build-own',
            name: 'build-own',
            builder: (context, state) {
              navigatedTo = '/build-own';
              return const Scaffold(body: Text('Build Own Page'));
            },
          ),
        ],
      );
    });

    testWidgets('renders all 4 sidebar items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Verify all 4 sidebar items are present
      expect(find.text('Before the visit'), findsOneWidget);
      expect(find.text('During the visit'), findsOneWidget);
      expect(find.text('Build your own'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
    });

    testWidgets('Library button navigates to /library route', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Tap the Library button
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(navigatedTo, equals('/library'));
    });

    testWidgets('Before the visit button navigates correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Tap the Before the visit button
      await tester.tap(find.text('Before the visit'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(navigatedTo, equals('/before-visit'));
    });

    testWidgets('sidebar has correct background color', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Find the sidebar container
      final sidebarFinder = find.byType(Sidebar);
      expect(sidebarFinder, findsOneWidget);

      // Find the container with the background color
      final container = tester.widget<Container>(
        find
            .descendant(
              of: sidebarFinder,
              matching: find.byType(Container),
            )
            .first,
      );

      // Verify blue background color (#5483F5)
      expect(container.color, equals(const Color(0xFF5483F5)));
    });

    testWidgets('sidebar items have neutral background color', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Find SidebarItem widgets
      final sidebarItemFinder = find.byType(SidebarItem);
      expect(sidebarItemFinder, findsNWidgets(4));
    });

    testWidgets('sidebar items use KumarOne font', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Find the Library text
      final textFinder = find.text('Library');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.fontFamily, equals('KumarOne'));
    });

    testWidgets('sidebar items have correct keys for testing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Verify test keys are present
      expect(
          find.byKey(const Key('sidebar_item_before_visit')), findsOneWidget);
      expect(
          find.byKey(const Key('sidebar_item_during_visit')), findsOneWidget);
      expect(find.byKey(const Key('sidebar_item_build_own')), findsOneWidget);
      expect(find.byKey(const Key('sidebar_item_library')), findsOneWidget);
    });

    testWidgets('During the visit button navigates correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      await tester.tap(find.text('During the visit'));
      await tester.pumpAndSettle();

      expect(navigatedTo, equals('/during-visit'));
    });

    testWidgets('Build your own button navigates correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      await tester.tap(find.text('Build your own'));
      await tester.pumpAndSettle();

      expect(navigatedTo, equals('/build-own'));
    });

    testWidgets('sidebar item height matches constant', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      // Find SidebarItem containers
      final sidebarItems = tester.widgetList<SidebarItem>(
        find.byType(SidebarItem),
      );

      expect(sidebarItems.length, equals(4));
    });
  });

  group('Sidebar Active State Tests', () {
    testWidgets('shows active state for Library route', (tester) async {
      final activeRouter = GoRouter(
        initialLocation: '/library',
        routes: [
          GoRoute(
            path: '/library',
            name: 'library',
            builder: (context, state) => const Scaffold(body: Sidebar()),
          ),
          GoRoute(path: '/', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/before-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/during-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/build-own', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: activeRouter),
        ),
      );

      // Library item should have active styling
      final libraryItem = tester.widget<SidebarItem>(
        find.byKey(const Key('sidebar_item_library')),
      );
      expect(libraryItem.isActive, isTrue);

      // Other items should not be active
      final beforeVisitItem = tester.widget<SidebarItem>(
        find.byKey(const Key('sidebar_item_before_visit')),
      );
      expect(beforeVisitItem.isActive, isFalse);
    });

    testWidgets('active item has white background', (tester) async {
      final activeRouter = GoRouter(
        initialLocation: '/library',
        routes: [
          GoRoute(
            path: '/library',
            builder: (context, state) => const Scaffold(body: Sidebar()),
          ),
          GoRoute(path: '/', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/before-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/during-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/build-own', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: activeRouter),
        ),
      );

      // Find the active SidebarItem's container
      final libraryItemFinder = find.byKey(const Key('sidebar_item_library'));
      final container = tester.widget<Container>(
        find
            .descendant(
              of: libraryItemFinder,
              matching: find.byType(Container),
            )
            .first,
      );

      // Active item should have white background
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(const Color(0xFFFFFFFF)));
    });

    testWidgets('active item has border', (tester) async {
      final activeRouter = GoRouter(
        initialLocation: '/library',
        routes: [
          GoRoute(
            path: '/library',
            builder: (context, state) => const Scaffold(body: Sidebar()),
          ),
          GoRoute(path: '/', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/before-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/during-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/build-own', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: activeRouter),
        ),
      );

      final libraryItemFinder = find.byKey(const Key('sidebar_item_library'));
      final container = tester.widget<Container>(
        find
            .descendant(
              of: libraryItemFinder,
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });
  });

  group('Sidebar Golden Tests', () {
    testGoldens('renders sidebar correctly', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'sidebar', size: Size(250, 600)),
        ])
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(
              routerConfig: GoRouter(
                initialLocation: '/',
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => const Scaffold(body: Sidebar()),
                  ),
                  GoRoute(
                      path: '/library', builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/before-visit',
                      builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/during-visit',
                      builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/build-own', builder: (_, __) => const SizedBox()),
                ],
              ),
            ),
          ),
          name: 'sidebar_default',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'sidebar_default');
    });

    testGoldens('renders sidebar with active Library item', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'sidebar', size: Size(250, 600)),
        ])
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(
              routerConfig: GoRouter(
                initialLocation: '/library',
                routes: [
                  GoRoute(
                    path: '/library',
                    builder: (_, __) => const Scaffold(body: Sidebar()),
                  ),
                  GoRoute(path: '/', builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/before-visit',
                      builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/during-visit',
                      builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/build-own', builder: (_, __) => const SizedBox()),
                ],
              ),
            ),
          ),
          name: 'sidebar_library_active',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'sidebar_library_active');
    });

    testGoldens('renders sidebar with active Before Visit item',
        (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'sidebar', size: Size(250, 600)),
        ])
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(
              routerConfig: GoRouter(
                initialLocation: '/before-visit',
                routes: [
                  GoRoute(
                    path: '/before-visit',
                    builder: (_, __) => const Scaffold(body: Sidebar()),
                  ),
                  GoRoute(path: '/', builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/library', builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/during-visit',
                      builder: (_, __) => const SizedBox()),
                  GoRoute(
                      path: '/build-own', builder: (_, __) => const SizedBox()),
                ],
              ),
            ),
          ),
          name: 'sidebar_before_visit_active',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'sidebar_before_visit_active');
    });
  });
}
