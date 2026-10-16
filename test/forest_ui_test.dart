import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wildwood_trail/main.dart';
import 'package:wildwood_trail/game/forest_engine.dart';
import 'package:wildwood_trail/game/questions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final font in ['Inter', 'Cinzel', 'NotoDevanagari']) {
      await (FontLoader(font)
        ..addFont(rootBundle.load('assets/fonts/$font.ttf'))).load();
    }
    await (FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  setUp(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(native, (call) async => null),
  );
  Future<void> setup(
    WidgetTester tester,
    ForestEngine g, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(WildwoodApp(engine: g));
    await tester.pump(const Duration(milliseconds: 120));
  }

  Future<void> cleanup(WidgetTester tester, ForestEngine g) async {
    await tester.pumpWidget(const SizedBox());
    g.dispose();
  }

  testWidgets(
    'Portrait lobby presents four profiles, challenge selector and tabs',
    (tester) async {
      final g = ForestEngine(seed: 71);
      await setup(tester, g);
      for (final key in ['child', 'young', 'adult', 'older']) {
        expect(find.byKey(Key('age-$key')), findsOneWidget);
      }
      expect(find.byType(NavigationBar), findsOneWidget);
      await expectLater(
        find.byType(ForestScreen),
        matchesGoldenFile('../docs/screenshots/mobile-home.png'),
      );
      await tester.tap(find.byKey(const Key('age-child')));
      await tester.pump();
      expect(g.ageGroup, 'child');
      await tester.ensureVisible(find.byKey(const Key('difficulty-high')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('difficulty-high')));
      await tester.pump();
      expect(g.difficulty, 'high');
      expect(tester.takeException(), isNull);
      await cleanup(tester, g);
    },
  );
  testWidgets('Settings switch all three UI languages and preserve selection', (
    tester,
  ) async {
    final g = ForestEngine();
    await setup(tester, g);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byKey(const Key('language-hi')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(g.language, 'hi');
    expect(find.text('ऐप की भाषा'), findsOneWidget);
    await tester.tap(find.byKey(const Key('language-mr')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(g.language, 'mr');
    expect(find.text('अॅपची भाषा'), findsOneWidget);
    await expectLater(
      find.byType(ForestScreen),
      matchesGoldenFile('../docs/screenshots/settings-marathi.png'),
    );
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pump(const Duration(milliseconds: 200));
    await expectLater(
      find.byType(ForestScreen),
      matchesGoldenFile('../docs/screenshots/home-marathi.png'),
    );
    expect(tester.takeException(), isNull);
    await cleanup(tester, g);
  });
  testWidgets('Portrait game shows localised question and awards XP', (
    tester,
  ) async {
    final g = ForestEngine(clock: () => DateTime.utc(2026), seed: 3);
    g.selectProfile('adult', 'high');
    g.setLanguage('hi');
    await setup(tester, g);
    await tester.tap(find.byKey(const Key('play')));
    await tester.pump();
    g.triggerEncounter();
    g.startQuestion();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(g.currentQuestion!.prompt.hi), findsOneWidget);
    await expectLater(
      find.byType(ForestScreen),
      matchesGoldenFile('../docs/screenshots/game-hindi.png'),
    );
    final option = find.byKey(Key('answer-${g.correctDisplayIndex}'));
    await tester.ensureVisible(option);
    await tester.pump();
    await tester.tap(option);
    await tester.pump(const Duration(milliseconds: 150));
    expect(g.xp, 20);
    expect(find.text('+20 अनुभव'), findsOneWidget);
    expect(g.checkpointIndex, 1);
    expect(tester.takeException(), isNull);
    await cleanup(tester, g);
  });
  testWidgets('Countdown resolves without input in portrait mode', (
    tester,
  ) async {
    var now = DateTime.utc(2026);
    final g = ForestEngine(clock: () => now);
    await setup(tester, g);
    await tester.tap(find.byKey(const Key('play')));
    await tester.pump();
    g.triggerEncounter();
    g.startQuestion();
    await tester.pump(const Duration(milliseconds: 100));
    now = now.add(const Duration(seconds: 15));
    await tester.pump(const Duration(milliseconds: 100));
    expect(g.xp, -10);
    expect(find.text('Time ran out.'), findsOneWidget);
    await cleanup(tester, g);
  });
  testWidgets('Journey tab displays six locked/current chapters', (
    tester,
  ) async {
    final g = ForestEngine();
    await setup(tester, g);
    await tester.tap(find.byIcon(Icons.route_outlined));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Your current trail'), findsOneWidget);
    await expectLater(
      find.byType(ForestScreen),
      matchesGoldenFile('../docs/screenshots/journey.png'),
    );
    expect(tester.takeException(), isNull);
    await cleanup(tester, g);
  });
  testWidgets('Route choice changes the destination and next chapter', (
    tester,
  ) async {
    final g = ForestEngine();
    g.checkpointIndex = 2;
    g.awaitingRoute = true;
    await setup(tester, g);
    await tester.tap(find.byKey(const Key('play')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('route-1')));
    await tester.pump(const Duration(milliseconds: 100));
    expect(g.zoneIndex, 1);
    expect(g.routeChoice, 1);
    expect(g.destination, g.landmarks[4]);
    await cleanup(tester, g);
  });
  testWidgets(
    'Compact portrait handles all 36 scenarios in three languages with larger text',
    (tester) async {
      final g = ForestEngine(clock: () => DateTime.utc(2026), seed: 5)
        ..largeText = true;
      await setup(tester, g, size: const Size(360, 640));
      await tester.tap(find.byKey(const Key('play')));
      await tester.pump();
      g.triggerEncounter();
      g.startQuestion();
      for (final language in ['en', 'hi', 'mr']) {
        g.language = language;
        await tester.pumpWidget(WildwoodApp(engine: g));
        for (int i = 0; i < questions.length; i++) {
          g.questionIndex = i;
          await tester.pump(const Duration(milliseconds: 80));
          expect(
            tester.takeException(),
            isNull,
            reason: '$language / question $i',
          );
        }
      }
      await cleanup(tester, g);
    },
  );
  testWidgets('Landscape fallback and movement joystick remain usable', (
    tester,
  ) async {
    final g = ForestEngine(clock: () => DateTime.utc(2026));
    await setup(tester, g, size: const Size(844, 390));
    await tester.tap(find.byKey(const Key('play')));
    await tester.pump();
    final center = tester.getCenter(find.byType(Joystick));
    final pointer = await tester.startGesture(center);
    await pointer.moveBy(const Offset(25, 0));
    await tester.pump();
    expect(g.input.dx, greaterThan(0));
    await pointer.up();
    expect(g.input, Offset.zero);
    g.triggerEncounter();
    g.startQuestion();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    await cleanup(tester, g);
  });
}
