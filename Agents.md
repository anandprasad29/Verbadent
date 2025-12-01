                                                            # Verbident CareQuest - AI Context & Agent Guide

## Project Overview
Verbident CareQuest is a Flutter application for dental/healthcare management, targeting **iOS and Android** across **mobile phones and tablets**. It focuses on responsive design to support different screen sizes seamlessly.

## Deployment Platforms
| Platform | Device Types | Status |
|----------|--------------|--------|
| **iOS** | iPhone, iPad | ✅ Deployed |
| **Android** | Phone, Tablet | ✅ Deployed |

### Device Support
- **iOS (iPhone & iPad)**: Universal app supporting all iPhone and iPad devices with all orientations
- **Android (Phone & Tablet)**: Supports all screen densities (mdpi to xxxhdpi) and screen sizes (small, normal, large, xlarge)

## Current Status
- **Phase**: Feature Development
- **Focus**: Building dental visit journey features with reusable component architecture.
- **Completed Features**: 
  - Dashboard page with responsive sidebar navigation
  - Library page with image grid and text-to-speech
  - **Before Visit page** with story sequence and tools grid
  - Shared AppShell layout component
  - Data-driven sidebar with active route highlighting
  - Content localization (English/Spanish) with TTS language sync
  - Tap feedback animations on interactive cards

## Tech Stack
- **Framework**: Flutter (SDK > 3.5.2)
- **Language**: Dart
- **State Management**: Flutter Riverpod (v2.6+) using `riverpod_annotation` and code generation.
- **Navigation**: GoRouter (v14+)
- **Text-to-Speech**: flutter_tts (v4.0+)
- **Design**: Custom design system using "Kumar One" and "Instrument Sans" fonts.

## Architecture & Folder Structure
We follow a **Feature-First** architecture. Code is organized by business domain rather than technical layer. Shared components are extracted to `common/` for cross-feature reuse.

### Directory Structure (`lib/src/`)

```
lib/src/
├── common/                         # Shared components across features
│   ├── domain/
│   │   └── dental_item.dart        # Shared data model for dental content
│   └── widgets/
│       ├── image_card.dart         # Generic image+caption card
│       ├── story_sequence.dart     # Horizontal story row with arrows
│       └── tappable_card.dart      # Tap feedback animation wrapper
├── constants/
│   └── app_constants.dart          # Dimensions, breakpoints, grid settings
├── features/
│   ├── before_visit/
│   │   ├── data/
│   │   │   └── before_visit_data.dart  # Story and tools content
│   │   └── presentation/
│   │       └── before_visit_page.dart
│   ├── dashboard/
│   │   └── presentation/
│   │       └── dashboard_page.dart
│   └── library/
│       ├── data/
│       │   └── library_data.dart       # Sample data
│       ├── domain/
│       │   └── library_item.dart       # Re-exports DentalItem
│       ├── presentation/
│       │   ├── library_page.dart
│       │   └── widgets/
│       │       └── library_card.dart
│       └── services/
│           └── tts_service.dart        # Text-to-speech (Riverpod)
├── localization/
│   ├── app_en.arb                  # English UI strings
│   ├── app_es.arb                  # Spanish UI strings
│   ├── app_localizations.dart      # Generated localization
│   ├── content_language_provider.dart  # Content language state
│   └── content_translations.dart   # Caption translations by ID
├── routing/
│   ├── app_router.dart             # GoRouter configuration
│   ├── app_router.g.dart           # Generated
│   └── routes.dart                 # Route path constants
├── theme/
│   ├── app_colors.dart             # Centralized color definitions
│   ├── app_text_styles.dart        # Centralized text styles
│   └── app_theme.dart              # Theme configuration
├── utils/
│   └── responsive.dart             # Responsive layout utilities + grid helpers
└── widgets/
    ├── app_shell.dart              # Shared desktop/mobile layout
    └── sidebar.dart                # Data-driven sidebar with navigation
```

