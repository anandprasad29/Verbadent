# Verbadent CareQuest

Flutter application for Verbadent CareQuest with support for iPad, Android tablets, and web browsers.

## Platform Support

✅ **iOS (iPhone & iPad)**
- Universal app supporting both iPhone and iPad
- All orientations supported (portrait and landscape)
- Optimized for iPad screen sizes

✅ **Android (Phone & Tablet)**
- Supports all screen sizes (small, normal, large, xlarge)
- Tablet-optimized layouts
- All orientations supported

✅ **Web Browser**
- Responsive design for desktop and tablet browsers
- PWA support with manifest configuration
- Touch and mouse input support

## Design Tokens

### Colors
- **Primary Color:** `#4284F3` (Blue)
- **Background Color:** `#FFFFFF` (White)
- **Text Primary:** `#0A2D6D` (Dark Blue)
- **Text Secondary:** `#000000` (Black)
- **Neutral:** `#D9D9D9` (Light Gray)

### Font
- **Font Family:** Kumar One (Regular)

## Setup

1. Download the Kumar One font from [Google Fonts](https://fonts.google.com/specimen/Kumar+One)
2. Place the `KumarOne-Regular.ttf` file in the `fonts/` directory
3. Run `flutter pub get` to install dependencies
4. Run the app:
   - **iOS:** `flutter run -d ios` or open in Xcode
   - **Android:** `flutter run -d android`
   - **Web:** `flutter run -d chrome` or `flutter run -d web-server`

## Responsive Design

The app includes responsive utilities for adapting to different screen sizes:

- **Mobile:** < 600px width
- **Tablet:** 600px - 1200px width
- **Desktop/Web:** ≥ 1200px width

Font sizes and layouts automatically adjust based on screen size.

## Project Structure

```
lib/
  ├── main.dart              # App entry point
  ├── theme/
  │   ├── app_colors.dart    # Color constants
  │   └── app_theme.dart     # Responsive theme configuration
  └── utils/
      └── responsive.dart    # Responsive layout utilities
```

