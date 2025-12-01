import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:verbident/dashboard_screen.dart';

void main() {
  // Load fonts for golden tests
  setUpAll(() async {
    await loadAppFonts();
  });

  group('DashboardScreen Widget Tests', () {
    testGoldens('renders Desktop layout correctly', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'desktop', size: Size(1024, 768)),
        ])
        ..addScenario(
          widget: const DashboardScreen(),
          name: 'desktop_layout',
        );

      await tester.pumpDeviceBuilder(builder);

      // Verify Desktop Layout Key is present
      expect(find.byKey(const Key('dashboard_desktop_layout')), findsOneWidget);

      // Verify Accessibility
      expect(tester, meetsGuideline(androidTapTargetGuideline));
      expect(tester, meetsGuideline(iOSTapTargetGuideline));

      // Compare Golden
      await screenMatchesGolden(tester, 'dashboard_desktop');
    });

    testGoldens('renders Mobile layout correctly', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'mobile', size: Size(400, 800)),
        ])
        ..addScenario(
          widget: const DashboardScreen(),
          name: 'mobile_layout',
        );

      await tester.pumpDeviceBuilder(builder);

      // Verify Mobile Layout (AppBar present, Drawer hidden initially)
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byKey(const Key('dashboard_mobile_drawer')), findsNothing);

      // Verify Accessibility
      expect(tester, meetsGuideline(androidTapTargetGuideline));
      expect(tester, meetsGuideline(iOSTapTargetGuideline));

      // Compare Golden
      await screenMatchesGolden(tester, 'dashboard_mobile');
    });

    testWidgets('Sidebar items are present and tapable', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'desktop', size: Size(1024, 768)),
        ])
        ..addScenario(
          widget: const DashboardScreen(),
          name: 'desktop_interaction',
        );

      await tester.pumpDeviceBuilder(builder);

      // Verify specific items by Key
      expect(
          find.byKey(const Key('sidebar_item_before_visit')), findsOneWidget);
      expect(
          find.byKey(const Key('sidebar_item_during_visit')), findsOneWidget);
      expect(find.byKey(const Key('sidebar_item_build_own')), findsOneWidget);
      expect(find.byKey(const Key('sidebar_item_library')), findsOneWidget);
    });

    testWidgets('Layout switches at exactly 800 width', (tester) async {
      // Test Desktop at 800
      final desktopBuilder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'desktop_800', size: Size(800, 600)),
        ])
        ..addScenario(
          widget: const DashboardScreen(),
          name: 'desktop_boundary',
        );
      await tester.pumpDeviceBuilder(desktopBuilder);
      expect(find.byKey(const Key('dashboard_desktop_layout')), findsOneWidget);

      // Test Mobile at 799
      final mobileBuilder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          const Device(name: 'mobile_799', size: Size(799, 600)),
        ])
        ..addScenario(
          widget: const DashboardScreen(),
          name: 'mobile_boundary',
        );
      await tester.pumpDeviceBuilder(mobileBuilder);
      expect(find.byType(AppBar), findsOneWidget); // Mobile indicator
    });
  });
}
