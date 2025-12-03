#!/bin/bash
# Android Screenshot Capture Script
# Captures screenshots from Android Emulator for Play Store

set -e

OUTPUT_DIR="fastlane/metadata/android/en-US/images"
mkdir -p "$OUTPUT_DIR/phoneScreenshots"
mkdir -p "$OUTPUT_DIR/sevenInchScreenshots"
mkdir -p "$OUTPUT_DIR/tenInchScreenshots"

echo "📱 Android Screenshot Capture"
echo "=============================="

# Check if emulator is running
if ! adb devices | grep -q "emulator"; then
    echo "⚠️  No Android emulator running"
    echo "   Start an emulator first: emulator -avd <avd_name>"
    exit 1
fi

echo ""
echo "Running Flutter integration test with screenshots..."
echo ""

# Run Flutter integration test (captures screenshots via test)
cd "$(dirname "$0")/.."
flutter test integration_test/screenshot_test.dart -d emulator-5554 2>&1 || true

echo ""
echo "Capturing manual screenshots via ADB..."

# Function to capture screenshot
capture() {
    local name="$1"
    local output="$2"
    
    adb shell screencap -p /sdcard/screenshot.png
    adb pull /sdcard/screenshot.png "$output/${name}.png"
    adb shell rm /sdcard/screenshot.png
    echo "✅ Captured: $output/${name}.png"
}

# Capture current screen (manual navigation needed)
echo ""
echo "📸 Capturing current screen..."
capture "01_screenshot" "$OUTPUT_DIR/phoneScreenshots"

echo ""
echo "✅ Screenshot capture complete!"
echo ""
echo "📋 Manual steps for full screenshot set:"
echo "   1. Run: flutter run -d emulator-5554"
echo "   2. Navigate to each screen"
echo "   3. Run: adb shell screencap -p /sdcard/screen.png && adb pull /sdcard/screen.png"
echo ""
