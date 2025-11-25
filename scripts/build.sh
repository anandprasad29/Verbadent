#!/bin/bash
# Build script for Verbadent
# Runs build_runner and regenerates localization files

set -e  # Exit on error

echo "🔨 Running build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "🌐 Generating localization files..."
flutter gen-l10n

echo "✅ Build complete!"



