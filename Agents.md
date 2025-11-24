# Verbadent CareQuest - AI Context & Agent Guide

## Project Overview
Verbadent CareQuest is a Flutter application for dental/healthcare management, targeting iOS, Android, and Web. It focuses on responsive design to support phones, tablets, and desktop browsers seamlessly.

## Current Status
- **Phase**: Initial Setup & Prototyping
- **Focus**: Implementing the core Dashboard layout and navigation structure.
- **Active Tasks**: 
  - Setting up the responsive sidebar navigation.
  - Implementing the `DashboardPage` as the initial route.

## Tech Stack
- **Framework**: Flutter (SDK > 3.5.2)
- **Language**: Dart
- **State Management**: Flutter Riverpod (v2.6+) using `riverpod_annotation` and code generation.
- **Navigation**: GoRouter (v14+)
- **Localization**: `flutter_localizations` with `.arb` files.
- **Design**: Custom design system using "Kumar One" font.

## Architecture & Folder Structure
We follow a **Feature-First** architecture. Code is organized by business domain rather than technical layer.

### Directory Structure (`lib/src/`)
- **features/**: Contains self-contained modules (e.g., `dashboard/`, `home/`).
  - Each feature folder should contain its own `presentation/`, `domain/`, and `data/` layers.
- **routing/**: Application-wide routing configuration (`app_router.dart`).
- **theme/**: Design tokens, colors (`app_colors.dart`), and theme definitions (`app_theme.dart`).
- **utils/**: Shared utilities (e.g., `responsive.dart`).
- **localization/**: l10n configuration and generated files.

## Coding Standards & Patterns

### 1. State Management (Riverpod)
- **ALWAYS** use code generation (`@riverpod`) for providers. Do not use manual `Provider` or `StateProvider` definitions unless absolutely necessary.
- Prefer `AutoDispose` providers by default (default behavior of generator).
- Use `Ref` as the argument type in provider functions.

### 2. Navigation (GoRouter)
- Define routes in `lib/src/routing/app_router.dart`.
- Use named routes or type-safe routes if implemented.
- Centralize navigation logic in the router provider.

### 3. UI & Responsiveness
- Use the `responsive.dart` utilities to handle screen sizes.
- **Breakpoints**:
  - Mobile: < 600px
  - Tablet: 600px - 1200px
  - Desktop: ≥ 1200px
- **Fonts**: Use "Kumar One" for headers/branding as defined in `app_theme.dart`.
- **Colors**: Access colors via `AppColors` or `Theme.of(context)`.

### 4. UI Navigation Rules (Sidebar/Drawer)
- **Global Behavior**: The app features a sidebar navigation.
- **Collapsed State**: By default, on most routes, the sidebar is collapsed into a hamburger menu.
- **Expanded State**: The sidebar is ONLY expanded on the **Dashboard** route (the first route), and ONLY if there is sufficient screen real estate (Desktop/Large Tablet).
- **Fallback**: If screen real estate is insufficient on the Dashboard, the sidebar reverts to the collapsed hamburger menu state.

### 5. Localization
- Add new strings to `lib/src/localization/app_en.arb`.
- Access strings via `AppLocalizations.of(context)`.

### 6. Testing Strategy
- **Widget Tests**: Run `flutter test` to verify UI components, responsiveness, and accessibility.
- **Golden Tests**: Run `flutter test --update-goldens` to generate/update reference images.
- **Integration Tests**: Run `flutter test integration_test/app_test.dart` on a real device/emulator.
- **Regression Policy**: **ALWAYS** run `flutter test` after completing a task to ensure no regressions were introduced.

## Development Workflow

### Code Generation
Since we use `riverpod_generator` and `go_router_builder`, you must run the build runner to generate code.
- **One-time build**: `dart run build_runner build -d`
- **Watch mode**: `dart run build_runner watch -d`

### Running the App
- iOS: `flutter run -d ios`
- Android: `flutter run -d android`
- Web: `flutter run -d chrome`

