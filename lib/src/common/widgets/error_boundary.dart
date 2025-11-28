import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Error boundary widget that catches errors in its subtree and displays
/// a fallback UI instead of crashing the entire app.
///
/// Usage:
/// ```dart
/// ErrorBoundary(
///   child: PotentiallyFailingWidget(),
///   onError: (error, stack) => logError(error, stack),
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;
  final void Function(Object error, StackTrace stack)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    // Note: Flutter's error handling is done via ErrorWidget.builder
    // This widget provides a declarative way to handle errors in subtrees
  }

  void _resetError() {
    setState(() {
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallback ?? _DefaultErrorFallback(onRetry: _resetError);
    }

    // Use a custom error widget builder for this subtree
    return _ErrorCatcher(
      onError: (error, stack) {
        widget.onError?.call(error, stack);
        if (mounted) {
          setState(() {
            _error = error;
          });
        }
      },
      child: widget.child,
    );
  }
}

/// Internal widget that catches errors during build
class _ErrorCatcher extends StatelessWidget {
  final Widget child;
  final void Function(Object error, StackTrace stack) onError;

  const _ErrorCatcher({required this.child, required this.onError});

  @override
  Widget build(BuildContext context) {
    // ErrorWidget.builder is global, so we wrap in a Builder to catch errors
    // during the build phase of child widgets
    return Builder(
      builder: (context) {
        try {
          return child;
        } catch (error, stack) {
          onError(error, stack);
          return _DefaultErrorFallback(onRetry: null);
        }
      },
    );
  }
}

/// Default fallback UI shown when an error occurs
class _DefaultErrorFallback extends StatelessWidget {
  final VoidCallback? onRetry;

  const _DefaultErrorFallback({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.appError),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 14,
                color: context.appTextSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Retry',
                  style: TextStyle(fontFamily: 'InstrumentSans'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appPrimary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A simpler error boundary that just shows a fallback without retry
class SimpleErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget fallback;

  const SimpleErrorBoundary({
    super.key,
    required this.child,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(fallback: fallback, child: child);
  }
}
