# Wildwood Trail 2.0 — a mobile-first Flutter Android game

This update replaces the desktop-style opening screen with a **portrait Android game lobby**, touch-sized profile cards, a separate challenge selector, and bottom tabs. It remains a native Flutter/Dart game, **not a WebView wrapper**.

## New in this version

### 1. Four explorer profiles

**Child, Young, Adult, Older adult** appear as a two-by-two grid, from pale green to deep green. Dark cards use light text; selected cards have a check mark and border. These are question-style preferences, not a calculation of intelligence or ability from age. No birth date, exact age, or account is requested. The chosen profile is saved locally.

### 2. Three independent difficulty levels

- **Low:** recognise the safer action.
- **Medium:** compare risks and priorities.
- **High:** weigh evidence, uncertainty, peer pressure, and trade-offs.

All four profiles can choose all three difficulties. The bank contains **36 authored scenarios**: 24 shared wildlife scenarios (8 per difficulty) and 12 profile-specific scenarios (one per profile/difficulty combination). Each combination therefore draws from **9 eligible questions**, not all 36. A new curriculum cycle opens with a profile-specific scenario when it would not immediately repeat the last question. Remaining questions are shuffled without repetition until the eligible deck is exhausted, then reshuffled. Answer positions are shuffled independently.

The profile-specific content uses family/trusted-adult situations for children, peer/social-media choices for young players, planning/prioritisation for adults, and experience versus current evidence for older adults. Most wildlife principles are shared across ages. This is an authored starter curriculum, not a professionally calibrated age-assessment system.

Changing profile or difficulty after beginning a route asks for confirmation. It starts a fresh journey but retains earned XP and journal entries.

### 3. English, Hindi, and Marathi

Settings changes the language of **menus, tabs, questions, answer options, explanations, journey labels, and feedback**. Hindi and Marathi render with a bundled Noto Sans Devanagari font. Language choice is saved on Android and does not reset the journey. The platform's standard Material widgets also use Flutter localisation delegates.

Text is authored and bundled offline, not translated by a runtime API. Before public educational release, arrange a native-speaker and wildlife-professional editorial review.

### 4. A longer, navigable journey

The adventure now has **six chapters and twelve decision checkpoints**:

1. Emerald Grove
2. Bamboo Bend
3. River Watch
4. Fern Valley
5. Canopy Ridge
6. Ranger Haven

Encounters are tied to **geographic destinations**, not repeated random timers near the starting point. Follow the glowing gold marker, direction arrow, and minimap. Solve two encounters and physically reach the camp to finish a chapter.

At each intermediate camp, select:
- **Ranger path:** a more direct checkpoint itinerary.
- **Canopy loop:** a longer itinerary via the far clearing.

These choices change the actual waypoint positions and walking distance. Both are authorised routes within the fictional game; this is not an invitation to try risky shortcuts in real reserves. All twelve decisions must be resolved and all six camps reached to finish. A wrong answer costs XP but does not permanently block progression.

The chapters reuse the same base forest geography with different scenery seeds. They are sequential areas linked by camps, not six entirely separate handcrafted biomes or one infinite open world. A twelve-decision journey may begin a second question cycle after its nine eligible scenarios are used.

### 5. Native-app presentation

- Portrait-first Android orientation; no landscape landing page.
- Bottom navigation: **Home, Journey, Journal, Settings**.
- A fixed play/continue button and scrollable home content for small phones.
- Portrait gameplay with the tiger visible above a lower question panel.
- Adaptive landscape/tablet fallback.
- Larger-text setting, clear selection indicators, touch joystick, map, and Observe action.

The original unarmed explorer and circling tiger remain. No weapons or combat controls have been reintroduced.

## Rules retained

- **15 real-time seconds** per question.
- **+20 XP** correct; **−10 XP** wrong or timed out. XP can fall below zero.
- Tiger circles while the question is active and stops when the result resolves.
- Player movement is locked during the decision and explanation.
- Repeated taps cannot score an answer twice.
- The deadline continues while the app is backgrounded. An overdue saved encounter resolves as a timeout. A still-active encounter resumes directly rather than hiding its timer behind the lobby.

This is a fictional learning game, not certified survival training. Real tiger encounters vary; walking may be prohibited in real tiger safari areas. Follow authorised guides and local forest officials. See `docs/WILDLIFE_SOURCES.md`.

## Run in VS Code

Extract the archive and open **wildwood_trail**, the folder containing `pubspec.yaml`.

Baseline toolchain:
- Flutter **3.29.3**, Dart **3.7.2**
- JDK **17**
- Android SDK platform **35**, Build Tools **35.0.0**
- Android NDK **26.3.11579264**
- Gradle **8.10.2**, Android Gradle Plugin **8.7.0**

