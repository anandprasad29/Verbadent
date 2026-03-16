import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbident/src/features/build_own/presentation/build_own_providers.dart';
import 'package:verbident/src/features/build_own/domain/custom_template.dart';
import 'package:verbident/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:verbident/src/theme/app_colors.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/library',
          builder: (_, __) => const Scaffold(body: Text('Library')),
        ),
        GoRoute(
          path: '/before-visit',
          builder: (_, __) => const Scaffold(body: Text('Before Visit')),
        ),
        GoRoute(
          path: '/during-visit',
          builder: (_, __) => const Scaffold(body: Text('During Visit')),
        ),
        GoRoute(
          path: '/build-own',
          builder: (_, __) => const Scaffold(body: Text('Build Own')),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const Scaffold(body: Text('Settings')),
        ),
        GoRoute(
          path: '/template/:id',
          builder: (_, state) =>
              Scaffold(body: Text('Template ${state.pathParameters['id']}')),
        ),
      ],
    );
  }

  group('DashboardPage Hub Tests', () {
    testWidgets('displays VERBIDENT title', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('displays welcome text', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('What would you like to do?'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders all 4 feature tiles', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.byKey(const Key('tile_before_visit')), findsOneWidget);
      expect(find.byKey(const Key('tile_during_visit')), findsOneWidget);
      expect(find.byKey(const Key('tile_library')), findsOneWidget);
      expect(find.byKey(const Key('tile_build_own')), findsOneWidget);

      // Check labels
      expect(find.text('Before the Visit'), findsOneWidget);
      expect(find.text('During the Visit'), findsOneWidget);
      expect(find.text('Library'), findsWidgets); // Also in l10n
      expect(find.text('Build Your Own'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('tapping Before Visit tile navigates correctly', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      await tester.tap(find.byKey(const Key('tile_before_visit')));
      await tester.pumpAndSettle();

      expect(find.text('Before Visit'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('tapping Library tile navigates correctly', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      await tester.tap(find.byKey(const Key('tile_library')));
      await tester.pumpAndSettle();

      expect(find.text('Library'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('settings gear icon navigates to settings', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('no home icon on dashboard', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.byIcon(Icons.home), findsNothing);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('no sidebar or drawer anywhere', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.byType(Drawer), findsNothing);
      expect(find.byIcon(Icons.menu), findsNothing);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('has white background', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final container = tester.widget<Container>(
        find.byKey(const Key('dashboard_content')),
      );
      expect(container.color, equals(AppColors.background));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('My Templates Section', () {
    testWidgets('hidden when no templates exist', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('My Templates'), findsNothing);
      expect(find.byKey(const Key('tile_create_new')), findsNothing);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shown when templates exist', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      final testTemplates = [
        CustomTemplate(
          id: '1',
          name: 'Test Template',
          selectedItemIds: ['dentist-chair'],
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customTemplatesNotifierProvider.overrideWith(() {
              return _TestCustomTemplatesNotifier(testTemplates);
            }),
          ],
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('My Templates'), findsOneWidget);
      expect(find.text('Test Template'), findsOneWidget);
      expect(find.byKey(const Key('template_1')), findsOneWidget);
      expect(find.byKey(const Key('tile_create_new')), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('tapping template card navigates to template', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      final testTemplates = [
        CustomTemplate(
          id: '42',
          name: 'My Story',
          selectedItemIds: ['dentist-chair'],
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customTemplatesNotifierProvider.overrideWith(() {
              return _TestCustomTemplatesNotifier(testTemplates);
            }),
          ],
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      await tester.tap(find.byKey(const Key('template_42')));
      await tester.pumpAndSettle();

      expect(find.text('Template 42'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('Create New navigates to build-own', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      final testTemplates = [
        CustomTemplate(
          id: '1',
          name: 'Template',
          selectedItemIds: ['dentist-chair'],
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customTemplatesNotifierProvider.overrideWith(() {
              return _TestCustomTemplatesNotifier(testTemplates);
            }),
          ],
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      await tester.tap(find.byKey(const Key('tile_create_new')));
      await tester.pumpAndSettle();

      expect(find.text('Build Own'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('Responsive Column Count', () {
    testWidgets('uses 2 columns on mobile (<600px)', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(2));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses 4 columns on desktop (>=900px)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(4));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses 3 columns on tablet (600-899px)', (tester) async {
      tester.view.physicalSize = const Size(700, 1024);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('Screen Size Coverage', () {
    testWidgets('renders without overflow on very narrow screen (320x568)',
        (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(find.byKey(const Key('tile_before_visit')), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders without overflow on standard mobile (375x812)',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(find.byKey(const Key('tile_before_visit')), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders on phone landscape (800x375)', (tester) async {
      tester.view.physicalSize = const Size(800, 375);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders on tablet portrait (768x1024)', (tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders on tablet landscape (1024x768)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders on large tablet (1200x1920)', (tester) async {
      tester.view.physicalSize = const Size(1200, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders on wide desktop (1600x900)', (tester) async {
      tester.view.physicalSize = const Size(1600, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('Breakpoint Boundary Tests', () {
    testWidgets('uses 2 columns at 599px (just below mobile breakpoint)',
        (tester) async {
      tester.view.physicalSize = const Size(599, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(2));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses 3 columns at exactly 600px (mobile breakpoint)',
        (tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses 3 columns at 899px (just below tablet breakpoint)',
        (tester) async {
      tester.view.physicalSize = const Size(899, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses 4 columns at exactly 900px (tablet breakpoint)',
        (tester) async {
      tester.view.physicalSize = const Size(900, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView).first);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(4));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('Text Overflow Prevention', () {
    testWidgets('title uses FittedBox with scaleDown fit', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final fittedBox = tester.widget<FittedBox>(find.byType(FittedBox));
      expect(fittedBox.fit, equals(BoxFit.scaleDown));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('title has horizontal padding for safety', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final paddingFinder = find.ancestor(
        of: find.byType(FittedBox),
        matching: find.byType(Padding),
      );
      expect(paddingFinder, findsWidgets);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('no overflow on very narrow landscape (568x320)',
        (tester) async {
      tester.view.physicalSize = const Size(568, 320);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      expect(find.text('VERBIDENT'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('font size scales with screen width', (tester) async {
      // Collect font size on narrow screen
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final narrowText = tester.widget<Text>(find.text('VERBIDENT'));
      final narrowFontSize = narrowText.style!.fontSize!;

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();

      // Collect font size on wide screen
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final wideText = tester.widget<Text>(find.text('VERBIDENT'));
      final wideFontSize = wideText.style!.fontSize!;

      expect(wideFontSize, greaterThan(narrowFontSize));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('title uses InstrumentSans font', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final text = tester.widget<Text>(find.text('VERBIDENT'));
      expect(text.style?.fontFamily, equals('InstrumentSans'));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('title has proper contrast color', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      final text = tester.widget<Text>(find.text('VERBIDENT'));
      expect(text.style?.color, equals(AppColors.textTitle));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('DashboardPage Golden Tests', () {
    testGoldens('desktop layout', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'desktop', size: Size(1024, 768)),
        ])
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
          name: 'dashboard_page_desktop',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'dashboard_page_desktop');
    });

    testGoldens('mobile layout', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'mobile', size: Size(400, 800)),
        ])
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
          name: 'dashboard_page_mobile',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'dashboard_page_mobile');
    });
  });
}

/// Test helper to provide pre-populated templates
class _TestCustomTemplatesNotifier extends CustomTemplatesNotifier {
  final List<CustomTemplate> _initialTemplates;

  _TestCustomTemplatesNotifier(this._initialTemplates);

  @override
  List<CustomTemplate> build() {
    return _initialTemplates;
  }
}
