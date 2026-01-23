# Adding Images to Verbadent

This guide explains how to add new images to the Verbadent app using our automated workflow.

## Overview

Images in Verbadent are managed through a metadata-driven system:
- **Source of truth**: `assets/dental_items.yaml` (metadata file)
- **Generated code**: `lib/src/common/data/dental_items.dart` (auto-generated)
- **Image files**: `assets/images/library/` (WebP format)

This approach ensures consistency, reduces manual errors, and makes it easy to add new content.

## Quick Start

To add a new image to the app, follow these 3 steps:

### 1. Add the Image File

Place your image in the `assets/images/library/` directory:

```bash
# Image must be in WebP format for optimal mobile performance
cp your_image.webp assets/images/library/
```

**Image Requirements:**
- Format: `.webp` (recommended for mobile apps)
- Naming: Use `snake_case` (e.g., `dental_chair.webp`, `x_ray_machine.webp`)
- Size: Optimize for mobile (recommended < 200 KB per image)

**Converting to WebP:**
```bash
# Using cwebp tool (install via: apt-get install webp)
cwebp -q 80 input.png -o output.webp

# Using ImageMagick
convert input.png -quality 80 output.webp

# Using online tools
# https://squoosh.app (recommended for best quality/size balance)
```

### 2. Add Metadata Entry

Edit `assets/dental_items.yaml` and add your new item to the `dental_items` list:

```yaml
dental_items:
  # ... existing items ...

  - id: your-item-id              # Unique kebab-case ID
    image: your_image.webp        # Filename (must match actual file)
    caption: Your caption text    # Description shown in the app
```

**Example:**
```yaml
  - id: x-ray-machine
    image: x_ray_machine.webp
    caption: This is an x-ray machine
```

**Optional: Add to Feature Lists**

If you want the image to appear in specific app features, add its ID to the relevant lists:

```yaml
# For the "Before Visit" story sequence
before_visit_story:
  - dentist-chair
  - your-item-id    # Add here

# For the "Before Visit" tools grid
before_visit_tools:
  - dental-mirror
  - your-item-id    # Or add here
```

### 3. Generate Code

Run the generation script to update the Dart code:

```bash
# Standalone generation
./scripts/generate_dental_items.sh

# Or run the full build (includes generation)
./scripts/build.sh
```

That's it! Your new image is now available in the app.

## File Structure

```
Verbadent/
├── assets/
│   ├── dental_items.yaml          # ← Edit this to add images
│   └── images/
│       └── library/
│           ├── dentist_chair.webp # ← Add image files here
│           └── your_image.webp
├── lib/src/common/data/
│   └── dental_items.dart          # ← Auto-generated (don't edit)
├── tool/
│   └── generate_dental_items.dart # Code generator
└── scripts/
    ├── generate_dental_items.sh   # Quick generation script
    └── build.sh                   # Full build (includes generation)
```

## Metadata Format Reference

### Complete YAML Structure

```yaml
# All dental items in the app
dental_items:
  - id: unique-item-id          # Required: kebab-case unique identifier
    image: filename.webp        # Required: WebP image filename
    caption: Item description   # Required: Caption text (can include quotes)

# Items shown in the Before Visit story sequence (horizontal flow with arrows)
before_visit_story:
  - item-id-1
  - item-id-2

# Items shown in the Before Visit tools grid
before_visit_tools:
  - item-id-3
  - item-id-4
```

### Naming Conventions

| Field | Convention | Examples |
|-------|-----------|----------|
| `id` | kebab-case | `dentist-chair`, `x-ray-machine`, `bright-light` |
| `image` | snake_case.webp | `dentist_chair.webp`, `x_ray_machine.webp` |
| `caption` | Natural text | `This is the dentist's chair`, `Open your mouth` |

### Caption Formatting

Captions can include:
- Simple text: `This is a mirror`
- Apostrophes: `This is the dentist's drill` (automatically escaped)
- Special characters: Any UTF-8 text is supported

## Common Tasks

### Adding a Single Image

```yaml
# 1. Add file: assets/images/library/toothbrush.webp

# 2. Edit assets/dental_items.yaml:
dental_items:
  # ... existing items ...
  - id: toothbrush
    image: toothbrush.webp
    caption: This is a toothbrush

# 3. Regenerate:
./scripts/generate_dental_items.sh
```

### Adding Multiple Images at Once