## Coding Standards & Patterns

### 1. State Management (Riverpod)
- **ALWAYS** use code generation (`@riverpod`) for providers. Do not use manual `Provider` or `StateProvider` definitions unless absolutely necessary.
- Prefer `AutoDispose` providers by default (default behavior of generator).
- Use `Ref` as the argument type in provider functions.
- Services should be Riverpod providers for lifecycle management.

### 2. Navigation (GoRouter)
- Define routes in `lib/src/routing/app_router.dart`.
- **ALWAYS** use route constants from `lib/src/routing/routes.dart` instead of hardcoded strings.
- Centralize navigation logic in the router provider.

### 3. Constants & Theming
- **Colors**: Use `AppColors` class from `lib/src/theme/app_colors.dart`. Never hardcode `Color(0xFF...)`.
- **Dimensions**: Use `AppConstants` class for breakpoints, spacing, border radius, etc.
- **Text Styles**: Use `AppTextStyles` class for consistent typography.

### 4. UI & Responsiveness
- Use the `Responsive` class utilities for screen size checks and grid layout values.
- **Grid Layout Helpers** (use these instead of duplicating logic):
  - `Responsive.getGridColumnCount(context)` - Returns 5/3/2 columns
  - `Responsive.getGridSpacing(context)` - Returns 24/20/16 spacing
  - `Responsive.getContentPadding(context)` - Returns responsive EdgeInsets
- **Breakpoints** (defined in `AppConstants`):
  - Mobile: < 600px
  - Tablet: 600px - 1200px
  - Desktop: ≥ 1200px
  - Sidebar breakpoint: 800px
- **Fonts**: 
  - "Kumar One" for headers/branding
  - "Instrument Sans" for captions/body text

### 5. Shared Layout (AppShell)
- **ALWAYS** use `AppShell` widget for pages that need sidebar navigation.
- `AppShell` handles:
  - Desktop: Permanent sidebar (250px width)
  - Mobile: Hamburger menu with drawer
- Example usage:
  ```dart
  return AppShell(
    child: YourPageContent(),
  );
  ```

### 6. Shared Components (common/)
- **DentalItem**: Use for any dental content with id, imagePath, caption.
- **TappableCard**: Wrap interactive elements for tap feedback animation.
- **StorySequence**: Use for horizontal story flows with arrow connectors.
- **ImageCard**: Use for standalone image+caption cards.

Example using TappableCard:
```dart
TappableCard(
  onTap: () => handleTap(),
  child: YourContent(),
)
```

### 7. Sidebar Navigation
- Sidebar items are configured in `SidebarConfig.items` (data-driven).
- Active route is automatically highlighted.
- To add a new sidebar item:
  1. Add route constant to `Routes` class
  2. Add `GoRoute` in `app_router.dart`
  3. Add `SidebarItemData` to `SidebarConfig.items`

### 8. Localization
- **NEVER hardcode strings** in the app. All user-facing text must be localizable.
- **ALWAYS** use localization for any text displayed to users, including:
  - Page titles and headers
  - Button labels
  - Error messages
  - Placeholder text
  - Tooltips and hints
  - Accessibility labels
- **UI Strings**: Use `AppLocalizations.of(context)` for page headers, labels.
- **Content Captions**: Use `ContentTranslations.getCaption(itemId, language)` for dental content.
- **TTS Language**: Sync with `contentLanguageNotifierProvider` using `ref.listen`.
- **Adding new strings**:
  1. Add the string key and English text to `lib/src/localization/app_en.arb`
  2. Add the corresponding Spanish translation to `lib/src/localization/app_es.arb`
  3. Run `flutter gen-l10n` or rebuild to generate the localization code
  4. Use `AppLocalizations.of(context)!.yourStringKey` in your widget
