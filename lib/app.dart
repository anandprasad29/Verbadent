import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/localization/app_localizations.dart';
import 'src/routing/app_router.dart';
import 'src/theme/app_theme.dart';
import 'src/theme/theme_provider.dart';

class VerbadentApp extends ConsumerWidget {
  const VerbadentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      onGenerateTitle: (context) => 'Verbadent CareQuest',
      theme: AppTheme.staticLightTheme,
      darkTheme: AppTheme.staticDarkTheme,
      themeMode: themeMode.themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
