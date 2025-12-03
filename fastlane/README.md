fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### version

```sh
[bundle exec] fastlane version
```

Show current version

### bump

```sh
[bundle exec] fastlane bump
```

Bump build number only (same version, new upload)

### bump_patch

```sh
[bundle exec] fastlane bump_patch
```

Bump PATCH version (bug fixes) - resets build to 1

### bump_minor

```sh
[bundle exec] fastlane bump_minor
```

Bump MINOR version (new features) - resets patch and build

### bump_major

```sh
[bundle exec] fastlane bump_major
```

Bump MAJOR version (breaking changes) - resets all

----


## Android

### android beta

```sh
[bundle exec] fastlane android beta
```

Build and upload to Play Store Internal Testing

### android metadata

```sh
[bundle exec] fastlane android metadata
```

Upload Play Store metadata only (no binary)

### android screenshots

```sh
[bundle exec] fastlane android screenshots
```

Capture Android screenshots

### android release

```sh
[bundle exec] fastlane android release
```

Full release with metadata

----


## iOS

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload to TestFlight

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

Upload App Store metadata only (no binary)

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Capture iOS screenshots

### ios release

```sh
[bundle exec] fastlane ios release
```

Full release with metadata

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
