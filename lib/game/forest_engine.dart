import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'questions.dart';
import 'strings.dart';

const forestInk = Color(0xFF0D211D);
const leaf = Color(0xFFB8D991);
const ivory = Color(0xFFF1F2DA);
const amber = Color(0xFFE9B872);
const mint = Color(0xFF7BD5B2);
const danger = Color(0xFFE9947D);
Offset unit(Offset p) => p.distance < .001 ? Offset.zero : p / p.distance;
Offset project(Offset p) => Offset((p.dx - p.dy) * .78, (p.dx + p.dy) * .42);
Offset unproject(Offset p) =>
    Offset(p.dx / 1.56 + p.dy / .84, p.dy / .84 - p.dx / 1.56);

enum EncounterPhase { exploring, approaching, question, feedback, departing }

enum AnswerOutcome { correct, incorrect, timeout }

class Scenery {
  final Offset pos;
  final int kind;
  final double size, variant;
  const Scenery(this.pos, this.kind, this.size, this.variant);
}

class JournalEntry {
  final String questionId;
  final AnswerOutcome outcome;
  final int delta;
  const JournalEntry(this.questionId, this.outcome, this.delta);
  Map<String, dynamic> toJson() => {
    'id': questionId,
    'outcome': outcome.name,
    'delta': delta,
  };
}

/// No combat: encounters are scored decisions. The real-time quiz deadline is
/// independent of render frames, pause menus, and app backgrounding.
class ForestEngine extends ChangeNotifier {
  static const questionSeconds = 15;
  static const correctReward = 20;
  static const mistakePenalty = 10;
  static const start = Offset(660, 1400);
  static const worldSize = 2200.0;
  final DateTime Function() now;
  final math.Random random;
  ForestEngine({DateTime Function()? clock, int? seed})
    : now = clock ?? DateTime.now,
      random = math.Random(seed) {
    generate();
  }

  String language = 'en', ageGroup = 'young', difficulty = 'low';
  bool largeText = false, awaitingRoute = false, journeyComplete = false;
  int zoneIndex = 0, checkpointIndex = 0, routeChoice = 0;
  double totalDistance = 0;
  String text(String key) => tr(key, language);
  int get completedDecisions => zoneIndex * 2 + checkpointIndex;
  List<Offset> get routePoints =>
      routeChoice == 0
          ? [landmarks[1], landmarks[2], landmarks[3]]
          : [landmarks[4], landmarks[5], landmarks[3]];
  Offset get destination => routePoints[checkpointIndex.clamp(0, 2)];
  List<int> get eligibleQuestions => [
    for (int i = 0; i < questions.length; i++)
      if (questions[i].difficulty == difficulty &&
          (questions[i].audience == 'all' || questions[i].audience == ageGroup))
        i,
  ];
  void selectProfile(String age, String level) {
    if (activeQuestion || phase == EncounterPhase.approaching) {
      return;
    }
    if (!['child', 'young', 'adult', 'older'].contains(age) ||
        !['low', 'medium', 'high'].contains(level)) {
      return;
    }
    if (ageGroup == age && difficulty == level) {
      return;
    }
    ageGroup = age;
    difficulty = level;
    deck = [];
    deckCursor = 0;
    lastQuestion = -1;
    restartWalk();
    started = false;
    save();
  }

  void chooseRoute(int choice) {
    if (!awaitingRoute || journeyComplete || zoneIndex >= 5) {
      return;
    }
    routeChoice = choice.clamp(0, 1);
    zoneIndex++;
    checkpointIndex = 0;
    awaitingRoute = false;
    paused = false;
    player = start;
    camera = start;
    input = Offset.zero;
    travel = 0;
    exploreSeconds = 0;
    generate();
    save();
    notifyListeners();
  }

  void setLanguage(String code) {
    if (!['en', 'hi', 'mr'].contains(code)) {
      return;
    }
    language = code;
    save();
    notifyListeners();
  }

