# Verbident CareQuest

Flutter application for Verbident CareQuest deployed on **iOS and Android** across **mobile phones and tablets**.


## Deployment

The app uses **Fastlane** for automated deployments to TestFlight and Google Play.

### Prerequisites

- [Fastlane](https://fastlane.tools/) installed (`brew install fastlane`)
- API keys configured in `fastlane/` folder (gitignored for security)

### Version Format

```
major.minor.patch+build
  │     │     │    └── Build number (increments every upload)
  │     │     └─────── Patch (bug fixes, small changes)
  │     └───────────── Minor (new features)
  └─────────────────── Major (breaking changes)

Example: 1.2.3+45
```

### When to Bump What

| Component | When to Bump | Example |
|-----------|--------------|---------|
| **MAJOR** | Breaking changes, major redesign | `0.2.0 → 1.0.0` |
| **MINOR** | New features, significant improvements | `0.2.0 → 0.3.0` |
| **PATCH** | Bug fixes, small improvements | `0.2.0 → 0.2.1` |
| **BUILD** | Every TestFlight/Play Store upload | `0.2.0+1 → 0.2.0+2` |

> ⚠️ **Important**: Once a version is approved on TestFlight/App Store, you MUST bump at least the PATCH version for new submissions.

### Version Commands

```bash
# Show current version
fastlane version

# Bump build number only (for multiple uploads of same version)
fastlane bump              # 0.2.0+1 → 0.2.0+2

# Bump patch (bug fixes) - resets build to 1
fastlane bump_patch        # 0.2.0+2 → 0.2.1+1

# Bump minor (new features) - resets patch and build
fastlane bump_minor        # 0.2.1+1 → 0.3.0+1

# Bump major (breaking changes) - resets all
fastlane bump_major        # 0.3.0+1 → 1.0.0+1
```

### Deploy Commands

```bash
# Deploy to iOS TestFlight
fastlane ios beta

# Deploy to Android Play Store Internal Testing
fastlane android beta
```

### Typical Release Workflow

```bash
# 1. Make your code changes
# 2. Run tests
flutter test

# 3. Bump version appropriately
fastlane bump_patch   # or bump_minor, bump_major, or just bump

# 4. Deploy
fastlane ios beta
fastlane android beta

# 5. Commit the version change
git add pubspec.yaml
git commit -m "chore: release v0.2.1"
```

### Store Links

- **App Store Connect**: [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- **Google Play Console**: [play.google.com/console](https://play.google.com/console)
