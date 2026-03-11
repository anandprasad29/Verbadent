import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbident/src/widgets/sidebar.dart';

/// Helper to create a GoRouter with all needed routes for sidebar tests.
GoRouter _createTestRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Sidebar()),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const Scaffold(body: Sidebar()),
      ),
      GoRoute(
        path: '/before-visit',
        builder: (context, state) => const Scaffold(body: Sidebar()),
      ),
      GoRoute(
        path: '/during-visit',
        builder: (context, state) => const Scaffold(body: Sidebar()),
      ),
      GoRoute(
        path: '/build-own',
        builder: (context, state) => const Scaffold(body: Sidebar()),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const Scaffold(body: Sidebar()),
      ),
      GoRoute(
        path: '/template/:id',
        builder: (context, state) => const Scaffold(body: Sidebar()),
      ),
    ],
  );
}

void main() {
  // Load fonts for golden tests and setup mocks
  setUpAll(() async {
    await loadAppFonts();
    // Initialize SharedPreferences mock for tests
    SharedPreferences.setMockInitialValues({});
  });

  group('Shared Sidebar Widget Tests', () {
    testWidgets('renders Visit Workflow accordion and standalone items', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      // Visit Workflow accordion header should be visible
      expect(find.text('Visit Workflow'), findsOneWidget);

      // Standalone items should be visible
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Accordion children should NOT be visible (collapsed by default)
      expect(find.text('Before the visit'), findsNothing);
      expect(find.text('During the visit'), findsNothing);
      expect(find.text('Build your own'), findsNothing);
    });

    testWidgets('tapping Visit Workflow expands accordion', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      // Tap accordion header
      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();

      // Children should now be visible
      expect(find.text('Before the visit'), findsOneWidget);
      expect(find.text('During the visit'), findsOneWidget);
      expect(find.text('Build your own'), findsOneWidget);
    });

    testWidgets('tapping Visit Workflow twice collapses accordion', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      // Expand
      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();
      expect(find.text('Before the visit'), findsOneWidget);

      // Collapse
      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();
      expect(find.text('Before the visit'), findsNothing);
    });

    testWidgets('auto-expands when on a child route', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: _createTestRouter(initialLocation: '/before-visit'),
          ),
        ),
      );

      // Should auto-expand since we're on a child route
      expect(find.text('Before the visit'), findsOneWidget);
      expect(find.text('During the visit'), findsOneWidget);
      expect(find.text('Build your own'), findsOneWidget);
    });

    testWidgets('Library button navigates to /library route', (tester) async {
      String? navigatedTo;
      final testRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Sidebar()),
          ),
          GoRoute(
            path: '/library',
            builder: (context, state) {
              navigatedTo = '/library';
              return const Scaffold(body: Text('Library Page'));
            },
          ),
          GoRoute(path: '/before-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/during-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/build-own', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/settings', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: testRouter)),
      );

      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();

      expect(navigatedTo, equals('/library'));
    });

    testWidgets('Before the visit button navigates correctly', (
      tester,
    ) async {
      String? navigatedTo;
      final testRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Sidebar()),
          ),
          GoRoute(
            path: '/before-visit',
            builder: (context, state) {
              navigatedTo = '/before-visit';
              return const Scaffold(body: Text('Before Visit'));
            },
          ),
          GoRoute(path: '/library', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/during-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/build-own', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/settings', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: testRouter)),
      );

      // First expand the accordion
      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();

      // Then tap the child item
      await tester.tap(find.text('Before the visit'));
      await tester.pumpAndSettle();

      expect(navigatedTo, equals('/before-visit'));
    });

    testWidgets('During the visit button navigates correctly', (tester) async {
      String? navigatedTo;
      final testRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Sidebar()),
          ),
          GoRoute(
            path: '/during-visit',
            builder: (context, state) {
              navigatedTo = '/during-visit';
              return const Scaffold(body: Text('During Visit'));
            },
          ),
          GoRoute(path: '/library', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/before-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/build-own', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/settings', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: testRouter)),
      );

      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('During the visit'));
      await tester.pumpAndSettle();

      expect(navigatedTo, equals('/during-visit'));
    });

    testWidgets('Build your own button navigates correctly', (tester) async {
      String? navigatedTo;
      final testRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Sidebar()),
          ),
          GoRoute(
            path: '/build-own',
            builder: (context, state) {
              navigatedTo = '/build-own';
              return const Scaffold(body: Text('Build Own'));
            },
          ),
          GoRoute(path: '/library', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/before-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/during-visit', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/settings', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: testRouter)),
      );

      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Build your own'));
      await tester.pumpAndSettle();

      expect(navigatedTo, equals('/build-own'));
    });

    testWidgets('sidebar has correct background color', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      final sidebarFinder = find.byType(Sidebar);
      expect(sidebarFinder, findsOneWidget);

      final container = tester.widget<Container>(
        find
            .descendant(of: sidebarFinder, matching: find.byType(Container))
            .first,
      );

      expect(container.color, equals(const Color(0xFF5483F5)));
    });

    testWidgets('sidebar items use KumarOne font', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      final textFinder = find.text('Library');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.fontFamily, equals('KumarOne'));
    });

    testWidgets('sidebar items have correct keys for testing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      // Accordion header key
      expect(
        find.byKey(const Key('sidebar_visit_workflow')),
        findsOneWidget,
      );

      // Standalone item keys
      expect(find.byKey(const Key('sidebar_item_library')), findsOneWidget);
      expect(find.byKey(const Key('sidebar_item_settings')), findsOneWidget);

      // Expand to see child keys
      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('sidebar_item_before_visit')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('sidebar_item_during_visit')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('sidebar_item_build_own')), findsOneWidget);
    });

    testWidgets('accordion shows chevron_right when collapsed', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsNothing);
    });

    testWidgets('accordion shows expand_more when expanded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: _createTestRouter()),
        ),
      );

      await tester.tap(find.text('Visit Workflow'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });
  });

  group('Sidebar Active State Tests', () {
    testWidgets('shows active state for Library route', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: _createTestRouter(initialLocation: '/library'),
          ),
        ),
      );

      final libraryItem = tester.widget<SidebarItem>(
        find.byKey(const Key('sidebar_item_library')),
      );
      expect(libraryItem.isActive, isTrue);
    });

    testWidgets('shows active state for Before Visit route', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: _createTestRouter(initialLocation: '/before-visit'),
          ),
        ),
      );

      // Should auto-expand
      final beforeVisitItem = tester.widget<SidebarItem>(
        find.byKey(const Key('sidebar_item_before_visit')),
      );
      expect(beforeVisitItem.isActive, isTrue);

      final libraryItem = tester.widget<SidebarItem>(
        find.byKey(const Key('sidebar_item_library')),
      );
      expect(libraryItem.isActive, isFalse);
    });

    testWidgets('active item has white background', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: _createTestRouter(initialLocation: '/library'),
          ),
        ),
      );

      final libraryItemFinder = find.byKey(const Key('sidebar_item_library'));
      final container = tester.widget<Container>(
        find
            .descendant(of: libraryItemFinder, matching: find.byType(Container))
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(const Color(0xFFFFFFFF)));
    });

    testWidgets('active item has border', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: _createTestRouter(initialLocation: '/library'),
          ),
        ),
      );

      final libraryItemFinder = find.byKey(const Key('sidebar_item_library'));
      final container = tester.widget<Container>(
        find
            .descendant(of: libraryItemFinder, matching: find.byType(Container))
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });
  });

  group('Sidebar Golden Tests', () {
    testGoldens('renders sidebar correctly (collapsed)', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: [const Device(name: 'sidebar', size: Size(250, 600))],
        )
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(
              routerConfig: _createTestRouter(),
            ),
          ),
          name: 'sidebar_default',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'sidebar_default');
    });

    testGoldens('renders sidebar with active Library item', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: [const Device(name: 'sidebar', size: Size(250, 600))],
        )
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(
              routerConfig: _createTestRouter(initialLocation: '/library'),
            ),
          ),
          name: 'sidebar_library_active',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'sidebar_library_active');
    });

    testGoldens('renders sidebar with active Before Visit item (expanded)', (
      tester,
    ) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: [const Device(name: 'sidebar', size: Size(250, 600))],
        )
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(
              routerConfig:
                  _createTestRouter(initialLocation: '/before-visit'),
            ),
          ),
          name: 'sidebar_before_visit_active',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'sidebar_before_visit_active');
    });
  });

  group('SidebarItemData', () {
    test('creates SidebarItemData with required fields', () {
      const item = SidebarItemData(
        labelKey: 'testLabel',
        route: '/test',
        testKey: 'test_key',
      );

      expect(item.labelKey, 'testLabel');
      expect(item.route, '/test');
      expect(item.testKey, 'test_key');
      expect(item.isCustomTemplate, false);
    });

    test('creates SidebarItemData for custom template', () {
      const item = SidebarItemData(
        labelKey: 'My Template',
        route: '/template/123',
        testKey: 'sidebar_item_template_123',
        isCustomTemplate: true,
      );

      expect(item.labelKey, 'My Template');
      expect(item.route, '/template/123');
      expect(item.isCustomTemplate, true);
    });
  });

  group('SidebarConfig', () {
    test('visitWorkflowItems has Before Visit, During Visit, Build Own', () {
      expect(SidebarConfig.visitWorkflowItems.length, 3);
      expect(SidebarConfig.visitWorkflowItems[0].route, '/before-visit');
      expect(SidebarConfig.visitWorkflowItems[1].route, '/during-visit');
      expect(SidebarConfig.visitWorkflowItems[2].route, '/build-own');
    });

    test('standaloneItems has Library and Settings', () {
      expect(SidebarConfig.standaloneItems.length, 2);
      expect(SidebarConfig.standaloneItems[0].route, '/library');
      expect(SidebarConfig.standaloneItems[1].route, '/settings');
    });

    test('legacy topItems still works', () {
      expect(SidebarConfig.topItems.length, 2);
      expect(SidebarConfig.topItems[0].route, '/before-visit');
      expect(SidebarConfig.topItems[1].route, '/during-visit');
    });

    test('legacy bottomItems still works', () {
      expect(SidebarConfig.bottomItems.length, 3);
      expect(SidebarConfig.bottomItems[0].route, '/build-own');
      expect(SidebarConfig.bottomItems[1].route, '/library');
      expect(SidebarConfig.bottomItems[2].route, '/settings');
    });
  });
}
