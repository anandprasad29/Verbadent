import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:verbadent/src/constants/app_constants.dart';
import 'package:verbadent/src/theme/app_colors.dart';
import 'package:verbadent/src/widgets/app_shell.dart';
import 'package:verbadent/src/widgets/sidebar.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  GoRouter createTestRouter({String initialLocation = '/'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AppShell(
            child: Center(child: Text('Home Content')),
          ),
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const AppShell(
            child: Center(child: Text('Library Content')),
          ),
        ),
      ],
    );
  }

  group('AppShell Widget Tests', () {
    group('Desktop Layout (>=800px)', () {
      testWidgets('shows permanent sidebar on wide screens', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Sidebar should be visible
        expect(find.byType(Sidebar), findsOneWidget);

        // No AppBar on desktop
        expect(find.byType(AppBar), findsNothing);

        // Content should be visible
        expect(find.text('Home Content'), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('sidebar has correct width on desktop', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Find the SizedBox containing sidebar
        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(Sidebar),
                matching: find.byType(SizedBox),
              )
              .first,
        );

        expect(sizedBox.width, equals(AppConstants.sidebarWidth));

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('content area fills remaining space', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Find Expanded widget containing content
        expect(
          find.ancestor(
            of: find.text('Home Content'),
            matching: find.byType(Expanded),
          ),
          findsOneWidget,
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('content has white background', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Find Container with background color
        final containers = tester.widgetList<Container>(
          find.ancestor(
            of: find.text('Home Content'),
            matching: find.byType(Container),
          ),
        );

        bool hasWhiteBackground = containers.any(
          (c) => c.color == AppColors.background,
        );
        expect(hasWhiteBackground, isTrue);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('Mobile Layout (<800px)', () {
      testWidgets('shows AppBar with hamburger menu on narrow screens',
          (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // AppBar should be visible
        expect(find.byType(AppBar), findsOneWidget);

        // Menu icon should be present
        expect(find.byIcon(Icons.menu), findsOneWidget);

        // Sidebar should not be directly visible (in drawer)
        expect(find.byType(Sidebar), findsNothing);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('AppBar has correct background color', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.backgroundColor, equals(AppColors.sidebarBackground));

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('hamburger menu opens drawer with sidebar', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Tap hamburger menu
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // Drawer should be open with Sidebar
        expect(find.byType(Drawer), findsOneWidget);
        expect(find.byType(Sidebar), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('drawer has correct width', (tester) async {
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

        final drawer = tester.widget<Drawer>(find.byType(Drawer));
        expect(drawer.width, equals(AppConstants.sidebarWidth));

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('drawer closes after navigation', (tester) async {
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

        // Tap Library in sidebar
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        // Drawer should be closed
        expect(find.byType(Drawer), findsNothing);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('Breakpoint Behavior', () {
      testWidgets('shows sidebar at exactly 800px', (tester) async {
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(routerConfig: createTestRouter()),
          ),
        );

        // Sidebar should be visible at exactly 800px
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

        // AppBar should be visible at 799px
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.menu), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('Golden Tests', () {
      testGoldens('desktop layout renders correctly', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            const Device(name: 'desktop', size: Size(1024, 768)),
          ])
          ..addScenario(
            widget: ProviderScope(
              child: MaterialApp.router(routerConfig: createTestRouter()),
            ),
            name: 'app_shell_desktop',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'app_shell_desktop');
      });

      testGoldens('mobile layout renders correctly', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            const Device(name: 'mobile', size: Size(400, 800)),
          ])
          ..addScenario(
            widget: ProviderScope(
              child: MaterialApp.router(routerConfig: createTestRouter()),
            ),
            name: 'app_shell_mobile',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'app_shell_mobile');
      });

      testGoldens('mobile drawer open renders correctly', (tester) async {
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

        await screenMatchesGolden(tester, 'app_shell_mobile_drawer_open');

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
