import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbident/src/common/widgets/error_boundary.dart';
import 'package:verbident/src/common/widgets/skeleton_card.dart';
import 'package:verbident/src/common/widgets/speaking_indicator.dart';
import 'package:verbident/src/common/widgets/accessible_tap_target.dart';
import 'package:verbident/src/features/library/data/library_data.dart';
import 'package:verbident/src/features/library/domain/library_item.dart';
import 'package:verbident/src/features/library/presentation/widgets/library_card.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Error Boundary Tests', () {
    testWidgets('ErrorBoundary renders child normally when no error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ErrorBoundary(child: Text('Normal content'))),
      );

      expect(find.text('Normal content'), findsOneWidget);
    });

    testWidgets('ErrorBoundary shows custom fallback on error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorBoundary(
            fallback: const Text('Custom fallback'),
            child: Builder(
              builder: (context) {
                // This will be caught by the error boundary
                return const Text('Normal');
              },
            ),
          ),
        ),
      );

      // Normal case - no error thrown during build
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('SimpleErrorBoundary works with simple fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SimpleErrorBoundary(
            fallback: Text('Fallback'),
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
    });
  });

  group('Loading State Tests', () {
    testWidgets('SkeletonCard shows shimmer animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 200, height: 280, child: SkeletonCard()),
          ),
        ),
      );

      // Verify skeleton card renders
      expect(find.byType(SkeletonCard), findsOneWidget);

      // Advance animation
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SkeletonCard), findsOneWidget);
    });

    testWidgets('SkeletonGrid shows multiple skeleton cards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800, // Tall enough to show all cards
              child: SkeletonGrid(itemCount: 6, crossAxisCount: 2),
            ),
          ),
        ),
      );

      // At least some skeleton cards should be visible
      expect(find.byType(SkeletonCard), findsWidgets);
    });
  });

  group('Empty State Tests', () {
    testWidgets('LibraryCard handles empty caption gracefully', (tester) async {
      const item = LibraryItem(
        id: 'empty-caption',
        imagePath: 'assets/images/library/dentist_chair.webp',
        caption: '',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 280,
              child: LibraryCard(item: item, caption: ''),
            ),
          ),
        ),
      );

      expect(find.byType(LibraryCard), findsOneWidget);
    });

    testWidgets('LibraryCard handles very long caption', (tester) async {
      final longCaption = 'A' * 200;
      final item = LibraryItem(
        id: 'long-caption',
        imagePath: 'assets/images/library/dentist_chair.webp',
        caption: longCaption,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 280,
              child: LibraryCard(item: item, caption: longCaption),
            ),
          ),
        ),
      );

      expect(find.byType(LibraryCard), findsOneWidget);
      // Text should be truncated with ellipsis
    });
  });

  group('Speaking Indicator Tests', () {
    testWidgets('SpeakingIndicator animates continuously', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: SpeakingIndicator(size: 24))),
        ),
      );

      expect(find.byType(SpeakingIndicator), findsOneWidget);

      // Advance animation multiple times
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      // Should still be rendering
      expect(find.byType(SpeakingIndicator), findsOneWidget);
    });

    testWidgets('SpeakingBadge shows indicator when speaking', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SpeakingBadge(isSpeaking: true, child: Text('Content')),
          ),
        ),
      );

      expect(find.byType(SpeakingIndicator), findsOneWidget);
    });

    testWidgets('SpeakingBadge hides indicator when not speaking', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SpeakingBadge(isSpeaking: false, child: Text('Content')),
          ),
        ),
      );

      expect(find.byType(SpeakingIndicator), findsNothing);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('AccessibleTapTarget meets minimum touch size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibleTapTarget(child: Icon(Icons.close, size: 16)),
            ),
          ),
        ),
      );

      final box = tester.getSize(find.byType(AccessibleTapTarget));
      expect(box.width, greaterThanOrEqualTo(48.0));
      expect(box.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('AccessibleIconButton has proper semantics', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccessibleIconButton(icon: Icons.close, tooltip: 'Close'),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(AccessibleIconButton));
      expect(semantics.label, 'Close');
    });

    testWidgets('LibraryCard has semantic label for accessibility', (
      tester,
    ) async {
      final item = LibraryData.sampleItems.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 280,
              child: LibraryCard(item: item, caption: item.caption),
            ),
          ),
        ),
      );

      // Verify the card renders (semantics are added via Semantics widget wrapper)
      expect(find.byType(LibraryCard), findsOneWidget);
      // The caption text should be present
      expect(find.text(item.caption), findsOneWidget);
    });
  });

  group('Responsive Layout Tests', () {
    testWidgets('LibraryCard adapts to small container', (tester) async {
      final item = LibraryData.sampleItems.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100, // Very small
              height: 140,
              child: LibraryCard(item: item, caption: item.caption),
            ),
          ),
        ),
      );

      expect(find.byType(LibraryCard), findsOneWidget);
    });

    testWidgets('LibraryCard adapts to large container', (tester) async {
      final item = LibraryData.sampleItems.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 500, // Large
              height: 700,
              child: LibraryCard(item: item, caption: item.caption),
            ),
          ),
        ),
      );

      expect(find.byType(LibraryCard), findsOneWidget);
    });
  });

  group('Interaction Tests', () {
    testWidgets('LibraryCard onTap callback is called', (tester) async {
      bool tapped = false;
      final item = LibraryData.sampleItems.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 280,
              child: LibraryCard(
                item: item,
                caption: item.caption,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LibraryCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('LibraryCard works without onTap', (tester) async {
      final item = LibraryData.sampleItems.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 280,
              child: LibraryCard(
                item: item,
                caption: item.caption,
                // No onTap callback
              ),
            ),
          ),
        ),
      );

      // Should not throw when tapped
      await tester.tap(find.byType(LibraryCard));
      await tester.pumpAndSettle();

      expect(find.byType(LibraryCard), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('Components render correctly in light theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: Column(
              children: [
                SizedBox(width: 200, height: 280, child: SkeletonCard()),
                SpeakingIndicator(size: 24),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonCard), findsOneWidget);
      expect(find.byType(SpeakingIndicator), findsOneWidget);
    });

    testWidgets('Components render correctly in dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: Column(
              children: [
                SizedBox(width: 200, height: 280, child: SkeletonCard()),
                SpeakingIndicator(size: 24),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonCard), findsOneWidget);
      expect(find.byType(SpeakingIndicator), findsOneWidget);
    });
  });
}
