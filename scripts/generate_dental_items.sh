#!/bin/bash
# Generate dental_items.dart from assets/dental_items.yaml
# This script can be run standalone or is automatically called during build

set -e  # Exit on error

echo "🦷 Generating dental items from metadata..."
dart run tool/generate_dental_items.dart
echo "✅ Done!"