- Pattern for pages with localized content:
  ```dart
  final l10n = AppLocalizations.of(context);
  final contentLanguage = ref.watch(contentLanguageNotifierProvider);
  
  ref.listen<ContentLanguage>(contentLanguageNotifierProvider, (prev, next) {
    ttsService.setLanguage(next);
  });
  ```

### 9. Testing Strategy
- **Widget Tests**: Run `flutter test` to verify UI components, responsiveness, and accessibility.
- **Golden Tests**: Run `flutter test --update-goldens` to generate/update reference images.
- **Integration Tests**: Run `flutter test integration_test/app_test.dart` on a real device/emulator.
- **Regression Policy**: **ALWAYS** run `flutter test` after completing a task to ensure no regressions were introduced.
- Test files location: `test/` directory with `*_test.dart` naming.
- Current test count: **340 tests**

### 10. Git Best Practices
Follow these git conventions for all commits:

#### Commit Size & Atomicity
- **Keep commits small and focused**: Each commit should represent ONE logical change.
- **Atomic commits**: Every commit should leave the codebase in a working state (tests pass, app compiles).
- **Single responsibility**: One commit = one feature, one bug fix, or one refactor. Never mix.

#### Commit Message Format
Use conventional commit format:
```
<type>(<scope>): <short summary>

[optional body with more details]

[optional footer with breaking changes or issue references]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding or updating tests
- `docs`: Documentation changes
- `style`: Formatting, missing semicolons, etc. (no code change)
- `chore`: Maintenance tasks, dependency updates

**Examples**:
```
feat(build-own): add CustomTemplate domain model

fix(sidebar): resolve template loading state flicker

test(build-own): add storage service unit tests

refactor(providers): extract template validation logic
```

#### Commit Ordering for Features
When implementing a new feature, commit in this order:
1. **Dependencies**: Package additions (pubspec.yaml)
2. **Domain/Models**: Data models and entities
3. **Data Layer**: Services, repositories, storage
4. **State Management**: Providers, notifiers
5. **UI Components**: Reusable widgets
6. **Pages/Screens**: Feature pages
7. **Routing**: Route definitions and navigation
8. **Integration**: Connecting to existing code (sidebar, etc.)
9. **Localization**: Strings and translations
10. **Tests**: Unit tests, widget tests

#### Pre-Commit Checklist
Before each commit:
- [ ] Run `flutter analyze` - no errors
- [ ] Run `flutter test` - all tests pass
- [ ] Code compiles without errors
- [ ] Changes are logically grouped
- [ ] Commit message follows convention

## Development Workflow

### Code Generation
Since we use `riverpod_generator` and `go_router_builder`, you must run the build runner to generate code.
- **One-time build**: `dart run build_runner build --delete-conflicting-outputs`
- **Watch mode**: `dart run build_runner watch -d`

### Running the App
- iOS: `flutter run -d ios`
- Android: `flutter run -d android`
- Web: `flutter run -d chrome`

### Adding a New Feature
1. Create feature folder under `lib/src/features/<feature_name>/`
2. Add subdirectories: `presentation/`, `domain/`, `data/`, `services/` as needed
3. Add route constant to `Routes` class
4. Add route to `app_router.dart`
5. Add sidebar item to `SidebarConfig` if navigable
6. Use `AppShell` for consistent layout
7. Use `Responsive.getGridColumnCount()` etc. for responsive grids
8. Use `TappableCard` for interactive elements
9. Add localization entries to ARB files and `ContentTranslations`
10. Write tests in `test/<feature>_test.dart`

### Adding Dental Content
1. Use `DentalItem` model with unique `id`
2. Add images to `assets/images/<feature>/`
3. Register asset folder in `pubspec.yaml`
4. Add caption translations to `ContentTranslations._captions`

## Assets
- **Images**: 
  - `assets/images/library/` - Library content images
  - `assets/images/before_visit/` - Before Visit content images
- **Fonts**: 
  - `fonts/KumarOne-Regular.ttf` - Headers
  - `fonts/InstrumentSans-Bold.ttf` - Captions
