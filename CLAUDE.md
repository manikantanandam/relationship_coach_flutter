# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- Install dependencies: `flutter pub get`
- Run app (device/emulator/web): `flutter run`
- Static analysis (uses `flutter_lints`): `flutter analyze`
- Run all tests: `flutter test`
- Run a single test file: `flutter test test/path_to_test.dart`
- Build: `flutter build apk` / `flutter build ios` / `flutter build web`
- Regenerate launcher icons after changing `lib/assets/icon/app_icon.png`: `flutter pub run flutter_launcher_icons`
- Firebase config (`lib/firebase_options.dart`, platform google-services files) is managed via FlutterFire CLI per `firebase.json`; don't hand-edit `firebase_options.dart`.

There is currently no `test/` directory — the project has no automated tests yet.

## Architecture

This is a relationship-coaching content app. Content is organized along three axes that recur throughout the codebase: **`ChatType`** (`lib/enum/chat_type.dart` — e.g. `hisFault`, `herFault`, `toxicChat`, `sweetTalk`), **`Gender`** (`lib/enum/gender.dart`), and **`ChatOptionType`** (`lib/enum/chat_option.dart` — `realLifeExamples`, `steps`, `conversationStarters`, `coachingTips`, `doItYourself`). A content screen is always reached as a `(ChatType, Gender, ChatOptionType)` triple; `ChatOptionTypeExtension.chatDetailsScreen()` is the dispatch point that maps that triple to its screen widget.

### Content loading: Firestore-first with bundled-JSON fallback
`FirestoreChatService` (`lib/services/firestore_chat_service.dart`) fetches each content type from Firestore at the path `"${chatType.name}/${gender.name}/<subcollection>"`. Several methods (e.g. `getCoachingTips`) catch Firestore failures and fall back to bundled JSON in `lib/resources/<chat_type_key>.json` via `JSONUtils.loadJsonData`, keyed by `gender.name`. When adding a new content type, mirror both the Firestore path convention and the local JSON fallback structure.

`FirestoreService<T extends BaseFirestoreModel>` (`lib/services/firestore_service.dart`) is a generic typed CRUD wrapper around a single Firestore collection using `withConverter`; models implement `BaseFirestoreModel` (`lib/model/base_fire_store_model.dart`) with `toJson()`/`fromJson`. The `screens/add_*.dart` screens (`add_diy_screen.dart`, `add_steps_screen.dart`, etc.) and `master_data.dart` are an in-app admin/authoring UI for writing this content directly into Firestore using the same `(ChatType, Gender)` path scheme — not end-user-facing screens.

### State management
Two app-wide `ChangeNotifierProvider`s are wired in `main.dart`: `IAPProvider` (`lib/providers/iap_provider.dart`) for subscription/purchase state, and `UserSettingsProvider` (`lib/providers/user_settings_provider.dart`) for the user's selected `Gender`, persisted via `shared_preferences`. `UserSettingsProvider.gender` drives which `ChatType` list (`maleHomeScreenOptions` / `femaleHomeScreenOption`) is shown on the home screen.

### Feature flags
`LocalFeatureFlagManager` (`lib/services/local_feature_flag_manager.dart`) is a singleton, `shared_preferences`-backed flag store (not a provider). Flags are declared as `FeatureKey` enum entries in `lib/enum/feature_flag_key.dart`, each carrying its storage key, default value, and (for enum-valued flags) the full `.values` list used to restore the enum from its stored string name. `FeatureKey.chatProvider` currently toggles between `firebase`/`local` chat service implementations. Must be initialized with `LocalFeatureFlagManager().init()` before use (done in `main()`).

### Startup sequence (`lib/main.dart`)
`Firebase.initializeApp` → Crashlytics error hooks wired → background FCM handler registered → `LocalFeatureFlagManager().init()` → Insert Affiliate SDK (`insertAffiliateSdk`, a top-level late global) initialized with an affiliate-identifier-change callback that persists the identifier to `shared_preferences` → deep link listener (`app_links`) set up to route links through the affiliate SDK. Push notification setup and `IAPProvider.initialize()` are deliberately deferred to `addPostFrameCallback` in `_MainAppState.initState`, not `main()`, to avoid an iOS crash from requesting permissions before the first frame renders.

### In-app purchases
`IAPProvider` wraps `in_app_purchase` (+ `in_app_purchase_android` for Android-specific past-purchase queries and purchase tokens). Product IDs live in `lib/constants.dart/iap_constants.dart`. Purchases integrate with the Insert Affiliate SDK: Android passes the Google Play purchase token to `insertAffiliateSdk.storeExpectedStoreTransaction`, iOS passes an affiliate-generated `appAccountToken` as the purchase's `applicationUserName`.

### Navigation shell
`MainApp` has no named routes — it's a single `DefaultTabController` with two tabs (`HomeScreen`, `SettingsScreen`) in a bottom `TabBar`. Deeper navigation happens via direct `Navigator.push` to screen widgets, not a router.

## Notes

- Several files use Dart's shorthand enum-member access (`.hisFault` instead of `ChatType.hisFault`) in switch cases and literals — this requires a recent Dart SDK (`environment: sdk: ^3.10.3` in `pubspec.yaml`).
- `lib/screens/terms_and_conditions..dart` has a double dot in its filename — this is intentional/pre-existing, not a typo to fix incidentally.
