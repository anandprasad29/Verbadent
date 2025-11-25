# Library Route Implementation Plan

## Design Specifications (from Figma "Before Your Visit" Frame)

- **Header**: "Library" text using KumarOne font, 64px, color `#0A2D6D`, centered
- **Image Grid**: 5 columns (desktop), rounded squares (~120px, 25px border radius)
- **Image Container**: Blue border/background container (`#5483F5`) with rounded corners, image fills inside with rounded clipping
- **Caption Font**: Instrument Sans Bold, 16px, black (`#000000`), centered below image, ~118px width
- **Spacing**: ~23px gap between caption and next row
- **Background**: White (`#FFFFFF`)

### Sample Content (Dental-themed from Figma)
- Row 1: Dentist's chair, Dentist mask, Dentist gloves, Bright light, Counting teeth
- Row 2: Dental mirror, Dentist's drill, Suction tool, Open mouth, Stop sign

## Test-Driven Development Approach

Write UI tests first to verify expected behavior before implementation.

### Test Files to Create

**1. `test/library_page_test.dart`** - Tests for LibraryPage widget
- Verify "Library" header renders with correct styling (KumarOne, 64px, #0A2D6D)
- Verify grid displays correct number of columns per breakpoint (5/3/2)
- Verify LibraryCard items render in the grid
- Verify tapping a card triggers TTS with caption text
- Verify header collapses/minimizes on scroll

**2. `test/library_card_test.dart`** - Tests for LibraryCard widget
- Verify image renders with rounded corners (25px radius)
- Verify blue container border styling (#5483F5)
- Verify caption text styling (Instrument Sans Bold, 16px, black, centered)
- Verify tap callback is triggered with correct data

**3. `test/sidebar_test.dart`** - Tests for shared Sidebar navigation
- Verify Library button exists and navigates to /library route
- Verify all 4 sidebar items render correctly

## Architecture Overview

The Library feature follows the existing feature-based architecture:
- Route: `/library`
- Feature folder: `lib/src/features/library/`
- Shared sidebar component extracted for reuse

## Key Implementation Details

### 1. Add Instrument Sans Font
Add to `pubspec.yaml` and download font file to `fonts/` directory:

```yaml
fonts:
  - family: InstrumentSans
    fonts:
      - asset: fonts/InstrumentSans-Bold.ttf
        weight: 700
```

### 2. Shared Sidebar Component
Extract `Sidebar` and `SidebarItem` from `lib/dashboard_screen.dart` into `lib/src/widgets/sidebar.dart`. Add `go_router` navigation for the Library button.

### 3. Router Configuration
Update `lib/src/routing/app_router.dart`:

```dart
GoRoute(
  path: '/library',
  name: 'library',
  builder: (context, state) => const LibraryPage(),
),
```

### 4. Library Page Structure (`library_page.dart`)
- Use `CustomScrollView` with `SliverAppBar` for collapsing header
- `SliverAppBar.expandedHeight: 120`, `pinned: true`, `floating: false`
- `SliverPadding` + `SliverGrid` for responsive image grid
- Desktop: 5 cols, Tablet: 3 cols, Mobile: 2 cols

### 5. LibraryCard Widget (`library_card.dart`)
- Blue rounded container (`#5483F5`, 25px radius, 3px border)
- Image with `ClipRRect` for rounded corners
- Caption text below using Instrument Sans Bold, 16px, centered
- `GestureDetector` for tap-to-speak

### 6. Text-to-Speech Integration
Add `flutter_tts: ^4.0.2` to dependencies. Create `TtsService` class with `speak(String text)` method.

### 7. Asset Configuration
```yaml
assets:
  - assets/images/library/
```

**Image directory**: `assets/images/library/` - placeholder images until actual assets provided

## Files to Create

### Test Files (Write First)
1. `test/library_page_test.dart` - LibraryPage widget tests
2. `test/library_card_test.dart` - LibraryCard widget tests
3. `test/sidebar_test.dart` - Shared sidebar navigation tests

### Implementation Files
1. `lib/src/widgets/sidebar.dart` - Shared sidebar with navigation
2. `lib/src/features/library/presentation/library_page.dart` - Main page with SliverAppBar
3. `lib/src/features/library/presentation/widgets/library_card.dart` - Grid card widget
4. `lib/src/features/library/domain/library_item.dart` - Data model
5. `lib/src/features/library/data/library_data.dart` - Sample dental data
6. `lib/src/features/library/services/tts_service.dart` - TTS wrapper
7. `assets/images/library/` - Image assets directory
8. `fonts/InstrumentSans-Bold.ttf` - Caption font file

## Files to Modify
1. `lib/src/routing/app_router.dart` - Add `/library` route
2. `lib/dashboard_screen.dart` - Use shared sidebar, add navigation
3. `pubspec.yaml` - Add flutter_tts, assets, and InstrumentSans font

## Responsive Grid Configuration
| Device  | Columns | Image Size | Grid Spacing |
|---------|---------|------------|--------------|
| Mobile  | 2       | 140px      | 16px         |
| Tablet  | 3       | 130px      | 20px         |
| Desktop | 5       | 120px      | 24px         |


