import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbadent/src/constants/app_constants.dart';
import 'package:verbadent/src/routing/routes.dart';
import 'package:verbadent/src/theme/app_colors.dart';
import 'package:verbadent/src/theme/app_text_styles.dart';

void main() {
  group('AppConstants', () {
    group('Breakpoints', () {
      test('mobile breakpoint is 600', () {
        expect(AppConstants.mobileBreakpoint, equals(600));
      });

      test('tablet breakpoint is 900', () {
        expect(AppConstants.tabletBreakpoint, equals(900));
      });

      test('desktop breakpoint is 1200', () {
        expect(AppConstants.desktopBreakpoint, equals(1200));
      });

      test('sidebar breakpoint is 800', () {
        expect(AppConstants.sidebarBreakpoint, equals(800));
      });

      test('breakpoints are in ascending order', () {
        expect(AppConstants.mobileBreakpoint,
            lessThan(AppConstants.sidebarBreakpoint));
        expect(AppConstants.sidebarBreakpoint,
            lessThan(AppConstants.tabletBreakpoint));
        expect(AppConstants.tabletBreakpoint,
            lessThan(AppConstants.desktopBreakpoint));
      });
    });

    group('Sidebar Dimensions', () {
      test('sidebar width is 250', () {
        expect(AppConstants.sidebarWidth, equals(250));
      });

      test('sidebar item height is 60', () {
        expect(AppConstants.sidebarItemHeight, equals(60));
      });

      test('sidebar top spacing is 100', () {
        expect(AppConstants.sidebarTopSpacing, equals(100));
      });

      test('sidebar item spacing is 20', () {
        expect(AppConstants.sidebarItemSpacing, equals(20));
      });
    });

    group('Header Dimensions', () {
      test('header expanded height is 120', () {
        expect(AppConstants.headerExpandedHeight, equals(120));
      });

      test('header collapsed height is 56', () {
        expect(AppConstants.headerCollapsedHeight, equals(56));
      });

      test('expanded height is greater than collapsed', () {
        expect(
          AppConstants.headerExpandedHeight,
          greaterThan(AppConstants.headerCollapsedHeight),
        );
      });
    });

    group('Border Radius', () {
      test('card border radius is 25', () {
        expect(AppConstants.cardBorderRadius, equals(25.0));
      });

      test('card border width is 3', () {
        expect(AppConstants.cardBorderWidth, equals(3.0));
      });
    });

    group('Grid Settings', () {
      test('desktop has 5 columns', () {
        expect(AppConstants.gridColumnsDesktop, equals(5));
      });

      test('tablet has 3 columns', () {
        expect(AppConstants.gridColumnsTablet, equals(3));
      });

      test('mobile has 2 columns', () {
        expect(AppConstants.gridColumnsMobile, equals(2));
      });

      test('grid spacing decreases for smaller screens', () {
        expect(
          AppConstants.gridSpacingDesktop,
          greaterThan(AppConstants.gridSpacingTablet),
        );
        expect(
          AppConstants.gridSpacingTablet,
          greaterThan(AppConstants.gridSpacingMobile),
        );
      });
    });

    group('Content Padding', () {
      test('desktop padding is horizontal 48, vertical 24', () {
        expect(
          AppConstants.contentPaddingDesktop,
          equals(const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0)),
        );
      });

      test('tablet padding is horizontal 32, vertical 20', () {
        expect(
          AppConstants.contentPaddingTablet,
          equals(const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0)),
        );
      });

      test('mobile padding is horizontal 16, vertical 16', () {
        expect(
          AppConstants.contentPaddingMobile,
          equals(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0)),
        );
      });
    });

    group('Font Sizes', () {
      test('title font size desktop is 80', () {
        expect(AppConstants.titleFontSizeDesktop, equals(80.0));
      });

      test('title font size mobile is 40', () {
        expect(AppConstants.titleFontSizeMobile, equals(40.0));
      });

      test('header font size is 24', () {
        expect(AppConstants.headerFontSize, equals(24.0));
      });

      test('sidebar item font size is 16', () {
        expect(AppConstants.sidebarItemFontSize, equals(16.0));
      });

      test('caption font size is 14', () {
        expect(AppConstants.captionFontSize, equals(14.0));
      });

      test('header expanded scale is approximately 2.67', () {
        expect(AppConstants.headerExpandedScale, closeTo(2.67, 0.01));
      });
    });
  });

  group('Routes', () {
    test('home route is /', () {
      expect(Routes.home, equals('/'));
    });

    test('library route is /library', () {
      expect(Routes.library, equals('/library'));
    });

    test('before visit route is /before-visit', () {
      expect(Routes.beforeVisit, equals('/before-visit'));
    });

    test('during visit route is /during-visit', () {
      expect(Routes.duringVisit, equals('/during-visit'));
    });

    test('build own route is /build-own', () {
      expect(Routes.buildOwn, equals('/build-own'));
    });

    test('all routes start with /', () {
      expect(Routes.home, startsWith('/'));
      expect(Routes.library, startsWith('/'));
      expect(Routes.beforeVisit, startsWith('/'));
      expect(Routes.duringVisit, startsWith('/'));
      expect(Routes.buildOwn, startsWith('/'));
    });

    test('all routes are unique', () {
      final routes = [
        Routes.home,
        Routes.library,
        Routes.beforeVisit,
        Routes.duringVisit,
        Routes.buildOwn,
      ];
      expect(routes.toSet().length, equals(routes.length));
    });
  });

  group('AppColors', () {
    group('Primary Colors', () {
      test('primary color is #5483F5', () {
        expect(AppColors.primary, equals(const Color(0xFF5483F5)));
      });

      test('primary dark color is #4284F3', () {
        expect(AppColors.primaryDark, equals(const Color(0xFF4284F3)));
      });
    });

    group('Background Colors', () {
      test('background is white', () {
        expect(AppColors.background, equals(const Color(0xFFFFFFFF)));
      });

      test('surface is white', () {
        expect(AppColors.surface, equals(const Color(0xFFFFFFFF)));
      });
    });

    group('Text Colors', () {
      test('text primary is #0A2D6D', () {
        expect(AppColors.textPrimary, equals(const Color(0xFF0A2D6D)));
      });

      test('text title is #1B2B57', () {
        expect(AppColors.textTitle, equals(const Color(0xFF1B2B57)));
      });

      test('text secondary is black', () {
        expect(AppColors.textSecondary, equals(const Color(0xFF000000)));
      });
    });

    group('Sidebar Colors', () {
      test('sidebar background matches primary', () {
        expect(AppColors.sidebarBackground, equals(AppColors.primary));
      });

      test('sidebar item background is #D9D9D9', () {
        expect(
            AppColors.sidebarItemBackground, equals(const Color(0xFFD9D9D9)));
      });

      test('sidebar item active is white', () {
        expect(AppColors.sidebarItemActive, equals(const Color(0xFFFFFFFF)));
      });

      test('sidebar item text is black', () {
        expect(AppColors.sidebarItemText, equals(const Color(0xFF000000)));
      });
    });

    group('Card Colors', () {
      test('card border matches primary', () {
        expect(AppColors.cardBorder, equals(AppColors.primary));
      });

      test('card background is white', () {
        expect(AppColors.cardBackground, equals(const Color(0xFFFFFFFF)));
      });
    });

    group('Neutral Colors', () {
      test('neutral is #D9D9D9', () {
        expect(AppColors.neutral, equals(const Color(0xFFD9D9D9)));
      });

      test('divider is #E0E0E0', () {
        expect(AppColors.divider, equals(const Color(0xFFE0E0E0)));
      });
    });

    test('all colors are fully opaque', () {
      // Using .a property (0.0 to 1.0) to check opacity, 1.0 = fully opaque
      expect(AppColors.primary.a, equals(1.0));
      expect(AppColors.primaryDark.a, equals(1.0));
      expect(AppColors.background.a, equals(1.0));
      expect(AppColors.textPrimary.a, equals(1.0));
      expect(AppColors.textSecondary.a, equals(1.0));
    });
  });

  group('AppTextStyles', () {
    group('Title Styles', () {
      test('titleLarge uses KumarOne font', () {
        expect(AppTextStyles.titleLarge.fontFamily, equals('KumarOne'));
      });

      test('titleLarge has desktop font size', () {
        expect(
          AppTextStyles.titleLarge.fontSize,
          equals(AppConstants.titleFontSizeDesktop),
        );
      });

      test('titleLarge is bold', () {
        expect(AppTextStyles.titleLarge.fontWeight, equals(FontWeight.bold));
      });

      test('titleLarge uses title color', () {
        expect(AppTextStyles.titleLarge.color, equals(AppColors.textTitle));
      });

      test('titleMobile uses KumarOne font', () {
        expect(AppTextStyles.titleMobile.fontFamily, equals('KumarOne'));
      });

      test('titleMobile has mobile font size', () {
        expect(
          AppTextStyles.titleMobile.fontSize,
          equals(AppConstants.titleFontSizeMobile),
        );
      });
    });

    group('Page Header Style', () {
      test('pageHeader uses KumarOne font', () {
        expect(AppTextStyles.pageHeader.fontFamily, equals('KumarOne'));
      });

      test('pageHeader has header font size', () {
        expect(
          AppTextStyles.pageHeader.fontSize,
          equals(AppConstants.headerFontSize),
        );
      });

      test('pageHeader uses primary text color', () {
        expect(AppTextStyles.pageHeader.color, equals(AppColors.textPrimary));
      });
    });

    group('Sidebar Item Styles', () {
      test('sidebarItem uses KumarOne font', () {
        expect(AppTextStyles.sidebarItem.fontFamily, equals('KumarOne'));
      });

      test('sidebarItem is bold', () {
        expect(AppTextStyles.sidebarItem.fontWeight, equals(FontWeight.bold));
      });

      test('sidebarItem uses correct font size', () {
        expect(
          AppTextStyles.sidebarItem.fontSize,
          equals(AppConstants.sidebarItemFontSize),
        );
      });

      test('sidebarItemActive uses primary color', () {
        expect(
            AppTextStyles.sidebarItemActive.color, equals(AppColors.primary));
      });
    });

    group('Caption Style', () {
      test('caption uses InstrumentSans font', () {
        expect(AppTextStyles.caption.fontFamily, equals('InstrumentSans'));
      });

      test('caption is bold', () {
        expect(AppTextStyles.caption.fontWeight, equals(FontWeight.bold));
      });

      test('caption has correct font size', () {
        expect(
          AppTextStyles.caption.fontSize,
          equals(AppConstants.captionFontSize),
        );
      });

      test('caption uses secondary text color', () {
        expect(AppTextStyles.caption.color, equals(AppColors.textSecondary));
      });
    });
  });
}
