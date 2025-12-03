#!/bin/bash
# iOS Screenshot Capture Script using Flutter Integration Tests
# Captures screenshots from iOS Simulator at App Store required resolutions

set -e

OUTPUT_DIR="fastlane/screenshots/en-US"
mkdir -p "$OUTPUT_DIR"

echo "📱 iOS Screenshot Capture"
echo "========================="

# Device configurations (name, output suffix)
declare -a DEVICES=(
    "iPhone 16 Pro Max:iphone_6.9"
    "iPhone 15 Pro Max:iphone_6.7"
    "iPhone 8 Plus:iphone_5.5"
    "iPad Pro 12.9-inch (6th generation):ipad_12.9"
    "iPad Pro 11-inch (4th generation):ipad_11"
)

capture_screenshots() {
    local device_name="$1"
    local suffix="$2"
    
    echo ""
    echo "📱 Capturing on: $device_name"
    
    # Boot simulator
    xcrun simctl boot "$device_name" 2>/dev/null || true
    
    # Run the app
    flutter run -d "$device_name" --release &
    APP_PID=$!
    
    # Wait for app to launch
    sleep 10
    
    # Capture screenshots
    xcrun simctl io booted screenshot "$OUTPUT_DIR/01_Dashboard_${suffix}.png"
    sleep 1
    
    # Note: Navigation would need to be done via accessibility or tap coordinates
    # For now, capture the current screen
    
    # Kill the app
    kill $APP_PID 2>/dev/null || true
    
    echo "✅ Captured screenshots for $device_name"
}

echo ""
echo "⚠️  Note: For full automated screenshots, add UI test target to Xcode project"
echo "    or use Flutter Driver tests with screenshot capture."
echo ""
echo "Manual capture instructions:"
echo "1. Run: flutter run -d 'iPhone 16 Pro Max'"  
echo "2. Navigate to each screen"
echo "3. Press Cmd+S in Simulator to save screenshot"
echo ""
