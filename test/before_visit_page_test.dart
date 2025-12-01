import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbident/src/common/widgets/story_sequence.dart';
import 'package:verbident/src/features/before_visit/presentation/before_visit_page.dart';
import 'package:verbident/src/features/library/presentation/widgets/library_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the TTS platform channel
  const MethodChannel ttsChannel = MethodChannel('flutter_tts');

  setUpAll(() {
    // Initialize SharedPreferences mock for tests
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ttsChannel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'speak':
        case 'stop':
        case 'setLanguage':
        case 'setSpeechRate':
        case 'setVolume':
        case 'setPitch':
        case 'awaitSpeakCompletion':
          return 1;
        case 'getLanguages':
          return ['en-US', 'es-ES'];
        case 'getVoices':
          return [];
        case 'isLanguageAvailable':
          return 1;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ttsChannel, null);
  });

  /// Creates a test router with BeforeVisitPage as the initial route
  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/before-visit',
      routes: [
        GoRoute(
          path: '/before-visit',
          name: 'beforeVisit',
          builder: (context, state) => const BeforeVisitPage(),
        ),
      ],
    );
  }

  group('BeforeVisitPage Widget Tests', () {
    testWidgets('renders header in SliverAppBar', (tester) async {
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find the SliverAppBar
      expect(find.byType(SliverAppBar), findsOneWidget);

      // Find the FlexibleSpaceBar
      final flexSpaceBarFinder = find.byType(FlexibleSpaceBar);
      expect(flexSpaceBarFinder, findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders StorySequence widget', (tester) async {
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find StorySequence widget
      expect(find.byType(StorySequence), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders tools grid with LibraryCard items', (tester) async {
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find the SliverGrid
      expect(find.byType(SliverGrid), findsOneWidget);

      // Find LibraryCard widgets in the tools grid
      expect(find.byType(LibraryCard), findsWidgets);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders 5 columns on desktop (>=1200px content width)',
        (tester) async {
      // Screen width 1450 gives content 1200 (1450 - 250 sidebar)
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Find the SliverGrid
      final gridFinder = find.byType(SliverGrid);
      expect(gridFinder, findsOneWidget);

      // Verify grid has 5 columns
      final grid = tester.widget<SliverGrid>(gridFinder);
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(5));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders 3 columns on tablet (600-1199px)', (tester) async {
      tester.view.physicalSize = const Size(900, 700);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      final gridFinder = find.byType(SliverGrid);
      final grid = tester.widget<SliverGrid>(gridFinder);
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders 2 columns on mobile (<600px)', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      final gridFinder = find.byType(SliverGrid);
      final grid = tester.widget<SliverGrid>(gridFinder);
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(2));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses SliverAppBar for collapsible header', (tester) async {
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      final appBarFinder = find.byType(SliverAppBar);
      expect(appBarFinder, findsOneWidget);

      final appBar = tester.widget<SliverAppBar>(appBarFinder);
      expect(appBar.pinned, isTrue);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('displays dental content captions', (tester) async {
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Verify dental-related captions are present
      expect(find.textContaining('dentist'), findsWidgets);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows hamburger menu on mobile', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('tools grid has correct desktop spacing', (tester) async {
      // Screen width 1450 gives content 1200 (1450 - 250 sidebar) = desktop
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.mainAxisSpacing, equals(24.0));
      expect(delegate.crossAxisSpacing, equals(24.0));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('tools grid has correct mobile spacing', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.mainAxisSpacing, equals(16.0));
      expect(delegate.crossAxisSpacing, equals(16.0));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('renders 5 tool items in grid', (tester) async {
      tester.view.physicalSize = const Size(1450, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      // Scroll to see all items
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Tools grid should have 5 items
      expect(find.byType(LibraryCard), findsNWidgets(5));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('uses CustomScrollView for scrolling', (tester) async {
      tester.view.physicalSize = const Size(1450, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createTestRouter(),
          ),
        ),
      );

      expect(find.byType(CustomScrollView), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
