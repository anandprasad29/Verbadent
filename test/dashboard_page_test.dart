import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbident/src/constants/app_constants.dart';
import 'package:verbident/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:verbident/src/theme/app_colors.dart';
import 'package:verbident/src/widgets/sidebar.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    // Initialize SharedPreferences mock for tests
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
      ],
    );
  }

  group('DashboardPage Widget Tests', () {
    group('Desktop Layout', () {
      testWidgets('displays VERBIDENT title', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
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

      testWidgets('shows sidebar on desktop', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(find.byType(Sidebar), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('uses responsive font sizing on desktop', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBIDENT'));
        // Font size is calculated dynamically and clamped between mobile and desktop sizes
        expect(text.style?.fontSize, isNotNull);
        expect(text.style!.fontSize!, greaterThanOrEqualTo(AppConstants.titleFontSizeMobile));
        expect(text.style!.fontSize!, lessThanOrEqualTo(AppConstants.titleFontSizeDesktop));
        // Text is wrapped in FittedBox to handle overflow
        expect(find.byType(FittedBox), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('has white background', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
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

      testWidgets('title is centered', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(
          find.ancestor(
            of: find.text('VERBIDENT'),
            matching: find.byType(Center),
          ),
          findsOneWidget,
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('sidebar navigation works', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Tap Library in sidebar
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        // Should navigate to Library page
        expect(find.text('Library'), findsWidgets);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('Mobile Layout', () {
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

      testWidgets('shows hamburger menu', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(find.byIcon(Icons.menu), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('uses responsive font sizing on mobile', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBIDENT'));
        // Font size is calculated dynamically and clamped between mobile and desktop sizes
        expect(text.style?.fontSize, isNotNull);
        expect(text.style!.fontSize!, greaterThanOrEqualTo(AppConstants.titleFontSizeMobile));
        expect(text.style!.fontSize!, lessThanOrEqualTo(AppConstants.titleFontSizeDesktop));
        // Text is wrapped in FittedBox to handle overflow
        expect(find.byType(FittedBox), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('drawer opens on hamburger tap', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        expect(find.byType(Drawer), findsOneWidget);
        expect(find.byType(Sidebar), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('can navigate via drawer', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Open drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // Tap Library
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        // Should navigate and drawer should close
        expect(find.byType(Drawer), findsNothing);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('Breakpoint Behavior', () {
      testWidgets('shows sidebar at 800px', (tester) async {
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(find.byType(Sidebar), findsOneWidget);
        expect(find.byType(AppBar), findsNothing);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('shows drawer at 799px', (tester) async {
        tester.view.physicalSize = const Size(799, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.menu), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('uses responsive font at 800px', (tester) async {
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBIDENT'));
        // Font size is dynamically calculated based on available width
        expect(text.style?.fontSize, isNotNull);
        expect(text.style!.fontSize!, greaterThanOrEqualTo(AppConstants.titleFontSizeMobile));
        expect(text.style!.fontSize!, lessThanOrEqualTo(AppConstants.titleFontSizeDesktop));
        // FittedBox ensures text scales to fit
        expect(find.byType(FittedBox), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('uses responsive font at 799px', (tester) async {
        tester.view.physicalSize = const Size(799, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBIDENT'));
        // Font size is dynamically calculated based on available width
        expect(text.style?.fontSize, isNotNull);
        expect(text.style!.fontSize!, greaterThanOrEqualTo(AppConstants.titleFontSizeMobile));
        expect(text.style!.fontSize!, lessThanOrEqualTo(AppConstants.titleFontSizeDesktop));
        // FittedBox ensures text scales to fit
        expect(find.byType(FittedBox), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('Text Overflow Prevention', () {
      testWidgets('text does not overflow in landscape mode with sidebar',
          (tester) async {
        // Tablet landscape with sidebar (e.g., 1200x800)
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // FittedBox should ensure text scales down
        expect(find.byType(FittedBox), findsOneWidget);

        // Text should be visible
        expect(find.text('VERBIDENT'), findsOneWidget);

        // No overflow errors should occur
        expect(tester.takeException(), isNull);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('text does not overflow on narrow landscape (800x500)',
          (tester) async {
        // Short landscape view (but tall enough for sidebar)
        tester.view.physicalSize = const Size(800, 500);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // FittedBox should handle sizing
        expect(find.byType(FittedBox), findsOneWidget);
        expect(find.text('VERBIDENT'), findsOneWidget);
        expect(tester.takeException(), isNull);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('text does not overflow on very narrow screen (320x568)',
          (tester) async {
        // iPhone SE first gen width
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(find.byType(FittedBox), findsOneWidget);
        expect(find.text('VERBIDENT'), findsOneWidget);
        expect(tester.takeException(), isNull);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('text has horizontal padding', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Find the Padding widget that wraps FittedBox
        final paddingFinder = find.ancestor(
          of: find.byType(FittedBox),
          matching: find.byType(Padding),
        );
        expect(paddingFinder, findsWidgets);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('FittedBox uses scaleDown fit', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
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
    });

    group('Accessibility', () {
      testWidgets('title uses KumarOne font', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBIDENT'));
        expect(text.style?.fontFamily, equals('KumarOne'));

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('has proper contrast', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBIDENT'));
        // Text should be dark on white background
        expect(text.style?.color, equals(AppColors.textTitle));

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
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

    testGoldens('tablet layout', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'tablet', size: Size(800, 600)),
        ])
        ..addScenario(
          widget: ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
          name: 'dashboard_page_tablet',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'dashboard_page_tablet');
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

    testGoldens('mobile with drawer open', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: createTestRouter()),
        ),
      );

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'dashboard_page_mobile_drawer_open');

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}

