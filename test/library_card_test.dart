import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:verbadent/src/features/library/domain/library_item.dart';
import 'package:verbadent/src/features/library/presentation/widgets/library_card.dart';
import 'package:verbadent/src/theme/app_colors.dart';

void main() {
  // Load fonts for golden tests
  setUpAll(() async {
    await loadAppFonts();
  });

  group('LibraryCard Widget Tests', () {
    const testItem = LibraryItem(
      id: 'test-1',
      imagePath: 'assets/images/library/test_image.png',
      caption: "This is the dentist's chair",
    );

    testWidgets('renders with blue container border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 280,
                child: LibraryCard(
                  item: testItem,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the container with blue border color
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(LibraryCard),
          matching: find.byType(Container),
        ).first,
      );

      // Verify the container decoration has the correct border color
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
      expect(
        decoration.border?.top.color,
        equals(AppColors.cardBorder),
      );
    });

    testWidgets('renders image with rounded corners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 280,
                child: LibraryCard(
                  item: testItem,
                ),
              ),
            ),
          ),
        ),
      );

      // Find ClipRRect for rounded corners
      final clipRRect = tester.widget<ClipRRect>(
        find.descendant(
          of: find.byType(LibraryCard),
          matching: find.byType(ClipRRect),
        ).first,
      );

      // Verify border radius is present (inner radius accounts for border width)
      expect(clipRRect.borderRadius, isNotNull);
      final borderRadius = clipRRect.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, greaterThan(0));
    });

    testWidgets('renders caption text with correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 280,
                child: LibraryCard(
                  item: testItem,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the caption text
      final textFinder = find.text(testItem.caption);
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);

      // Verify text styling: Instrument Sans Bold, 14px, black, centered
      expect(textWidget.style?.fontFamily, equals('InstrumentSans'));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
      expect(textWidget.style?.fontSize, equals(14.0));
      expect(textWidget.style?.color, equals(AppColors.textSecondary));
      expect(textWidget.textAlign, equals(TextAlign.center));
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 280,
                child: LibraryCard(
                  item: testItem,
                  onTap: () {
                    wasTapped = true;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.byType(LibraryCard));
      await tester.pump();

      // Verify callback was triggered
      expect(wasTapped, isTrue);
    });

    testWidgets('has correct semantic label for accessibility', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 280,
                child: LibraryCard(
                  item: testItem,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify semantic label includes caption
      final semantics = tester.getSemantics(find.byType(LibraryCard));
      expect(semantics.label, contains(testItem.caption));
    });

    testWidgets('caption is positioned below the image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 280,
                child: LibraryCard(
                  item: testItem,
                ),
              ),
            ),
          ),
        ),
      );

      // Find Column widget that contains image and caption
      expect(
        find.descendant(
          of: find.byType(LibraryCard),
          matching: find.byType(Column),
        ),
        findsOneWidget,
      );
    });
  });
}
