import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbident/src/localization/app_localizations.dart';
import 'package:verbident/src/localization/content_language_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the TTS platform channel
  const MethodChannel ttsChannel = MethodChannel('flutter_tts');

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ttsChannel, (MethodCall methodCall) async {
      return null;
    });
  });

  group('Locale wiring', () {
    testWidgets(
        'switching ContentLanguage to es causes AppLocalizations to return Spanish strings',
        (tester) async {
      // Build a minimal app with localization support and a ContentLanguage override
      late WidgetRef capturedRef;

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              final contentLanguage =
                  ref.watch(contentLanguageNotifierProvider);
              return MaterialApp(
                locale: Locale(contentLanguage.code),
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Scaffold(
                      body: Column(
                        children: [
                          Text(l10n?.navLibrary ?? 'MISSING',
                              key: const Key('navLibrary')),
                          Text(l10n?.navSettings ?? 'MISSING',
                              key: const Key('navSettings')),
                          Text(l10n?.ok ?? 'MISSING', key: const Key('ok')),
                          Text(
                              l10n?.templateNotFound ?? 'MISSING',
                              key: const Key('templateNotFound')),
                          Text(l10n?.allImagesAdded ?? 'MISSING',
                              key: const Key('allImagesAdded')),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify English strings initially
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Template not found'), findsOneWidget);
      expect(find.text('All images have been added'), findsOneWidget);

      // Switch to Spanish
      capturedRef
          .read(contentLanguageNotifierProvider.notifier)
          .setLanguage(ContentLanguage.es);
      await tester.pumpAndSettle();

      // Verify Spanish strings
      expect(find.text('Biblioteca'), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);
      expect(find.text('Aceptar'), findsOneWidget);
      expect(find.text('Plantilla no encontrada'), findsOneWidget);
      expect(find.text('Todas las imágenes han sido agregadas'),
          findsOneWidget);
    });
  });
}
