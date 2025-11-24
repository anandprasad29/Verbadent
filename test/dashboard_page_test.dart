import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:verbadent/src/constants/app_constants.dart';
import 'package:verbadent/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:verbadent/src/theme/app_colors.dart';
import 'package:verbadent/src/theme/app_text_styles.dart';
import 'package:verbadent/src/widgets/sidebar.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
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
      testWidgets('displays VERBADENT title', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(find.text('VERBADENT'), findsOneWidget);

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

      testWidgets('uses large title style on desktop', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBADENT'));
        expect(text.style?.fontSize, equals(AppTextStyles.titleLarge.fontSize));

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
            of: find.text('VERBADENT'),
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
      testWidgets('displays VERBADENT title', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        expect(find.text('VERBADENT'), findsOneWidget);

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

      testWidgets('uses mobile title style', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBADENT'));
        expect(
            text.style?.fontSize, equals(AppTextStyles.titleMobile.fontSize));

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

      testWidgets('uses large font at 800px', (tester) async {
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBADENT'));
        expect(text.style?.fontSize, equals(AppConstants.titleFontSizeDesktop));

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('uses small font at 799px', (tester) async {
        tester.view.physicalSize = const Size(799, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final text = tester.widget<Text>(find.text('VERBADENT'));
        expect(text.style?.fontSize, equals(AppConstants.titleFontSizeMobile));

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

        final text = tester.widget<Text>(find.text('VERBADENT'));
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

        final text = tester.widget<Text>(find.text('VERBADENT'));
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