```yaml
# 1. Add all files to assets/images/library/

# 2. Edit assets/dental_items.yaml:
dental_items:
  # ... existing items ...
  - id: toothbrush
    image: toothbrush.webp
    caption: This is a toothbrush
  - id: toothpaste
    image: toothpaste.webp
    caption: This is toothpaste
  - id: floss
    image: floss.webp
    caption: This is dental floss

# 3. Regenerate once:
./scripts/generate_dental_items.sh
```

### Removing an Image

```yaml
# 1. Delete the image file from assets/images/library/

# 2. Remove the entry from assets/dental_items.yaml

# 3. Remove the ID from any feature lists (before_visit_story, before_visit_tools)

# 4. Regenerate:
./scripts/generate_dental_items.sh
```

### Updating Image Caption

```yaml
# 1. Edit assets/dental_items.yaml:
dental_items:
  - id: dental-mirror
    image: dental_mirror.webp
    caption: This is a special mirror    # ← Changed caption

# 2. Regenerate:
./scripts/generate_dental_items.sh
```

### Reordering Items

The order in the YAML file determines the order in the app:

```yaml
# Items appear in this order in the Library feature
dental_items:
  - id: first-item      # Shows first
  - id: second-item     # Shows second
  - id: third-item      # Shows third

# Story sequence order
before_visit_story:
  - third-item          # Shows first in story
  - first-item          # Shows second in story
```

## Build Integration

The generation script is automatically run during the build process:

```bash
./scripts/build.sh
```

This runs:
1. `dart run tool/generate_dental_items.dart` (generates dental_items.dart)
2. `dart run build_runner build` (generates other code)
3. `flutter gen-l10n` (generates localization)

## Troubleshooting

### Error: "assets/dental_items.yaml not found"

**Solution**: Make sure you're running the script from the project root directory.

```bash
cd /path/to/Verbadent
./scripts/generate_dental_items.sh
```

### Error: Image not showing in app

**Checklist**:
- [ ] Image file exists in `assets/images/library/`
- [ ] Image filename matches exactly in YAML (case-sensitive)
- [ ] YAML entry has correct `id`, `image`, and `caption` fields
- [ ] Generated code is up to date (re-run generation script)
- [ ] App was rebuilt after generating code (`flutter run`)

### Error: YAML parsing failed

**Common causes**:
- Incorrect indentation (use 2 spaces, not tabs)
- Missing colons after field names
- Unquoted strings with special characters

**Fix indentation**:
```yaml
# Bad (mixing spaces and tabs)
dental_items:
	- id: test    # Tab character

# Good (consistent 2-space indentation)
dental_items:
  - id: test      # 2 spaces
    image: test.webp
    caption: Test
```

### Need to Manually Edit Generated Code?

**Don't!** The generated file (`lib/src/common/data/dental_items.dart`) is overwritten every time you run the generator.

Instead:
1. Make changes in `assets/dental_items.yaml`
2. If you need different functionality, extend `DentalItems` class in a separate file
3. If the generator doesn't support your use case, modify `tool/generate_dental_items.dart`

## Advanced Usage

### Validating Images Before Adding

Check that your image is optimized:

```bash
# Check file size
ls -lh assets/images/library/your_image.webp

# Check dimensions
identify assets/images/library/your_image.webp

# Re-optimize if needed
cwebp -q 80 original.png -o assets/images/library/optimized.webp
```

### Batch Converting Images

Convert multiple images at once:

```bash
# Convert all PNGs in a directory
for img in source_images/*.png; do
  filename=$(basename "$img" .png)
  cwebp -q 80 "$img" -o "assets/images/library/${filename}.webp"
done
```

### Custom Generator Modifications

The generator is located at `tool/generate_dental_items.dart`. You can modify it to:
- Add validation logic
- Support additional metadata fields
- Change output formatting
- Add new generated methods

After modifying the generator, test it:
```bash
dart run tool/generate_dental_items.dart
```

## Best Practices

1. **Use WebP format** for all images (smaller file size, better quality)
2. **Optimize images** before adding (target < 200 KB per image)
3. **Use descriptive IDs** that match the image content
4. **Write clear captions** that help users understand the image
5. **Run generation** after every YAML change
6. **Test in the app** to verify images display correctly
7. **Commit YAML and images together** to keep them in sync

## See Also

- [Flutter Asset Management](https://docs.flutter.dev/development/ui/assets-and-images)
- [WebP Format Guide](https://developers.google.com/speed/webp)
- [Squoosh Image Optimizer](https://squoosh.app)

## Questions?

If you encounter issues not covered here, check:
1. `assets/dental_items.yaml` - ensure proper formatting
2. `tool/generate_dental_items.dart` - view the generator logic
3. `lib/src/common/data/dental_items.dart` - check generated output
