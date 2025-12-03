# Verbident CareQuest - AI Context & Agent Guide

## Project Overview
Verbident CareQuest is a Flutter application for dental/healthcare management, targeting **iOS and Android** across **mobile phones and tablets**. It focuses on responsive design to support different screen sizes seamlessly.


## Deployment & Release

### Version Numbering (Semantic Versioning)

The app uses **semantic versioning** with build numbers:

```
major.minor.patch+build
  │     │     │    └── Build: Increments every store upload
  │     │     └─────── Patch: Bug fixes, small improvements
  │     └───────────── Minor: New features (backwards compatible)
  └─────────────────── Major: Breaking changes, major redesign
```

#### When to Bump Each Component

| Component | When to Bump | Command | Example |
|-----------|--------------|---------|---------|
| **BUILD** | Every upload to same version | `fastlane bump` | `0.2.0+1 → 0.2.0+2` |
| **PATCH** | Bug fixes, text changes, small improvements | `fastlane bump_patch` | `0.2.0 → 0.2.1` |
| **MINOR** | New features, significant improvements | `fastlane bump_minor` | `0.2.0 → 0.3.0` |
| **MAJOR** | Breaking changes, major redesign, v1.0.0 | `fastlane bump_major` | `0.3.0 → 1.0.0` |

#### Important Rules

1. **After TestFlight/App Store approval**: You MUST bump at least PATCH for new submissions
2. **Build number**: Must be unique per version on each store
3. **Version bumps reset build**: `bump_patch`, `bump_minor`, `bump_major` all reset build to 1

### Fastlane Commands Reference

```bash
# VERSION MANAGEMENT
fastlane version       # Show current version breakdown
fastlane bump          # Increment build number only
fastlane bump_patch    # Bump patch, reset build to 1
fastlane bump_minor    # Bump minor, reset patch & build
fastlane bump_major    # Bump major, reset all

# DEPLOYMENT
fastlane ios beta      # Build and upload to TestFlight
fastlane android beta  # Build and upload to Play Store Internal
```

### Fastlane Configuration

```
fastlane/
├── Appfile              # App identifiers (com.verbident)
├── Fastfile             # Build lanes and version management
├── .gitignore           # Protects API keys
├── AuthKey_*.p8         # iOS App Store Connect API key (gitignored)
└── play-store-key.json  # Android Google Play API key (gitignored)
```

### Release Workflow

#### Standard Bug Fix Release
```bash
flutter test                    # Verify tests pass
fastlane bump_patch             # 0.2.0+1 → 0.2.1+1
fastlane ios beta               # Upload to TestFlight
fastlane android beta           # Upload to Play Store
git add pubspec.yaml && git commit -m "chore: release v0.2.1"
```

#### New Feature Release
```bash
flutter test
fastlane bump_minor             # 0.2.1+1 → 0.3.0+1
fastlane ios beta
fastlane android beta
git add pubspec.yaml && git commit -m "chore: release v0.3.0"
```

#### Quick Fix (Same Version, New Build)
```bash
flutter test
fastlane bump                   # 0.3.0+1 → 0.3.0+2
fastlane ios beta
fastlane android beta
git add pubspec.yaml && git commit -m "chore: build 2"
```

### API Key Setup (One-time)

#### iOS (App Store Connect)
1. [App Store Connect](https://appstoreconnect.apple.com) → Users and Access → Keys
2. Generate API Key with "App Manager" role
3. Save `.p8` file as `fastlane/AuthKey_<KeyID>.p8`
4. Note the Key ID and Issuer ID (configured in Fastfile)

#### Android (Google Play)
1. [Google Play Console](https://play.google.com/console) → Settings → API access
2. Create Service Account with JSON key
3. Save as `fastlane/play-store-key.json`
4. Grant service account access to app

### Store URLs

- **TestFlight/App Store**: https://appstoreconnect.apple.com
- **Google Play Console**: https://play.google.com/console
- **Bundle ID**: `com.verbident`
