import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbadent/src/constants/app_constants.dart';
import 'package:verbadent/src/utils/responsive.dart';

void main() {
  group('Responsive Utilities', () {
    group('getContentWidth', () {
      testWidgets('returns full width when below sidebar breakpoint',
          (tester) async {
        // 600px is below 800px sidebar breakpoint
        tester.view.physicalSize = const Size(600, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final contentWidth = Responsive.getContentWidth(context);
                expect(contentWidth, equals(600.0));
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('subtracts sidebar width when at sidebar breakpoint',
          (tester) async {
        // 800px is at the sidebar breakpoint
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final contentWidth = Responsive.getContentWidth(context);
                // 800 - 250 (sidebar) = 550
                expect(contentWidth, equals(550.0));
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('subtracts sidebar width for tablet portrait (1200px)',
          (tester) async {
        // Simulating tablet portrait mode like Samsung Tab
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final contentWidth = Responsive.getContentWidth(context);
                // 1200 - 250 (sidebar) = 950
                expect(contentWidth, equals(950.0));
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('isMobile/isTablet/isDesktop with content width', () {
      testWidgets('classifies 500px screen as mobile (no sidebar)',
          (tester) async {
        // 500px is below 600px mobile breakpoint
        tester.view.physicalSize = const Size(500, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 500px screen, no sidebar (below 800px), so content = 500px
                // 500 < 600, so mobile
                expect(Responsive.isMobile(context), isTrue);
                expect(Responsive.isTablet(context), isFalse);
                expect(Responsive.isDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('classifies 600px screen as tablet (at mobile breakpoint)',
          (tester) async {
        // 600px equals mobile breakpoint, so it's tablet (not mobile)
        tester.view.physicalSize = const Size(600, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 600px screen, no sidebar (below 800px), content = 600px
                // 600 >= 600 && 600 < 1200, so tablet
                expect(Responsive.isMobile(context), isFalse);
                expect(Responsive.isTablet(context), isTrue);
                expect(Responsive.isDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('classifies 800px screen as mobile (sidebar reduces content)',
          (tester) async {
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 800px screen with sidebar = 550px content
                // 550 < 600, so mobile
                expect(Responsive.isMobile(context), isTrue);
                expect(Responsive.isTablet(context), isFalse);
                expect(Responsive.isDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('classifies 1200px screen as tablet (sidebar reduces content)',
          (tester) async {
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 1200px screen with sidebar = 950px content
                // 950 >= 600 && 950 < 1200, so tablet
                expect(Responsive.isMobile(context), isFalse);
                expect(Responsive.isTablet(context), isTrue);
                expect(Responsive.isDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('classifies 1600px screen as desktop',
          (tester) async {
        tester.view.physicalSize = const Size(1600, 900);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 1600px screen with sidebar = 1350px content
                // 1350 >= 1200, so desktop
                expect(Responsive.isMobile(context), isFalse);
                expect(Responsive.isTablet(context), isFalse);
                expect(Responsive.isDesktop(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('getGridColumnCount', () {
      testWidgets('returns 2 columns for mobile content width', (tester) async {
        tester.view.physicalSize = const Size(500, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  Responsive.getGridColumnCount(context),
                  equals(AppConstants.gridColumnsMobile), // 2
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns 3 columns for tablet content width (1200px screen)',
          (tester) async {
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Content width = 950px (tablet range)
                expect(
                  Responsive.getGridColumnCount(context),
                  equals(AppConstants.gridColumnsTablet), // 3
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns 5 columns for desktop content width',
          (tester) async {
        tester.view.physicalSize = const Size(1600, 900);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Content width = 1350px (desktop range)
                expect(
                  Responsive.getGridColumnCount(context),
                  equals(AppConstants.gridColumnsDesktop), // 5
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('getGridAspectRatio', () {
      testWidgets('returns 0.65 for mobile content width', (tester) async {
        tester.view.physicalSize = const Size(500, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  Responsive.getGridAspectRatio(context),
                  equals(0.65),
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns 0.70 for tablet content width', (tester) async {
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  Responsive.getGridAspectRatio(context),
                  equals(0.70),
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns 0.75 for desktop content width', (tester) async {
        tester.view.physicalSize = const Size(1600, 900);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  Responsive.getGridAspectRatio(context),
                  equals(0.75),
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('getHeaderExpandedScale', () {
      testWidgets('returns small scale (1.5) for narrow content', (tester) async {
        // 800px screen = 550px content, which is < 1000px
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  Responsive.getHeaderExpandedScale(context),
                  equals(AppConstants.headerExpandedScaleSmall), // 1.5
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns small scale (1.5) for 1200px tablet', (tester) async {
        // 1200px screen = 950px content, which is < 1000px
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  Responsive.getHeaderExpandedScale(context),
                  equals(AppConstants.headerExpandedScaleSmall), // 1.5
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns large scale (2.5) for wide content', (tester) async {
        // 1300px screen = 1050px content, which is >= 1000px
        tester.view.physicalSize = const Size(1300, 900);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  Responsive.getHeaderExpandedScale(context),
                  equals(AppConstants.headerExpandedScaleLarge), // 2.5
                );
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('shouldShowPageHeader', () {
      testWidgets('returns false for narrow screens', (tester) async {
        tester.view.physicalSize = const Size(700, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.shouldShowPageHeader(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns true at sidebar breakpoint', (tester) async {
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.shouldShowPageHeader(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('returns true for wide screens', (tester) async {
        tester.view.physicalSize = const Size(1200, 900);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.shouldShowPageHeader(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });

  group('Breakpoint Edge Cases', () {
    testWidgets('content width just below mobile breakpoint (599px)',
        (tester) async {
      tester.view.physicalSize = const Size(599, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 599px screen without sidebar (below 800px) = 599px content
              // 599 < 600, so mobile
              expect(Responsive.isMobile(context), isTrue);
              expect(Responsive.getGridColumnCount(context), equals(2));
              return const SizedBox();
            },
          ),
        ),
      );

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('content width at exact mobile/tablet boundary (600px)',
        (tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 600px screen without sidebar = 600px content
              // 600 >= 600 && 600 < 1200, so tablet
              expect(Responsive.isTablet(context), isTrue);
              expect(Responsive.getGridColumnCount(context), equals(3));
              return const SizedBox();
            },
          ),
        ),
      );

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('content width at exact tablet/desktop boundary (1200px)',
        (tester) async {
      // Screen width that gives exactly 1200px content width
      // 1200 + 250 (sidebar) = 1450px screen
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 1450 - 250 = 1200px content, which is exactly desktop
              expect(Responsive.isDesktop(context), isTrue);
              expect(Responsive.getGridColumnCount(context), equals(5));
              return const SizedBox();
            },
          ),
        ),
      );

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('content width just below desktop breakpoint (1199px)',
        (tester) async {
      // Screen width that gives 1199px content width
      // 1199 + 250 (sidebar) = 1449px screen
      tester.view.physicalSize = const Size(1449, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 1449 - 250 = 1199px content, which is tablet
              expect(Responsive.isTablet(context), isTrue);
              expect(Responsive.getGridColumnCount(context), equals(3));
              return const SizedBox();
            },
          ),
        ),
      );

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}

