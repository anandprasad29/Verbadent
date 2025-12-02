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

### Build Your Own
- Create custom templates by selecting images from the library
- Name and save personalized collections (up to 5 templates)
- Edit existing templates: rename, add/remove images, reorder with drag-and-drop
- Templates persist locally via SharedPreferences
- Search/filter images during template creation
- Delete templates with confirmation dialog

### Library
- Scrollable grid of dental-related images with captions
- Text-to-speech: tap any image to hear its caption
- Collapsing header that minimizes on scroll
- Responsive grid layout (5/3/2 columns based on screen size)
- Search/filter images by caption
- Content localization (English/Spanish)

### Settings
- **Theme**: Light, Dark, or System (auto-detect) modes
- **Voice Settings**: Male or Female TTS voice selection
- **Speech Rate**: Adjustable from Slow to Very Fast
- Test speech button to preview settings

## Design Tokens

### Colors (defined in `lib/src/theme/app_colors.dart`)

**Light Theme:**
- **Primary:** `#5483F5` (Blue - sidebar, accents)
- **Background:** `#FFFFFF` (White)
- **Text Primary:** `#0A2D6D` (Dark Blue - headers)
- **Text Title:** `#1B2B57` (Navy - main titles)
- **Text Secondary:** `#000000` (Black - body text)
- **Sidebar Item:** `#D9D9D9` (Light Gray - buttons)
- **Card Border:** `#5483F5` (Blue - image borders)

**Dark Theme:**
- **Background:** `#1A1A2E` (Dark Navy)
- **Card Background:** `#16213E` (Darker Navy)
- **Text colors** automatically adjusted for contrast

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
    │   ├── data/
    │   │   └── dental_items.dart    # Single source of truth for all dental content
    │   ├── domain/
    │   │   └── dental_item.dart     # Shared data model
    │   └── widgets/
    │       ├── accessible_tap_target.dart  # A11y tap target
    │       ├── error_boundary.dart         # Error handling wrapper
    │       ├── image_card.dart             # Generic image+caption card
    │       ├── skeleton_card.dart          # Loading placeholder
    │       ├── speaking_indicator.dart     # TTS active indicator
    │       ├── story_sequence.dart         # Horizontal story with arrows
    │       └── tappable_card.dart          # Tap feedback wrapper
    ├── constants/
    │   └── app_constants.dart   # Dimensions, breakpoints, grid settings
    ├── features/
    │   ├── before_visit/
    │   │   └── presentation/    # UI (before_visit_page.dart)
    │   ├── build_own/
    │   │   ├── data/            # Template storage service
    │   │   ├── domain/          # CustomTemplate model
    │   │   └── presentation/    # BuildOwnPage, CustomTemplatePage
    │   ├── dashboard/
    │   │   └── presentation/
    │   │       └── dashboard_page.dart
    │   ├── library/
    │   │   ├── domain/          # Re-exports DentalItem
    │   │   ├── presentation/    # UI widgets
    │   │   └── services/        # TTS service
    │   └── settings/
    │       └── presentation/    # SettingsPage (theme, TTS controls)
    ├── localization/
    │   ├── app_en.arb           # English UI strings
    │   ├── app_es.arb           # Spanish UI strings
    │   ├── content_language_provider.dart  # Language state
    │   └── content_translations.dart       # Caption translations
    ├── routing/
    │   ├── app_router.dart      # GoRouter configuration
    │   └── routes.dart          # Route path constants
    ├── theme/
    │   ├── app_colors.dart      # Color constants (light & dark)
    │   ├── app_text_styles.dart # Text style constants
    │   ├── app_theme.dart       # Theme configuration
    │   └── theme_provider.dart  # Theme mode state (light/dark/system)
    ├── utils/
    │   └── responsive.dart      # Responsive layout utilities
    └── widgets/
        ├── app_shell.dart       # Shared layout (sidebar/drawer)
        ├── language_selector.dart  # Content language dropdown
        └── sidebar.dart         # Navigation sidebar

assets/
└── images/
    └── library/                 # All dental content images (single source)

fonts/
├── KumarOne-Regular.ttf
└── InstrumentSans-Bold.ttf

test/
├── before_visit_page_test.dart  # Before Visit page tests
├── build_own_page_test.dart     # Build Your Own tests
├── library_card_test.dart       # LibraryCard widget tests
├── library_page_test.dart       # LibraryPage widget tests
├── settings_page_test.dart      # Settings page tests
├── sidebar_test.dart            # Sidebar navigation tests
├── story_sequence_test.dart     # StorySequence widget tests
└── ...                          # Additional test files
```

## Testing

```bash
# Run all tests (365 tests)
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
- **Dark theme** support with system auto-detection

### Key Patterns
- `TappableCard` - Wrap interactive elements for tap feedback
- `StorySequence` - Display sequential content with arrows
- `DentalItem` - Unified model for dental content
- `SelectableLibraryCard` - Card with selection state for template building
- `LanguageSelector` - Dropdown for content language switching
- `Responsive.getGridColumnCount()` - Responsive grid helpers
- `ThemeModeNotifier` - Manage light/dark/system theme state

See [Agents.md](./Agents.md) for detailed architecture documentation.

## Deployment

The app uses **Fastlane** for automated deployments to TestFlight and Google Play.

### Prerequisites

- [Fastlane](https://fastlane.tools/) installed (`brew install fastlane`)
- API keys configured in `fastlane/` folder (gitignored for security)

### Deploy to TestFlight (iOS)

```bash
# Bump build number first
fastlane bump

# Build and upload to TestFlight
fastlane ios beta
```

### Deploy to Google Play (Android)

```bash
# Bump build number first
fastlane bump

# Build and upload to Internal Testing
fastlane android beta
```

### Available Fastlane Commands

| Command | Description |
|---------|-------------|
| `fastlane bump` | Increment build number in pubspec.yaml |
| `fastlane ios beta` | Build and upload to TestFlight |
| `fastlane android beta` | Build and upload to Play Store Internal Testing |

### Release Workflow

1. Make your code changes
2. Run tests: `flutter test`
3. Bump version: `fastlane bump`
4. Deploy iOS: `fastlane ios beta`
5. Deploy Android: `fastlane android beta`
6. Commit the version bump

### Store Links

- **App Store Connect**: [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- **Google Play Console**: [play.google.com/console](https://play.google.com/console)
