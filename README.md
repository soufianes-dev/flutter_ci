# flutterci

## Fastlane setup

```bash

# Upload native-debug-symbols.zip to play store after creating a release
cd build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/ &&
zip -r native-debug-symbols.zip arm64-v8a armeabi-v7a x86_64


sudo apt install rubygems
sudo apt install ruby-bundler
sudo apt install -y ruby ruby-dev build-essential
sudo gem install fastlane -NV
# sudo gem cleanup
# brew install fastlane

cd android && ./gradlew signingReport
sudo npm install -g firebase-tools
firebase logout
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
flutter pub add firebase_core
keytool -genkey -v -keystore ~upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload


# https://console.cloud.google.com/apis/library/androidpublisher.googleapis.com?hl=en&inv=1&invt=Abrhmw&project=flutter-app1-d3af8
fastlane run validate_play_store_json_key json_key:/home/soufiane/dev/projects/playground/dev_ops/flutter_ci/flutter-ci-432e4-b2e456c83eaa.json
(cd android && fastlane init)
cd android && bundle exec fastlane add_plugin firebase_app_distribution

(cd ios && fastlane init)
cd ios && bundle exec fastlane add_plugin firebase_app_distribution

bundle update


# In CI
firebase logout
firebase login:ci # and make use of FIREBASE_CLI_TOKEN
fastlane # Or `/usr/local/bin/fastlane`

# Android
# cd android && bundle exec fastlane <name of the lane>
cd android && fastlane distribute # distribute | internal | alpha | beta | promote_to_production | production |
# cd android && bundle exec fastlane run firebase_app_distribution
cd android && bundle exec fastlane run deploy

# iOS
cd ios && fastlane <name of the lane>
```

## CI/CD

- [Flutter Fastlane](https://docs.flutter.dev/deployment/cd#fastlane)
- [Fastlane](https://docs.fastlane.tools/)
- [flutter-ci-cd-using-github-actions](https://blog.logrocket.com/flutter-ci-cd-using-github-actions/)
- [Android command line tools](https://chat.openai.com/c/07e27afe-c623-4bb9-adb7-079f4ee01abb)
- [Android publisher](https://developers.google.com/android-publisher)
- [Internal testing](https://play.google.com/console/about/internal-testing/)
- [Internal testing](https://play.google.com/console/u/0/developers/8193017614701971889/app/4974900067408495220/releases/internal-app-sharing)
- [internal app sharing](https://docs.fastlane.tools/actions/upload_to_play_store_internal_app_sharing/)
- [fastlane](https://devjorgecastro.medium.com/how-to-deploy-your-android-app-to-the-internal-track-in-the-play-store-console-using-fastlane-4f66efdabc12)
- <https://stackoverflow.com/questions/69857830/users-are-not-able-to-download-app-via-firebase-app-distribution-flutter>
- <https://firebase.google.com/docs/app-distribution>
- <https://docs.flutter.dev/deployment/ios#create-an-app-bundle>
-
- IMPORTANT <https://chat.openai.com/share/17a4cb6d-4ef2-4791-8a32-547ebf51675e>