Install the VS Code Flutter/Dart extensions and Android Studio's SDK tools. Connect a phone with USB debugging or start an Android emulator, then run:

```sh
flutter doctor
flutter doctor --android-licenses
flutter pub get
flutter devices
flutter run
```

Select the Android device, not Chrome or Windows. To test game performance on a physical phone:

```sh
flutter run --release
```

## Build an APK

```sh
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`.

Smaller device-specific APKs:

```sh
flutter build apk --release --split-per-abi --target-platform android-arm64,android-arm
```

Helper scripts are in `scripts/`. Machine-specific `android/local.properties`, SDKs, private signing keys, caches, and generated build output are excluded from the ZIP. Flutter regenerates local configuration.

**This delivery is source code, not a compiled APK.** APK assembly and physical-device validation have not been completed for v2. The automated tests and browser preview build are verified. Current release builds use a development/debug signing key; configure your own private release signing before distribution. Update the SDK/toolchain as required by your publishing channel and test native compatibility, lifecycle, audio, haptics, performance, and accessibility on real devices.

## Save compatibility

Application ID remains `com.wildwoodtrail.wildwood_trail`; app version is **2.0.0+2**. Android saves now use schema version 2 and store language, chosen profile/difficulty, accessibility setting, chapter/checkpoint, route choice, question deck/order/deadline, XP, stats, and journal.

Version-1 saves retain earned XP, answer statistics, and basic audio/haptic settings. The new route begins at chapter 1; old question indices and journal entries are not imported into the rewritten multilingual curriculum. Updating an installed APK requires the same signing key. Uninstalling or clearing app data deletes progress. There is no cloud sync; Android cloud backup is disabled.

## Optional browser preview

The hosted preview displays the same Flutter UI in a phone-width layout. It is only a test/demo surface; the downloadable source remains Android-only. Native SoundPool audio, haptics, and persistent Android saves are disabled in the browser demo. Reloading the demo resets that temporary session.

## Code map

```text
lib/main.dart                     Portrait lobby, tabs, game HUD, question panels, settings
lib/game/forest_engine.dart        Navigation, chapters, branching routes, scoring, save schema
lib/game/forest_painter.dart       Green world, unarmed explorer, tiger, destination markers
lib/game/strings.dart              English/Hindi/Marathi interface strings
lib/game/questions.dart            Generated, bundled multilingual question bank
scripts/question_data.py           Editable authored question source and Dart generator
android/app/src/main/kotlin/...    Native SharedPreferences and SoundPool bridge
assets/fonts/                     Inter, Cinzel, Noto Devanagari, and OFL notices
assets/audio/                     Generated local sound cues
 test/                            Engine and responsive/multilingual UI tests
```

To edit or add questions, change `scripts/question_data.py`, then run:

```sh
python scripts/question_data.py
dart format lib/game/questions.dart
flutter test
```

Each scenario has a unique ID, audience (`all`, `child`, `young`, `adult`, `older`), difficulty, and three language rows. A row contains prompt, four options, and explanation. The first authored option is the correct one; the engine shuffles it for display. Do not reorder stable IDs casually in a shipped save schema: current saves use question indices and deck positions. Increment/migrate the schema when restructuring the bank.

## Validation

```sh
flutter analyze
flutter test
```

**41 tests pass:** 33 engine/content tests and 8 UI tests. They cover all 12 profile/difficulty combinations, multilingual content, no repeats within the eligible deck, deadline boundaries, scoring exactly once, movement/collisions, tiger orbit, route lengths, twelve-decision progression, save migration, language changes, larger text, phone portrait and landscape fallback layouts. All 36 question layouts are exercised in all three languages on a compact portrait viewport.

`docs/screenshots/` contains Flutter-rendered test screenshots. Golden images may vary with host/font/toolchain; intentionally update them with `flutter test --update-goldens` after reviewing changes. Browser smoke checks also confirm the mobile lobby, Marathi settings, and Marathi gameplay render with no JavaScript page errors.

Cached ground textures, viewport culling, bounded movement substeps, and a separate 15 Hz HUD reduce rendering work. These are performance design choices, **not measured FPS/input-latency guarantees**. The timer uses a saved wall-clock deadline; changing the system clock is not prevented in this offline game.

## Privacy and assets

No accounts, advertising, tracking, or network gameplay services. Exact age and birth date are not requested; the selected explorer category is a locally saved preference. Fonts use the SIL Open Font License, with notices bundled. Flutter Material icons retain upstream licenses. World and character art are procedural Dart geometry; sound cues were synthesized for this project.
