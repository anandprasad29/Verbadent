#!/bin/bash
# Watch script for Verbadent development
# Runs build_runner in watch mode and ensures localization files exist

set -e  # Exit on error

# Generate localization files first
echo "🌐 Generating localization files..."
flutter gen-l10n

echo "👀 Starting build_runner watch mode..."
echo "   (Press Ctrl+C to stop)"
echo ""

# Run build_runner watch - note: this may delete l10n files on changes
# If l10n files get deleted, run: flutter gen-l10n
dart run build_runner watch --delete-conflicting-outputs


