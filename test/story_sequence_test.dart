import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verbadent/src/common/domain/dental_item.dart';
import 'package:verbadent/src/common/widgets/story_sequence.dart';
import 'package:verbadent/src/localization/content_language_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Sample items for testing
  const testItems = [
    DentalItem(
      id: 'item-1',
      imagePath: 'assets/images/library/dentist_chair.png',
      caption: 'First item caption',
    ),
    DentalItem(
      id: 'item-2',
      imagePath: 'assets/images/library/dentist_mask.png',
      caption: 'Second item caption',
    ),
    DentalItem(
      id: 'item-3',
      imagePath: 'assets/images/library/dentist_gloves.png',
      caption: 'Third item caption',
    ),
  ];

  /// Wraps widget in MaterialApp for testing with sufficient height
  Widget buildTestWidget({
    required Widget child,
    Size size = const Size(800, 800),
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: child,
        ),
      ),
    );
  }

  group('StorySequence Widget Tests', () {
    testWidgets('renders all items', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: const StorySequence(
            items: testItems,
          ),
        ),
      );

      // Verify all captions are rendered
      expect(find.text('First item caption'), findsOneWidget);
      expect(find.text('Second item caption'), findsOneWidget);
      expect(find.text('Third item caption'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders items in a Row', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: const StorySequence(
            items: testItems,
          ),
        ),
      );

      // Row should be present for horizontal layout
      expect(find.byType(Row), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('calls onItemTap when item is tapped', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      DentalItem? tappedItem;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: StorySequence(
            items: testItems.toList(),
            onItemTap: (item) {
              tappedItem = item;
            },
          ),
        ),
      );

      // Tap on the first item's caption
      await tester.tap(find.text('First item caption'));
      await tester.pumpAndSettle();

      expect(tappedItem, isNotNull);
      expect(tappedItem!.id, equals('item-1'));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('applies custom padding', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      const customPadding = EdgeInsets.all(32);

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: const StorySequence(
            items: testItems,
            padding: customPadding,
          ),
        ),
      );

      // Find the Padding widget with our custom padding
      final paddingFinder = find.byWidgetPredicate(
        (widget) => widget is Padding && widget.padding == customPadding,
      );
      expect(paddingFinder, findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses LayoutBuilder to calculate sizes', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: const StorySequence(
            items: testItems,
          ),
        ),
      );

      // LayoutBuilder should be present for dynamic sizing
      expect(find.byType(LayoutBuilder), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('supports content language for translations', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      // Use items with IDs that match ContentTranslations
      final translatedItems = [
        const DentalItem(
          id: 'dentist-chair',
          imagePath: 'assets/images/library/dentist_chair.png',
          caption: "This is the dentist's chair",
        ),
        const DentalItem(
          id: 'dentist-mask',
          imagePath: 'assets/images/library/dentist_mask.png',
          caption: 'The dentist wears a mask',
        ),
        const DentalItem(
          id: 'dentist-gloves',
          imagePath: 'assets/images/library/dentist_gloves.png',
          caption: 'The dentist wears a glove',
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: StorySequence(
            items: translatedItems,
            contentLanguage: ContentLanguage.en,
          ),
        ),
      );

      // With English language, should use translations
      expect(find.textContaining('dentist'), findsWidgets);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders correctly with different item counts', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      // Test with 2 items
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: StorySequence(
            items: testItems.sublist(0, 2),
          ),
        ),
      );

      expect(find.text('First item caption'), findsOneWidget);
      expect(find.text('Second item caption'), findsOneWidget);
      expect(find.text('Third item caption'), findsNothing);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('handles tap on multiple items', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      final tappedItems = <String>[];

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1200, 800),
          child: StorySequence(
            items: testItems.toList(),
            onItemTap: (item) {
              tappedItems.add(item.id);
            },
          ),
        ),
      );

      // Tap first item
      await tester.tap(find.text('First item caption'));
      await tester.pumpAndSettle();

      // Tap second item
      await tester.tap(find.text('Second item caption'));
      await tester.pumpAndSettle();

      expect(tappedItems, equals(['item-1', 'item-2']));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
