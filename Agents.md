# Verbadent CareQuest - AI Context & Agent Guide

## Project Overview
Verbadent CareQuest is a Flutter application for dental/healthcare management, targeting iOS, Android, and Web. It focuses on responsive design to support phones, tablets, and desktop browsers seamlessly.

## Current Status
- **Phase**: Feature Development
- **Focus**: Building the Library feature and establishing reusable architecture patterns.
- **Completed Features**: 
  - Dashboard page with responsive sidebar navigation
  - Library page with image grid and text-to-speech
  - Shared AppShell layout component
  - Data-driven sidebar with active route highlighting

## Tech Stack
- **Framework**: Flutter (SDK > 3.5.2)
- **Language**: Dart
- **State Management**: Flutter Riverpod (v2.6+) using `riverpod_annotation` and code generation.
- **Navigation**: GoRouter (v14+)
- **Text-to-Speech**: flutter_tts (v4.0+)
- **Design**: Custom design system using "Kumar One" and "Instrument Sans" fonts.

## Architecture & Folder Structure
We follow a **Feature-First** architecture. Code is organized by business domain rather than technical layer.

### Directory Structure (`lib/src/`)

```
lib/src/
├── constants/
│   └── app_constants.dart      # Dimensions, breakpoints, grid settings
├── features/
│   ├── dashboard/
│   │   └── presentation/
│   │       └── dashboard_page.dart
│   └── library/
│       ├── data/
│       │   └── library_data.dart       # Sample data
│       ├── domain/
│       │   └── library_item.dart       # Data model
│       ├── presentation/
│       │   ├── library_page.dart
│       │   └── widgets/
│       │       └── library_card.dart
│       └── services/
│           └── tts_service.dart        # Text-to-speech (Riverpod)
├── routing/
│   ├── app_router.dart         # GoRouter configuration
│   ├── app_router.g.dart       # Generated
│   └── routes.dart             # Route path constants
├── theme/
│   ├── app_colors.dart         # Centralized color definitions
│   ├── app_text_styles.dart    # Centralized text styles
│   └── app_theme.dart          # Theme configuration
├── utils/
│   └── responsive.dart         # Responsive layout utilities
└── widgets/
    ├── app_shell.dart          # Shared desktop/mobile layout
    └── sidebar.dart            # Data-driven sidebar with navigation
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
- Use the `responsive.dart` utilities to handle screen sizes.
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

### 6. Sidebar Navigation
- Sidebar items are configured in `SidebarConfig.items` (data-driven).
- Active route is automatically highlighted.
- To add a new sidebar item:
  1. Add route constant to `Routes` class
  2. Add `GoRoute` in `app_router.dart`
  3. Add `SidebarItemData` to `SidebarConfig.items`

### 7. Testing Strategy
- **Widget Tests**: Run `flutter test` to verify UI components, responsiveness, and accessibility.
- **Golden Tests**: Run `flutter test --update-goldens` to generate/update reference images.
- **Integration Tests**: Run `flutter test integration_test/app_test.dart` on a real device/emulator.
- **Regression Policy**: **ALWAYS** run `flutter test` after completing a task to ensure no regressions were introduced.
- Test files location: `test/` directory with `*_test.dart` naming.

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
7. Write tests in `test/<feature>_test.dart`

## Assets
- **Images**: `assets/images/library/` - Library content images
- **Fonts**: 
  - `fonts/KumarOne-Regular.ttf` - Headers
  - `fonts/InstrumentSans-Bold.ttf` - Captions
