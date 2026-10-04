# Museum Gateway

A Flutter proof of concept for **Museum Gateway: A Self-Service Visitor Experience Platform**, a capstone project with The Wolfsonian-FIU.

One Dart codebase targets **iPhone, iPad, and Android phones/tablets**. The app is an early working-flow prototype, not a finished museum system.

## Included

- Welcome screen with adaptive phone and tablet navigation.
- Demo admission for 1–8 guests, free and paid example categories, approved/declined payment simulation.
- Unique UUID ticket and scannable QR payload, local ticket restoration, and explicit session reset.
- Exhibition browsing by category, detail pages, and sample programs.
- Illustrative three-level map and a sample thematic pathway.
- Visitor help and accessibility information; device text scaling and screen-reader labels.
- Unit/widget tests and GitHub Actions for analysis, tests, Android debug APK, and iOS simulator build.

**All exhibition listings, programs, prices, and floor plans are fictional examples.** QR tickets are visibly marked demo-only and are not valid for museum entry. No payment details or personal visitor records are collected. Payment simulation is local; a real provider's test-mode integration is not implemented yet.

## Run on your Mac

1. Install Flutter stable (this scaffold uses **3.47.6**) following the [official installation guide](https://docs.flutter.dev/install).
2. Keep Xcode installed for iOS. Install Android Studio and its Android SDK for Android. Use `flutter doctor -v` to check required tool versions and licenses.
3. Open this folder in VS Code or Android Studio. Open a terminal in this folder and run:

```sh
flutter doctor -v
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter devices
flutter run
```

Choose an iPhone/iPad simulator or Android emulator from the displayed devices. To target a specific device, use `flutter run -d DEVICE_ID` with an ID returned by `flutter devices`.

If using the SDK downloaded beside this project in the original Codex workspace, its executable is at `../../work/flutter/bin/flutter` relative to this folder. It is intentionally outside the Git repository. Install Flutter normally for ongoing development; it is not added to your shell PATH automatically.

## Open the iOS project in Xcode

First run the Flutter setup above, then:

```sh
flutter build ios --simulator --debug
open ios/Runner.xcworkspace
```

Use the **Runner workspace**, select the **Runner** scheme and an iPhone/iPad simulator, then click Run. A physical iPhone/iPad needs your Apple development team configured in Signing & Capabilities. Edit the shared interface in `lib/`, then use Flutter hot reload or rebuild; the Swift files only host Flutter.

The initial scaffold has iOS 15 as its minimum OS. Flutter may require a newer Xcode than the installed Xcode 16.4; follow `flutter doctor` before attempting a native build.

## Android

```sh
flutter run -d DEVICE_ID
flutter build apk --debug
```

The debug APK is generated at `build/app/outputs/flutter-apk/app-debug.apk`. This is a demonstration build, not a signed store release. The Android scaffold uses Flutter's current Gradle/SDK defaults; Java 17 and Android SDK/NDK components are needed. No Android SDK was installed by this task.

## GitHub: private repository `capstone2`

Source repository: [nafisanusha/capstone2](https://github.com/nafisanusha/capstone2) (private).

For ongoing Git development, clone the published repository into a new folder using GitHub Desktop or authenticated Git:

```sh
git clone https://github.com/nafisanusha/capstone2.git
cd capstone2
```

The original local scaffold was uploaded through the GitHub integration, so its local Git history differs from the published repository. Use a fresh clone for future pushes.

GitHub Actions runs analysis, tests, and native builds after each push. Download the Android demo APK from the workflow artifacts when the Android job succeeds. GitHub hosts the source and build artifacts; App Store/Play Store publishing is a separate later step.

## Verification status

[Passing workflow run](https://github.com/nafisanusha/capstone2/actions/runs/37220637563) for app commit `e1ccebb` (October 4, 2026).

- GitHub Actions: Flutter analysis passed and all **12 unit/widget tests passed**, including phone/tablet navigation with 1.6× text scaling.
- iOS simulator debug compilation succeeded in GitHub Actions.
- Android debug APK compilation succeeded; the demo APK is available in workflow artifacts.
- Dart syntax and native XML/plist/JSON assets checked locally.
- Flutter native project files derived from the official Flutter 3.47.6 templates.
- Manual simulator/device execution, visual review, screen-reader testing, and real kiosk trials remain pending. Local Flutter execution in Codex was blocked by a sandbox system-call restriction; the analysis/tests/build evidence comes from GitHub Actions.

## Project organization

- `lib/main.dart`: app shell, welcome screen, visitor information.
- `lib/screens/`: admission/ticket, catalog/detail, map/pathway flows.
- `lib/data/catalog.dart`: sample museum content to replace after approval.
- `lib/data/admission.dart`: local demo ticket lifecycle.
- `lib/theme.dart`, `lib/widgets.dart`: theme, shared components, original geometric illustrations.
- `test/`: ticket and visitor-flow coverage.
- `docs/REQUIREMENTS.md`: traceability, acceptance criteria, and remaining project work.

No museum photographs or collection assets are included. The geometric artwork and app icon were created in code for this prototype.
