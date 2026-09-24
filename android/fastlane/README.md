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

### android format

```sh
[bundle exec] fastlane android format
```

Check Dart formatting

### android analyze

```sh
[bundle exec] fastlane android analyze
```

Run Flutter analysis

### android unit_tests

```sh
[bundle exec] fastlane android unit_tests
```

Run unit tests

### android widget_tests

```sh
[bundle exec] fastlane android widget_tests
```

Run widget tests

### android integration_tests

```sh
[bundle exec] fastlane android integration_tests
```

Run integration tests

### android all_tests

```sh
[bundle exec] fastlane android all_tests
```

Run all tests

### android coverage

```sh
[bundle exec] fastlane android coverage
```

Generate test coverage

### android android_lint

```sh
[bundle exec] fastlane android android_lint
```

Run Android lint

### android test

```sh
[bundle exec] fastlane android test
```

Run complete quality verification

### android build_android_apk

```sh
[bundle exec] fastlane android build_android_apk
```

Build release APK

### android build_android_app

```sh
[bundle exec] fastlane android build_android_app
```

Build release AAB

### android build_all_android_artifacts

```sh
[bundle exec] fastlane android build_all_android_artifacts
```

Build APK and AAB

### android checksums

```sh
[bundle exec] fastlane android checksums
```

Generate release checksums

### android build_manifest

```sh
[bundle exec] fastlane android build_manifest
```

Generate build manifest for existing Android artifacts

### android validate_apk

```sh
[bundle exec] fastlane android validate_apk
```

Validate release APK

### android validate_aab

```sh
[bundle exec] fastlane android validate_aab
```

Validate release AAB

### android crashlytics_symbols

```sh
[bundle exec] fastlane android crashlytics_symbols
```

Upload Crashlytics symbols

### android validate_metadata

```sh
[bundle exec] fastlane android validate_metadata
```

Validate Google Play metadata

### android validate_screenshots

```sh
[bundle exec] fastlane android validate_screenshots
```

Validate Google Play screenshots

### android upload_metadata

```sh
[bundle exec] fastlane android upload_metadata
```

Upload metadata and screenshots

### android internal

```sh
[bundle exec] fastlane android internal
```

Publish existing AAB to Google Play Internal Testing

### android closed

```sh
[bundle exec] fastlane android closed
```

Publish existing AAB to Google Play Closed Testing

### android open

```sh
[bundle exec] fastlane android open
```

Publish existing AAB to Google Play Open Testing

### android production

```sh
[bundle exec] fastlane android production
```

Publish existing AAB to Google Play Production

### android firebase

```sh
[bundle exec] fastlane android firebase
```

Publish existing AAB through Firebase App Distribution

### android promote_internal_to_closed

```sh
[bundle exec] fastlane android promote_internal_to_closed
```

Promote Internal to Closed

### android promote_closed_to_open

```sh
[bundle exec] fastlane android promote_closed_to_open
```

Promote Closed to Open

### android promote_open_to_production

```sh
[bundle exec] fastlane android promote_open_to_production
```

Promote Open to Production

### android promote_closed_to_production

```sh
[bundle exec] fastlane android promote_closed_to_production
```

Promote Closed to Production

### android doctor

```sh
[bundle exec] fastlane android doctor
```

Show environment diagnostics

### android services

```sh
[bundle exec] fastlane android services
```

Validate release services

### android service_account

```sh
[bundle exec] fastlane android service_account
```

Validate service account

### android disk_space

```sh
[bundle exec] fastlane android disk_space
```

Validate disk space

### android validate_release_environment

```sh
[bundle exec] fastlane android validate_release_environment
```

Run complete release environment validation

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
