#!/bin/bash
# App Store Screenshot Capture Script for Verbident
# Captures screenshots from iOS Simulator at required resolutions

set -e

# Create output directory
OUTPUT_DIR="app_store_screenshots"
mkdir -p "$OUTPUT_DIR"

echo "📱 App Store Screenshot Capture"
echo "================================"
echo ""

# Device for 6.5" display screenshots (1242 × 2688 or 1284 × 2778)
DEVICE_65="iPhone 16 Pro Max"

echo "📋 Required Screenshot Sizes:"
echo "  • iPhone 6.5\" Display: 1284 × 2778px (portrait) or 2778 × 1284px (landscape)"
echo "  • iPhone 6.7\" Display: 1290 × 2796px (portrait) or 2796 × 1290px (landscape)"  
echo "  • iPhone 5.5\" Display: 1242 × 2208px (optional, for older devices)"
echo "  • iPad Pro 12.9\" (6th gen): 2048 × 2732px"
echo "  • iPad Pro 12.9\" (2nd gen): 2048 × 2732px"
echo ""

echo "🚀 Steps to capture screenshots:"
echo ""
echo "1. Start the simulator:"
echo "   open -a Simulator"
echo ""
echo "2. Boot the device:"
echo "   xcrun simctl boot '$DEVICE_65'"
echo ""
echo "3. Run your Flutter app:"
echo "   flutter run -d '$DEVICE_65'"
echo ""
echo "4. Navigate to each screen and capture:"
echo "   - Press Cmd+S in Simulator to save screenshot"
echo "   - Or use: xcrun simctl io booted screenshot screenshot_name.png"
echo ""
echo "5. Recommended screens to capture:"
echo "   1. Dashboard - Main landing page with VERBIDENT branding"
echo "   2. Library - Image grid showing dental tools/procedures"
echo "   3. Before Visit - Story sequence for visit preparation"
echo "   4. Build Your Own - Custom template creation"
echo "   5. Settings - Theme and speech options"
echo ""

# Check if simulator is running
if xcrun simctl list devices | grep -q "Booted"; then
    echo "✅ Simulator is running"
    
    # Get booted device UDID
    UDID=$(xcrun simctl list devices | grep "Booted" | head -1 | grep -oE "[A-F0-9-]{36}")
    
    if [ -n "$UDID" ]; then
        echo "📸 Taking screenshot of current screen..."
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        xcrun simctl io "$UDID" screenshot "$OUTPUT_DIR/screenshot_$TIMESTAMP.png"
        echo "✅ Saved to $OUTPUT_DIR/screenshot_$TIMESTAMP.png"
    fi
else
    echo "⚠️  No simulator is currently running"
    echo ""
    echo "To start, run:"
    echo "  xcrun simctl boot '$DEVICE_65'"
    echo "  open -a Simulator"
fi

echo ""
echo "📁 Screenshots will be saved to: $OUTPUT_DIR/"