  Offset player = start,
      camera = start,
      input = Offset.zero,
      facing = const Offset(0, -1);
  Offset tiger = start + const Offset(180, -160),
      tigerFacing = const Offset(-1, 0);
  Offset approachFrom = Offset.zero;
  EncounterPhase phase = EncounterPhase.exploring;
  bool started = false, paused = false, backgrounded = false;
  bool sound = true, haptics = true, lightweight = false;
  int xp = 0,
      correct = 0,
      incorrect = 0,
      timeouts = 0,
      encounters = 0,
      streak = 0,
      bestStreak = 0;
  double time = 0,
      phaseTime = 0,
      tigerAngle = -math.pi / 2,
      orbitAngleOnAnswer = 0;
  double travel = 0,
      travelTarget = 170,
      exploreSeconds = 0,
      saveClock = 0,
      cameraFraction = .5;
  double toastTime = 0;
  String toast = '';
  int? questionIndex, selectedDisplayIndex;
  DateTime? deadline;
  List<int> choiceOrder = [];
  List<int> deck = [];
  int deckCursor = 0, lastQuestion = -1;
  AnswerOutcome? outcome;
  final List<JournalEntry> journal = [];
  final List<Scenery> scenery = [];
  final List<Rect> ponds = const [
    Rect.fromLTWH(930, 900, 300, 240),
    Rect.fromLTWH(470, 490, 260, 230),
    Rect.fromLTWH(1580, 1520, 300, 220),
  ];
  final List<Offset> landmarks = const [
    Offset(660, 1400),
    Offset(430, 1000),
    Offset(900, 600),
    Offset(1460, 690),
    Offset(1700, 1280),
    Offset(1210, 1770),
  ];
  VoidCallback? onSave, onHaptic;
  void Function(String)? onSound;
  ForestQuestion? get currentQuestion =>
      questionIndex == null ? null : questions[questionIndex!];
  bool get hasTiger => phase != EncounterPhase.exploring;
  bool get activeQuestion => phase == EncounterPhase.question;
  bool get canMove =>
      started &&
      !paused &&
      !backgrounded &&
      !awaitingRoute &&
      !journeyComplete &&
      phase == EncounterPhase.exploring;
  int get answered => correct + incorrect + timeouts;
  int get rank => math.max(0, xp) ~/ 100 + 1;
  double get rankProgress => (math.max(0, xp) % 100) / 100;
  String get rankName =>
      rank < 2
          ? 'Trail beginner'
          : rank < 4
          ? 'Forest observer'
          : rank < 7
          ? 'Wildlife learner'
          : 'Forest guardian';
  double get remaining =>
      deadline == null
          ? questionSeconds.toDouble()
          : (deadline!.difference(now()).inMicroseconds / 1000000).clamp(
            0,
            questionSeconds.toDouble(),
          );
  int get secondsShown => remaining.ceil();
  int get xpDelta =>
      outcome == AnswerOutcome.correct ? correctReward : -mistakePenalty;
  int get correctDisplayIndex =>
      choiceOrder.indexOf(currentQuestion?.correctIndex ?? 0);

  void generate() {
    scenery.clear();
    final r = math.Random(320 + zoneIndex * 97);
    for (int i = 0; i < 650; i++) {
      final p = Offset(60 + r.nextDouble() * 2080, 60 + r.nextDouble() * 2080);
      if (ponds.any((b) => b.inflate(50).contains(p)) ||
          (p - start).distance < 100) {
        continue;
      }
      var nearTrail = false;
      for (int j = 0; j < landmarks.length; j++) {
        final a = landmarks[j], b = landmarks[(j + 1) % landmarks.length];
        final segment = b - a;
        final t = (((p - a).dx * segment.dx + (p - a).dy * segment.dy) /
                segment.distanceSquared)
            .clamp(0.0, 1.0);
        if ((p - (a + segment * t)).distance < 100) {
          nearTrail = true;
          break;
        }
      }
      final k =
          nearTrail
              ? 2
              : (i % 5 == 0
                  ? 1
                  : i % 4 == 0
                  ? 2
                  : i % 7 == 0
                  ? 3
                  : 0);
      scenery.add(
        Scenery(
          p,
          k,
          k == 0 ? 45 + r.nextDouble() * 45 : 15 + r.nextDouble() * 30,
          r.nextDouble(),
        ),
      );
    }
  }

  void begin() {
    started = true;
    paused = false;
    input = Offset.zero;
    syncDeadline();
    notifyListeners();
  }

  void pause() {
    if (phase == EncounterPhase.question ||
        phase == EncounterPhase.approaching) {
      announce(text('timerNote'));
      return;
    }
    paused = true;
    input = Offset.zero;
    save();
    notifyListeners();
  }

  void resume() {
    paused = false;
    input = Offset.zero;
    syncDeadline();
    notifyListeners();
  }

  void setBackground(bool value) {
    backgrounded = value;
    input = Offset.zero;
    syncDeadline();
    save();
    notifyListeners();
  }

