# Wildwood Trail 2.0 — validation

Toolchain: Flutter 3.29.3 / Dart 3.7.2.

- `flutter analyze`: no issues found.
- `flutter test --update-goldens`: 41 tests passed (33 engine/content, 8 UI).
- Tested all 12 profile/difficulty filters (9 eligible questions each).
- Tested 36 question layouts in English, Hindi and Marathi with larger text at 360 × 640.
- Tested 390 × 844 portrait and 844 × 390 landscape fallback.
- Tests verify exact timer boundary, late-answer rejection, one-time scoring, circling/stopping, background deadlines, save roundtrips and v1 migration.
- Six chapters, twelve decisions, actual route-distance differences, camp unlocking and completion are exercised.
- Flutter release web preview compiles with local rendering resources.
- Headless Chromium smoke check: HTTP 200, Flutter view mounted, no JavaScript page errors. Mobile lobby, Marathi settings and Marathi tiger question were visually inspected.

Screenshot baselines are Flutter test renders, not physical-phone captures. Browser preview does not exercise native Android audio, vibration or persistent storage. Android assembly and physical-device validation were not completed for this release. No measured FPS/latency claim is made. Content translations should receive a native-speaker editorial review before public educational use.
