import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/routing/app_router.dart';
import 'src/theme/app_theme.dart';

class VerbadentApp extends ConsumerWidget {
  const VerbadentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      onGenerateTitle: (context) => 'Verbadent CareQuest',
      theme: AppTheme.staticLightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
