import 'package:flutter_test/flutter_test.dart';
import 'package:wildwood_trail/game/forest_engine.dart';
import 'package:wildwood_trail/game/questions.dart';
import 'package:wildwood_trail/game/strings.dart';

void main() {
  late ForestEngine g;
  late DateTime now;
  setUp(() {
    now = DateTime.utc(2026, 10, 16, 12);
    g = ForestEngine(seed: 71, clock: () => now);
  });
  tearDown(() => g.dispose());
  void encounter() {
    g.begin();
    g.triggerEncounter();
    g.startQuestion();
  }

  void tick(double seconds) {
    now = now.add(Duration(microseconds: (seconds * 1000000).round()));
    g.update(seconds);
  }

  test('Projection round trips', () {
    final p = const Offset(670, 1430);
    expect((unproject(project(p)) - p).distance, lessThan(.00001));
  });
  test('All 36 scenarios and all UI keys contain three languages', () {
    expect(questions.length, 36);
    expect(questions.map((q) => q.id).toSet().length, 36);
    for (final q in questions) {
      expect(q.options.length, 4);
      for (final lang in ['en', 'hi', 'mr']) {
        expect(q.prompt.inLanguage(lang), isNotEmpty);
        expect(q.explanation.inLanguage(lang), isNotEmpty);
        expect(q.options.map((o) => o.inLanguage(lang)).toSet().length, 4);
      }
    }
    for (final e in uiText.values) {
      expect(e.en, isNotEmpty);
      expect(e.hi, isNotEmpty);
      expect(e.mr, isNotEmpty);
    }
  });
  for (final age in ['child', 'young', 'adult', 'older']) {
    for (final level in ['low', 'medium', 'high']) {
      test(
        '$age / $level has 9 correctly filtered scenarios and tailored opener',
        () {
          g.selectProfile(age, level);
          expect(g.eligibleQuestions.length, 9);
          encounter();
          expect(g.currentQuestion!.audience, age);
          expect(g.currentQuestion!.difficulty, level);
          final seen = <String>{};
          for (int i = 0; i < 9; i++) {
            if (i > 0) {
              g.phase = EncounterPhase.exploring;
              g.checkpointIndex = 0;
              g.triggerEncounter();
              g.startQuestion();
            }
            expect(g.currentQuestion!.difficulty, level);
            expect(['all', age], contains(g.currentQuestion!.audience));
            expect(seen.add(g.currentQuestion!.id), isTrue);
            g.answer(g.correctDisplayIndex);
          }
          final last = g.lastQuestion;
          g.phase = EncounterPhase.exploring;
          g.checkpointIndex = 0;
          g.triggerEncounter();
          expect(g.questionIndex, isNot(last));
        },
      );
    }
  }
  test('Correct and incorrect answers score once', () {
    encounter();
    final answer = g.correctDisplayIndex;
    g.answer(answer);
    g.answer(answer);
    expect(g.xp, 20);
    expect(g.checkpointIndex, 1);
    expect(g.journal.length, 1);
  });
  test('Wrong answer subtracts 10 below zero', () {
    encounter();
    g.answer((g.correctDisplayIndex + 1) % 4);
    expect(g.xp, -10);
    expect(g.incorrect, 1);
  });
  test('Question has exactly 15 seconds and rejects late correct tap', () {
    encounter();
    tick(14.999);
    expect(g.activeQuestion, isTrue);
    now = now.add(const Duration(milliseconds: 1));
    g.answer(g.correctDisplayIndex);
    expect(g.outcome, AnswerOutcome.timeout);
    expect(g.xp, -10);
  });
  test('Background and render stalls do not extend timer', () {
    encounter();
    g.setBackground(true);
    tick(30);
    g.setBackground(false);
    expect(g.timeouts, 1);
    expect(g.xp, -10);
  });
  test('Pause and settings cannot bypass an active question', () {
    encounter();
    g.pause();
    g.selectProfile('adult', 'high');
    expect(g.paused, isFalse);
    expect(g.ageGroup, 'young');
    tick(15);
    expect(g.timeouts, 1);
  });
  test('Tiger orbits then stops on result', () {
    encounter();
    final before = g.tiger;
    g.update(.2);
    expect(g.tiger, isNot(before));
    expect((g.tiger - g.player).distance, closeTo(122, .001));
    g.answer(g.correctDisplayIndex);
    final stop = g.tiger;
    g.update(.2);
    expect(g.tiger, stop);
  });
  test('Player cannot move while deciding or reading result', () {
    encounter();
    final pos = g.player;
    g.input = const Offset(1, 0);
    g.update(.1);
    expect(g.player, pos);
    g.answer(g.correctDisplayIndex);
    g.update(.1);
    expect(g.player, pos);
  });
  test(
    'Walking without reaching a destination does not spawn random questions',
    () {
      g.begin();
      g.travel = 900;
      g.exploreSeconds = 30;
      g.update(.1);
      expect(g.phase, EncounterPhase.exploring);
      g.player = g.destination;
      g.update(.1);
      expect(g.phase, EncounterPhase.approaching);
    },
  );
  test('First answer changes the next geographic destination', () {
    final first = g.destination;
    encounter();
    g.answer(g.correctDisplayIndex);
    expect(g.destination, isNot(first));
  });
  test('Two decisions require reaching camp before next chapter', () {
    g.begin();
    g.checkpointIndex = 2;
    g.exploreSeconds = 10;
    g.update(.1);
    expect(g.awaitingRoute, isFalse);
    g.player = g.destination;
    g.update(.1);
    expect(g.awaitingRoute, isTrue);
    expect(g.paused, isTrue);
    g.chooseRoute(1);
    expect(g.zoneIndex, 1);
    expect(g.routeChoice, 1);
    expect(g.checkpointIndex, 0);
  });
  test('Canopy loop is genuinely longer than direct route', () {
    double length(int route) {
      g.routeChoice = route;
      var last = ForestEngine.start;
      double sum = 0;
      for (final p in g.routePoints) {
        sum += (p - last).distance;
        last = p;
      }
      return sum;
    }

    expect(length(1), greaterThan(length(0) * 1.4));
  });
  test('Six chapters and twelve decisions reach completion', () {
    g.begin();
    for (int z = 0; z < 6; z++) {
      expect(g.zoneIndex, z);
      for (int n = 0; n < 2; n++) {
        g.player = g.destination;
        g.exploreSeconds = 10;
        g.update(.05);
        g.startQuestion();
        g.answer(g.correctDisplayIndex);
        g.continueTrail();
        for (int i = 0; i < 7; i++) {
          g.update(.25);
        }
      }
      g.player = g.destination;
      g.exploreSeconds = 10;
      g.update(.1);
      expect(g.awaitingRoute, isTrue);
      if (z < 5) {
        g.chooseRoute(z % 2);
      }
    }
    expect(g.journeyComplete, isTrue);
    expect(g.completedDecisions, 12);
    expect(g.xp, 240);
  });
  test('Profile changes reset route but retain XP and journal', () {
    encounter();
    g.answer(g.correctDisplayIndex);
    g.selectProfile('older', 'high');
    expect(g.xp, 20);
    expect(g.journal.length, 1);
    expect(g.completedDecisions, 0);
    expect(g.deck, isEmpty);
    expect(g.started, isFalse);
  });
  test('Language switch preserves profile, XP and active deadline', () {
    encounter();
    final deadline = g.deadline;
    g.setLanguage('mr');
    expect(g.deadline, deadline);
    expect(g.phase, EncounterPhase.question);
    expect(g.text('home'), 'मुख्यपृष्ठ');
  });
  test('Save roundtrip preserves all settings and pending encounter', () {
    g.selectProfile('child', 'medium');
    g.setLanguage('hi');
    g.largeText = true;
    encounter();
    tick(3);
    final restored = ForestEngine(clock: () => now)..restore(g.snapshot());
    expect(restored.snapshot(), g.snapshot());
    expect(restored.remaining, 12);
    restored.dispose();
  });
  test('Overdue restored encounter scores once and advances checkpoint', () {
    encounter();
    final saved = g.snapshot();
    now = now.add(const Duration(seconds: 30));
    final restored = ForestEngine(clock: () => now)..restore(saved);
    expect(restored.xp, -10);
    expect(restored.checkpointIndex, 1);
    final again = ForestEngine(clock: () => now)..restore(restored.snapshot());
    expect(again.xp, -10);
    expect(again.checkpointIndex, 1);
    restored.dispose();
    again.dispose();
  });
  test('Checkpoint and chosen route survive a save', () {
    g.zoneIndex = 3;
    g.checkpointIndex = 2;
    g.routeChoice = 1;
    g.awaitingRoute = true;
    final restored = ForestEngine(clock: () => now)..restore(g.snapshot());
    expect(restored.zoneIndex, 3);
    expect(restored.routeChoice, 1);
    expect(restored.awaitingRoute, isTrue);
    restored.dispose();
  });
  test(
    'Version 1 saves migrate earned statistics without old question indices',
    () {
      final old =
          g.snapshot()
            ..['version'] = 1
            ..['xp'] = 85
            ..['correct'] = 5;
      final restored = ForestEngine()..restore(old);
      expect(restored.xp, 85);
      expect(restored.correct, 5);
      expect(restored.questionIndex, isNull);
      expect(restored.completedDecisions, 0);
      restored.dispose();
    },
  );
  test('Water and map edges are solid', () {
    g.player = const Offset(900, 1000);
    for (int i = 0; i < 20; i++) {
      g.move(const Offset(5, 0));
    }
    expect(g.player.dx, lessThan(913));
    g.player = const Offset(60, 60);
    g.move(const Offset(-20, -20));
    expect(g.player, const Offset(60, 60));
  });
}
