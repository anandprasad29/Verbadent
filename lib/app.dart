import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/localization/app_localizations.dart';
import 'src/routing/app_router.dart';
import 'src/theme/app_theme.dart';

class VerbadentApp extends ConsumerWidget {
  const VerbadentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      // Use static theme initially, will be updated in HomePage
      theme: AppTheme.staticLightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
