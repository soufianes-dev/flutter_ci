fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Runs all the tests

### android build_android_app

```sh
[bundle exec] fastlane android build_android_app
```

Build Android APK and AAB

### android distribute

```sh
[bundle exec] fastlane android distribute
```

Distribute app to firebase app distribution

### android internal

```sh
[bundle exec] fastlane android internal
```

Submit to Play Store Internal Track

### android alpha

```sh
[bundle exec] fastlane android alpha
```

Deploy to Play Store Alpha Track (Closed Testing)

### android beta

```sh
[bundle exec] fastlane android beta
```

Submit to Play Store Beta Track (Open Testing)

### android promote_to_production

```sh
[bundle exec] fastlane android promote_to_production
```

Promote Beta track to production

### android production

```sh
[bundle exec] fastlane android production
```

Deploy to production

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
