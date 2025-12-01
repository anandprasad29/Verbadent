# Verbident CareQuest

Flutter application for Verbident CareQuest deployed on **iOS and Android** across **mobile phones and tablets**.

## Deployment Platforms

| Platform | Device Types | Status |
|----------|--------------|--------|
| iOS | iPhone, iPad | ✅ **Deployed** |
| Android | Phone, Tablet | ✅ **Deployed** |

## Platform Support Details

### ✅ iOS (iPhone & iPad)
- Universal app supporting both iPhone and iPad
- All orientations supported (portrait and landscape)
- Optimized for iPad screen sizes with responsive layouts
- Native iOS look and feel with platform-specific adaptations

### ✅ Android (Phone & Tablet)
- Supports all screen sizes (small, normal, large, xlarge)
- Supports all screen densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- Tablet-optimized layouts with responsive grids
- All orientations supported
- Material Design integration

### Web Browser (Development/Testing)
- Responsive design for desktop and tablet browsers
- PWA support with manifest configuration
- Touch and mouse input support
- **Note**: Web is used for development and testing purposes

## Features

### Dashboard
- Main landing page with VERBIDENT branding
- Responsive sidebar navigation (desktop) or drawer menu (mobile)

### Before the Visit
- **Story Sequence**: Horizontal flow of dental visit steps connected by arrows
- **Tools Grid**: Responsive grid of dental tools and actions
- Text-to-speech: tap any item to hear its caption
- Content localization (English/Spanish)
- Tap feedback animations

### Library
- Scrollable grid of dental-related images with captions
- Text-to-speech: tap any image to hear its caption
- Collapsing header that minimizes on scroll
- Responsive grid layout (5/3/2 columns based on screen size)
- Content localization (English/Spanish)

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
└── src/
    ├── common/                  # Shared components
    │   ├── domain/
    │   │   └── dental_item.dart # Shared data model
    │   └── widgets/
    │       ├── image_card.dart      # Generic image+caption card
    │       ├── story_sequence.dart  # Horizontal story with arrows
    │       └── tappable_card.dart   # Tap feedback wrapper
    ├── constants/
    │   └── app_constants.dart   # Dimensions, breakpoints, grid settings
    ├── features/
    │   ├── before_visit/
    │   │   ├── data/            # Content data
    │   │   └── presentation/    # UI (before_visit_page.dart)
    │   ├── dashboard/
    │   │   └── presentation/
    │   │       └── dashboard_page.dart
    │   └── library/
    │       ├── data/            # Sample data
    │       ├── domain/          # Data models
    │       ├── presentation/    # UI widgets
    │       └── services/        # TTS service
    ├── localization/
    │   ├── app_en.arb           # English UI strings
    │   ├── app_es.arb           # Spanish UI strings
    │   ├── content_language_provider.dart  # Language state
    │   └── content_translations.dart       # Caption translations
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
    ├── before_visit/            # Before Visit content images
    └── library/                 # Library content images

fonts/
├── KumarOne-Regular.ttf
└── InstrumentSans-Bold.ttf

test/
├── before_visit_page_test.dart  # Before Visit page tests
├── library_card_test.dart       # LibraryCard widget tests
├── library_page_test.dart       # LibraryPage widget tests
├── sidebar_test.dart            # Sidebar navigation tests
├── story_sequence_test.dart     # StorySequence widget tests
└── ...                          # Additional test files
```

## Testing

```bash
# Run all tests (209 tests)
flutter test

# Run with coverage
flutter test --coverage

# Update golden files
flutter test --update-goldens
```

## Localization

The app supports content in multiple languages:

| Language | Code | TTS Code |
|----------|------|----------|
| English  | en   | en-US    |
| Spanish  | es   | es-ES    |

Content captions can be localized independently of the UI language. The TTS engine automatically syncs with the selected content language.

## Architecture

The app follows a **Feature-First** architecture with:
- **Riverpod** for state management (code generation)
- **GoRouter** for navigation
- **AppShell** for consistent layout across pages
- **Shared components** in `common/` for cross-feature reuse
- Centralized constants, colors, and text styles
- Content localization with TTS integration

### Key Patterns
- `TappableCard` - Wrap interactive elements for tap feedback
- `StorySequence` - Display sequential content with arrows
- `DentalItem` - Unified model for dental content
- `Responsive.getGridColumnCount()` - Responsive grid helpers

See [Agents.md](./Agents.md) for detailed architecture documentation.
