import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> main() async {
  // Preserve splash screen until app is ready
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase (required before app starts)
  await Firebase.initializeApp();

  // Configure Crashlytics error handlers (synchronous - no await needed)
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Run non-critical initialization in parallel to reduce startup time
  // These don't need to complete before the app renders
  unawaited(_postInitialization());

  runApp(const ProviderScope(child: VerbidentApp()));
}

/// Non-critical initialization that can run after app starts rendering.
/// This reduces perceived startup time.
Future<void> _postInitialization() async {
  // Disable Crashlytics in debug mode for cleaner logs
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // Set preferred orientations (all orientations allowed, so non-blocking is fine)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