  void announce(String s) {
    toast = s;
    toastTime = 3.5;
  }

  void save() => onSave?.call();
  void soundEvent(String s) {
    if (sound) {
      onSound?.call(s);
    }
  }

  void update(double dt) {
    syncDeadline();
    if (!started || paused || backgrounded) {
      return;
    }
    final motion = dt.clamp(0.0, .25);
    time += motion;
    phaseTime += motion;
    saveClock += motion;
    toastTime = math.max(0, toastTime - motion);
    final focus = hasTiger ? .29 : .5;
    cameraFraction += (focus - cameraFraction) * math.min(1, motion * 5);
    camera += (player - camera) * math.min(1, motion * 10);
    if (phase == EncounterPhase.exploring) {
      exploreSeconds += motion;
      if (input.distance > .12) {
        facing = unit(unproject(input));
        final before = player;
        final steps = math.max(1, (motion * 60).ceil());
        final step =
            facing *
            185 *
            motion *
            math.min(1, input.distance) /
            steps.toDouble();
        for (int i = 0; i < steps; i++) {
          move(step);
        }
        travel += (player - before).distance;
        totalDistance += (player - before).distance;
      }
      if (!awaitingRoute &&
          !journeyComplete &&
          (player - destination).distance < 85 &&
          exploreSeconds >= 1) {
        if (checkpointIndex < 2) {
          triggerEncounter();
        } else {
          awaitingRoute = true;
          paused = true;
          input = Offset.zero;
          if (zoneIndex == 5) {
            journeyComplete = true;
          }
          save();
        }
      }
    } else if (phase == EncounterPhase.approaching) {
      final t = (phaseTime / 1.15).clamp(0.0, 1.0);
      final target = player + const Offset(85, -85);
      tiger = Offset.lerp(approachFrom, target, t)!;
      tigerFacing = unit(target - approachFrom);
      if (t >= 1) {
        startQuestion();
      }
    } else if (phase == EncounterPhase.question) {
      tigerAngle += motion * 1.22;
      tiger = player + Offset(math.cos(tigerAngle), math.sin(tigerAngle)) * 122;
      tigerFacing = unit(Offset(-math.sin(tigerAngle), math.cos(tigerAngle)));
    } else if (phase == EncounterPhase.departing) {
      tiger += tigerFacing * 190 * motion;
      if (phaseTime > 1.4) {
        phase = EncounterPhase.exploring;
        phaseTime = 0;
        exploreSeconds = 0;
        travel = 0;
        travelTarget = 240 + random.nextDouble() * 160;
        deadline = null;
        questionIndex = null;
        outcome = null;
        selectedDisplayIndex = null;
        save();
      }
    }
    if (saveClock >= 5) {
      saveClock = 0;
      save();
    }
    notifyListeners();
  }

  bool blocked(Offset p) =>
      p.dx < 55 ||
      p.dy < 55 ||
      p.dx > 2145 ||
      p.dy > 2145 ||
      ponds.any((b) => b.inflate(18).contains(p));
  void move(Offset delta) {
    final x = player + Offset(delta.dx, 0);
    if (!blocked(x)) {
      player = x;
    }
    final y = player + Offset(0, delta.dy);
    if (!blocked(y)) {
      player = y;
    }
  }

  void refillDeck() {
    deck = eligibleQuestions..shuffle(random);
    // Each new curriculum cycle opens with a profile-specific scenario.
    final tailored = deck.indexWhere(
      (i) => questions[i].audience == ageGroup && i != lastQuestion,
    );
    if (tailored > 0) {
      final item = deck.removeAt(tailored);
      deck.insert(0, item);
    }
    if (deck.first == lastQuestion && deck.length > 1) {
      final t = deck[0];
      deck[0] = deck[1];
      deck[1] = t;
    }
    deckCursor = 0;
  }

  void triggerEncounter() {
    if (!started ||
        paused ||
        awaitingRoute ||
        journeyComplete ||
        checkpointIndex >= 2 ||
        phase != EncounterPhase.exploring) {
      return;
    }
    input = Offset.zero;
    if (deckCursor >= deck.length) {
      refillDeck();
    }
    questionIndex = deck[deckCursor++];
    lastQuestion = questionIndex!;
    choiceOrder = List.generate(currentQuestion!.options.length, (i) => i)
      ..shuffle(random);
    selectedDisplayIndex = null;
    outcome = null;
    deadline = null;
    approachFrom = player + const Offset(330, -290);
    tiger = approachFrom;
    phase = EncounterPhase.approaching;
    phaseTime = 0;
    encounters++;
    soundEvent('encounter');
    save();
    notifyListeners();
  }

