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

## Features

### Dashboard
- Main landing page with VERBADENT branding
- Responsive sidebar navigation (desktop) or drawer menu (mobile)

### Library
- Scrollable grid of dental-related images with captions
- Text-to-speech: tap any image to hear its caption
- Collapsing header that minimizes on scroll
- Responsive grid layout (5/3/2 columns based on screen size)

## Design Tokens

### Colors (defined in `lib/src/theme/app_colors.dart`)
- **Primary:** `#5483F5` (Blue - sidebar, accents)
- **Background:** `#FFFFFF` (White)
- **Text Primary:** `#0A2D6D` (Dark Blue - headers)
- **Text Title:** `#1B2B57` (Navy - main titles)
- **Text Secondary:** `#000000` (Black - body text)
- **Sidebar Item:** `#D9D9D9` (Light Gray - buttons)
- **Card Border:** `#5483F5` (Blue - image borders)

### Fonts
- **Kumar One** - Headers, branding, navigation labels
- **Instrument Sans Bold** - Image captions, body text

## Setup

1. Download the fonts:
   - [Kumar One](https://fonts.google.com/specimen/Kumar+One) → `fonts/KumarOne-Regular.ttf`
   - [Instrument Sans](https://fonts.google.com/specimen/Instrument+Sans) → `fonts/InstrumentSans-Bold.ttf`

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code (Riverpod providers):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   
   # Web
   flutter run -d chrome
   ```

## Responsive Design

The app includes responsive utilities for adapting to different screen sizes:

| Device  | Width       | Grid Columns | Sidebar   |
|---------|-------------|--------------|-----------|
| Mobile  | < 600px     | 2            | Drawer    |
| Tablet  | 600-1200px  | 3            | Drawer*   |
| Desktop | ≥ 1200px    | 5            | Permanent |

*Sidebar appears as drawer below 800px width.

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # MaterialApp.router configuration
├── dashboard_screen.dart        # Legacy (to be removed)
└── src/
    ├── constants/
    │   └── app_constants.dart   # Dimensions, breakpoints, grid settings
    ├── features/
    │   ├── dashboard/
    │   │   └── presentation/
    │   │       └── dashboard_page.dart
    │   └── library/
    │       ├── data/            # Sample data
    │       ├── domain/          # Data models
    │       ├── presentation/    # UI widgets
    │       └── services/        # TTS service
    ├── routing/
    │   ├── app_router.dart      # GoRouter configuration
    │   └── routes.dart          # Route path constants
    ├── theme/
    │   ├── app_colors.dart      # Color constants
    │   ├── app_text_styles.dart # Text style constants
    │   └── app_theme.dart       # Theme configuration
    ├── utils/
    │   └── responsive.dart      # Responsive layout utilities
    └── widgets/
        ├── app_shell.dart       # Shared layout (sidebar/drawer)
        └── sidebar.dart         # Navigation sidebar

assets/
└── images/
    └── library/                 # Library content images

fonts/
├── KumarOne-Regular.ttf
└── InstrumentSans-Bold.ttf

test/
├── library_card_test.dart       # LibraryCard widget tests
├── library_page_test.dart       # LibraryPage widget tests
├── sidebar_test.dart            # Sidebar navigation tests
└── dashboard_screen_test.dart   # Dashboard tests
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Update golden files
flutter test --update-goldens
```

## Architecture

The app follows a **Feature-First** architecture with:
- **Riverpod** for state management (code generation)
- **GoRouter** for navigation
- **AppShell** for consistent layout across pages
- Centralized constants, colors, and text styles

See [Agents.md](./Agents.md) for detailed architecture documentation.
