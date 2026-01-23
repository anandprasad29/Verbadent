#!/bin/bash
# Build script for Verbident
# Generates code, runs build_runner, and regenerates localization files

set -e  # Exit on error

echo "🦷 Generating dental items..."
dart run tool/generate_dental_items.dart

echo "🔨 Running build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "🌐 Generating localization files..."
flutter gen-l10n

echo "✅ Build complete!"