  void startQuestion() {
    if (phase != EncounterPhase.approaching) {
      return;
    }
    phase = EncounterPhase.question;
    phaseTime = 0;
    tigerAngle = -math.pi / 4;
    tiger = player + Offset(math.cos(tigerAngle), math.sin(tigerAngle)) * 122;
    deadline = now().add(const Duration(seconds: questionSeconds));
    save();
    notifyListeners();
  }

  void syncDeadline() {
    if (phase == EncounterPhase.question &&
        deadline != null &&
        !now().isBefore(deadline!)) {
      finish(AnswerOutcome.timeout);
    }
  }

  void answer(int displayIndex) {
    syncDeadline();
    if (phase != EncounterPhase.question ||
        displayIndex < 0 ||
        displayIndex >= choiceOrder.length) {
      return;
    }
    selectedDisplayIndex = displayIndex;
    finish(
      choiceOrder[displayIndex] == currentQuestion!.correctIndex
          ? AnswerOutcome.correct
          : AnswerOutcome.incorrect,
    );
  }

  void finish(AnswerOutcome result) {
    if (phase != EncounterPhase.question) {
      return;
    }
    outcome = result;
    checkpointIndex = math.min(2, checkpointIndex + 1);
    phase = EncounterPhase.feedback;
    phaseTime = 0;
    input = Offset.zero;
    orbitAngleOnAnswer = tigerAngle;
    if (result == AnswerOutcome.correct) {
      correct++;
      xp += correctReward;
      streak++;
      bestStreak = math.max(bestStreak, streak);
      soundEvent('correct');
    } else {
      xp -= mistakePenalty;
      streak = 0;
      if (result == AnswerOutcome.timeout) {
        timeouts++;
      } else {
        incorrect++;
      }
      soundEvent('incorrect');
    }
    journal.insert(0, JournalEntry(currentQuestion!.id, result, xpDelta));
    if (journal.length > 50) {
      journal.removeLast();
    }
    if (haptics) {
      onHaptic?.call();
    }
    save();
    notifyListeners();
  }

  void continueTrail() {
    if (phase != EncounterPhase.feedback) {
      return;
    }
    phase = EncounterPhase.departing;
    phaseTime = 0;
    paused = false;
    tigerFacing = unit(tiger - player);
    input = Offset.zero;
    save();
    notifyListeners();
  }

  void restartWalk() {
    // A fresh walk keeps earned XP and the unused question deck.
    if (activeQuestion) {
      return;
    }
    zoneIndex = 0;
    checkpointIndex = 0;
    routeChoice = 0;
    awaitingRoute = false;
    journeyComplete = false;
    totalDistance = 0;
    generate();
    player = start;
    camera = start;
    phase = EncounterPhase.exploring;
    phaseTime = 0;
    travel = 0;
    travelTarget = 170;
    exploreSeconds = 0;
    questionIndex = null;
    deadline = null;
    outcome = null;
    started = true;
    paused = false;
    input = Offset.zero;
    cameraFraction = .5;
    save();
    notifyListeners();
  }

  Map<String, dynamic> snapshot() => {
    'version': 2,
    'language': language,
    'ageGroup': ageGroup,
    'difficulty': difficulty,
    'largeText': largeText,
    'zone': zoneIndex,
    'checkpoint': checkpointIndex,
    'route': routeChoice,
    'awaitingRoute': awaitingRoute,
    'complete': journeyComplete,
    'distance': totalDistance,
    'xp': xp,
    'correct': correct,
    'incorrect': incorrect,
    'timeouts': timeouts,
    'encounters': encounters,
    'streak': streak,
    'bestStreak': bestStreak,
    'player': [player.dx, player.dy],
    'tiger': [tiger.dx, tiger.dy],
    'tigerAngle': tigerAngle,
    'phase': phase.name,
    'questionIndex': questionIndex,
    'choiceOrder': choiceOrder,
    'deadline': deadline?.millisecondsSinceEpoch,
    'outcome': outcome?.name,
    'selected': selectedDisplayIndex,
    'deck': deck,
    'cursor': deckCursor,
    'last': lastQuestion,
    'sound': sound,
    'haptics': haptics,
    'lightweight': lightweight,
    'journal': journal.map((e) => e.toJson()).toList(),
  };
  void restore(Map<String, dynamic> data) {
    if (data['version'] != 1 && data['version'] != 2) {
      return;
    }
    xp = (data['xp'] as int).clamp(-9999999, 9999999);
    correct = data['correct'] as int;
    incorrect = data['incorrect'] as int;
    timeouts = data['timeouts'] as int;
    encounters = data['encounters'] as int;
    streak = data['streak'] as int;
    bestStreak = data['bestStreak'] as int;
    if (data['version'] == 1) {
      // Keep old earned stats; the new curriculum and route begin fresh.
      sound = data['sound'] as bool? ?? true;
      haptics = data['haptics'] as bool? ?? true;
      return;
    }
    language = data['language'] as String? ?? 'en';
    ageGroup = data['ageGroup'] as String? ?? 'young';
    difficulty = data['difficulty'] as String? ?? 'low';
    if (!['en', 'hi', 'mr'].contains(language) ||
        !['child', 'young', 'adult', 'older'].contains(ageGroup) ||
        !['low', 'medium', 'high'].contains(difficulty)) {
      throw const FormatException('Invalid profile');
    }
    largeText = data['largeText'] as bool? ?? false;
    zoneIndex = (data['zone'] as int).clamp(0, 5);
    checkpointIndex = (data['checkpoint'] as int).clamp(0, 2);
    routeChoice = (data['route'] as int).clamp(0, 1);
    awaitingRoute = data['awaitingRoute'] as bool;
    journeyComplete = data['complete'] as bool;
    totalDistance = (data['distance'] as num).toDouble();
    generate();
    player = Offset(
      (data['player'][0] as num).toDouble(),
      (data['player'][1] as num).toDouble(),
    );
    if (blocked(player)) {
      player = start;
    }
    camera = player;
    tiger = Offset(
      (data['tiger'][0] as num).toDouble(),
      (data['tiger'][1] as num).toDouble(),
    );
    tigerAngle = (data['tigerAngle'] as num).toDouble();
    phase = EncounterPhase.values.byName(data['phase'] as String);
    questionIndex = data['questionIndex'] as int?;
    if (questionIndex != null &&
        (questionIndex! < 0 || questionIndex! >= questions.length)) {
      throw const FormatException('Question index out of range');
    }
    choiceOrder = (data['choiceOrder'] as List).cast<int>().toList();
    if (questionIndex != null &&
        (choiceOrder.length != 4 ||
            choiceOrder.toSet().length != 4 ||
            choiceOrder.any((i) => i < 0 || i > 3))) {
      throw const FormatException('Invalid answer order');
    }
    final stamp = data['deadline'] as int?;
    deadline =
        stamp == null ? null : DateTime.fromMillisecondsSinceEpoch(stamp);
    outcome =
        data['outcome'] == null
            ? null
            : AnswerOutcome.values.byName(data['outcome'] as String);
    selectedDisplayIndex = data['selected'] as int?;
    deck = (data['deck'] as List).cast<int>().toList();
    deckCursor = data['cursor'] as int;
    lastQuestion = data['last'] as int;
    if (deck.any(
          (i) =>
              i < 0 || i >= questions.length || !eligibleQuestions.contains(i),
        ) ||
        deck.toSet().length != deck.length ||
        deckCursor < 0 ||
        deckCursor > deck.length) {
      throw const FormatException('Invalid question deck');
    }
    sound = data['sound'] as bool;
    haptics = data['haptics'] as bool;
    lightweight = data['lightweight'] as bool;
    journal
      ..clear()
      ..addAll(
        (data['journal'] as List)
            .take(50)
            .map(
              (e) => JournalEntry(
                e['id'] as String,
                AnswerOutcome.values.byName(e['outcome'] as String),
                e['delta'] as int,
              ),
            ),
      );
    if ((phase == EncounterPhase.question ||
            phase == EncounterPhase.feedback) &&
        questionIndex == null) {
      throw const FormatException('Missing encounter');
    }
    if (phase == EncounterPhase.question && deadline == null) {
      throw const FormatException('Missing deadline');
    }
    if (phase == EncounterPhase.approaching) {
      approachFrom = tiger;
    }
    if (phase == EncounterPhase.departing) {
      phase = EncounterPhase.exploring;
      questionIndex = null;
      deadline = null;
    }
    cameraFraction = hasTiger ? .29 : .5;
    syncDeadline();
    if (awaitingRoute) {
      paused = true;
    }
  }
}
