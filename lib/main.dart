import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'game/forest_engine.dart';
import 'game/forest_painter.dart';
import 'game/questions.dart';

const native = MethodChannel('wildwood/native');
const browserPreview = bool.fromEnvironment('BROWSER_PREVIEW');
const appGreen = Color(0xFF194F3C),
    paper = Color(0xFFF0F3E8),
    muted = Color(0xFF657767);
const ageColors = [
  Color(0xFFE2EFC8),
  Color(0xFFA9D48E),
  Color(0xFF31714F),
  Color(0xFF20533F),
];
const ages = ['child', 'young', 'adult', 'older'];
const difficulties = ['low', 'medium', 'high'];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!browserPreview) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  var g = ForestEngine();
  if (!browserPreview) {
    try {
      final s = await native.invokeMethod<String>('load');
      if (s != null) {
        g.restore(jsonDecode(s) as Map<String, dynamic>);
      }
    } catch (_) {
      g.dispose();
      g = ForestEngine();
    }
  }
  runApp(WildwoodApp(engine: g));
}

class WildwoodApp extends StatefulWidget {
  final ForestEngine? engine;
  const WildwoodApp({super.key, this.engine});
  @override
  State<WildwoodApp> createState() => _WildwoodAppState();
}

class _WildwoodAppState extends State<WildwoodApp> {
  late final ForestEngine g = widget.engine ?? ForestEngine();
  @override
  void dispose() {
    if (widget.engine == null) {
      g.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Wildwood Trail',
    debugShowCheckedModeBanner: false,
    locale: Locale(g.language),
    supportedLocales: const [Locale('en'), Locale('hi'), Locale('mr')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: g.language == 'en' ? 'Inter' : 'NotoDevanagari',
      fontFamilyFallback: const ['NotoDevanagari'],
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: appGreen,
        primary: appGreen,
        surface: paper,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFFF9FBF3),
        indicatorColor: Color(0xFFD8EAC8),
        height: 72,
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: appGreen)),
    ),
    home: ForestScreen(engine: g, onLocale: () => setState(() {})),
  );
}

class ForestScreen extends StatefulWidget {
  final ForestEngine engine;
  final VoidCallback? onLocale;
  const ForestScreen({super.key, required this.engine, this.onLocale});
  @override
  State<ForestScreen> createState() => _ForestScreenState();
}

class _ForestScreenState extends State<ForestScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  ForestEngine get g => widget.engine;
  final renderer = ForestRenderer(), heroRenderer = ForestRenderer();
  final hud = ValueNotifier<int>(0);
  late final Ticker ticker;
  Duration previous = Duration.zero;
  double uiClock = 0;
  int tab = 0;
  bool playing = false, saveWarned = false;
  String? panel;
  final Set<LogicalKeyboardKey> keys = {};
  String t(String key) => g.text(key);
  double get textScale => g.largeText ? 1.12 : 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    g.onSave = save;
    playing = g.activeQuestion || g.phase == EncounterPhase.approaching;
    if (playing) {
      g.begin();
    }
    if (!browserPreview) {
      g.onSound = (s) {
        native.invokeMethod<void>('sound', s).catchError((Object _) {});
      };
      g.onHaptic = () => HapticFeedback.selectionClick();
    }
    ticker = createTicker(tick)..start();
    save();
  }

  Future<void> save() async {
    if (browserPreview) {
      return;
    }
    try {
      await native.invokeMethod<void>('save', jsonEncode(g.snapshot()));
    } catch (_) {
      if (!saveWarned) {
        saveWarned = true;
        g.announce(t('saveError'));
      }
    }
  }

  void tick(Duration elapsed) {
    if (previous == Duration.zero) {
      previous = elapsed;
      return;
    }
    final dt = (elapsed - previous).inMicroseconds / 1000000;
    previous = elapsed;
    g.update(dt);
    uiClock += dt;
    if (uiClock > .066) {
      uiClock = 0;
      hud.value++;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    g.setBackground(s != AppLifecycleState.resumed);
    keys.clear();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ticker.dispose();
    renderer.dispose();
    heroRenderer.dispose();
    hud.dispose();
    g.onSave = null;
    g.onSound = null;
    g.onHaptic = null;
    super.dispose();
  }

  void start() {
    if (g.journeyComplete) {
      g.restartWalk();
    }
    g.begin();
    setState(() {
      playing = true;
      panel = null;
    });
  }

  void home() {
    if (g.activeQuestion || g.phase == EncounterPhase.approaching) {
      return;
    }
    g.pause();
    g.started = false;
    keys.clear();
    setState(() {
      playing = false;
      panel = null;
    });
  }

  void openPanel(String name) {
    if (g.activeQuestion || g.phase == EncounterPhase.approaching) {
      return;
    }
    g.pause();
    setState(() => panel = name);
  }

  void closePanel() {
    g.resume();
    setState(() => panel = null);
  }

  Future<void> profile(String age, String difficulty) async {
    if (g.ageGroup == age && g.difficulty == difficulty) {
      return;
    }
    if (g.activeQuestion || g.phase == EncounterPhase.approaching) {
      start();
      return;
    }
    if (g.completedDecisions > 0 || g.travel > 0) {
      final accepted = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(t('changeTitle')),
              content: Text(t('changeBody')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(t('cancel')),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(t('continue')),
                ),
              ],
            ),
      );
      if (accepted != true || !mounted) {
        return;
      }
    }
    g.selectProfile(age, difficulty);
    setState(() {});
  }

  KeyEventResult keyboard(FocusNode node, KeyEvent e) {
    if (e is KeyDownEvent) {
      keys.add(e.logicalKey);
    } else if (e is KeyUpEvent) {
      keys.remove(e.logicalKey);
    }
    if (!playing) {
      return KeyEventResult.ignored;
    }
    if (e is KeyDownEvent) {
      if (e.logicalKey == LogicalKeyboardKey.escape) {
        panel == null ? openPanel('pause') : closePanel();
      }
      const answers = [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.digit4,
      ];
      final i = answers.indexOf(e.logicalKey);
      if (i >= 0) {
        g.answer(i);
      }
      if (e.logicalKey == LogicalKeyboardKey.enter &&
          g.phase == EncounterPhase.feedback) {
        g.continueTrail();
      }
    }
    double x = 0, y = 0;
    if (keys.contains(LogicalKeyboardKey.keyW) ||
        keys.contains(LogicalKeyboardKey.arrowUp)) {
      y--;
    }
    if (keys.contains(LogicalKeyboardKey.keyS) ||
        keys.contains(LogicalKeyboardKey.arrowDown)) {
      y++;
    }
    if (keys.contains(LogicalKeyboardKey.keyA) ||
        keys.contains(LogicalKeyboardKey.arrowLeft)) {
      x--;
    }
    if (keys.contains(LogicalKeyboardKey.keyD) ||
        keys.contains(LogicalKeyboardKey.arrowRight)) {
      x++;
    }
    g.input = g.canMove ? unit(Offset(x, y)) : Offset.zero;
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !playing,
    onPopInvokedWithResult: (p, r) {
      if (!p) {
        panel == null ? openPanel('pause') : closePanel();
      }
    },
    child: Scaffold(
      body: SafeArea(
        child: Focus(
          autofocus: true,
          onKeyEvent: keyboard,
          child:
              playing
                  ? ValueListenableBuilder<int>(
                    valueListenable: hud,
                    builder:
                        (context, _, child) =>
                            browserPreview
                                ? ColoredBox(
                                  color: const Color(0xFFDBE5D7),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 460,
                                      ),
                                      child: game(),
                                    ),
                                  ),
                                )
                                : game(),
                  )
                  : lobby(),
        ),
      ),
    ),
  );
  Widget lobby() => Container(
    color: const Color(0xFFDBE5D7),
    alignment: Alignment.center,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: ColoredBox(
        color: paper,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: appGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.eco_outlined,
                      color: leaf,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t('app'),
                      style: TextStyle(
                        color: appGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 21 * textScale,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEBCF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${g.xp} ${t('xp')}',
                      style: const TextStyle(
                        color: appGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: tab,
                children: [
                  homeTab(),
                  journeyTab(),
                  journalTab(),
                  settingsTab(),
                ],
              ),
            ),
            if (tab == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 9, 20, 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    key: const Key('play'),
                    onPressed: start,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded),
                        const SizedBox(width: 8),
                        Text(
                          t(
                            g.journeyComplete
                                ? 'newJourney'
                                : g.completedDecisions > 0 ||
                                    g.travel > 0 ||
                                    g.hasTiger
                                ? 'resume'
                                : 'play',
                          ),
                          style: TextStyle(
                            fontSize: 14 * textScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            NavigationBar(
              selectedIndex: tab,
              onDestinationSelected: (i) => setState(() => tab = i),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: t('home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.route_outlined),
                  selectedIcon: const Icon(Icons.route),
                  label: t('journey'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.menu_book_outlined),
                  label: t('journal'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: t('settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  Widget homeTab() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('welcome'),
          style: TextStyle(
            fontSize: 23 * textScale,
            color: appGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          t('subtitle'),
          style: TextStyle(color: muted, fontSize: 12 * textScale),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: SizedBox(
            height: 140,
            child: Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: ForestPainter(g, heroRenderer, title: true),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          forestInk.withValues(alpha: .95),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: leaf,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t('offline'),
                      style: const TextStyle(
                        fontSize: 9,
                        color: forestInk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${t('chapter')} ${g.zoneIndex + 1} / 6',
                        style: const TextStyle(color: leaf, fontSize: 10),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        t('zone${g.zoneIndex}'),
                        style: TextStyle(
                          color: ivory,
                          fontWeight: FontWeight.w700,
                          fontSize: 20 * textScale,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        section(t('choose')),
        const SizedBox(height: 4),
        Text(
          t('profileNote'),
          style: TextStyle(color: muted, fontSize: 10 * textScale),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder:
              (context, c) => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int i = 0; i < 4; i++)
                    SizedBox(width: (c.maxWidth - 10) / 2, child: ageCard(i)),
                ],
              ),
        ),
        const SizedBox(height: 18),
        section(t('difficulty')),
        const SizedBox(height: 11),
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              Expanded(
                child: InkWell(
                  key: Key('difficulty-${difficulties[i]}'),
                  onTap: () => profile(g.ageGroup, difficulties[i]),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          g.difficulty == difficulties[i]
                              ? appGreen
                              : const Color(0xFFE2E9DA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      t(difficulties[i]),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12 * textScale,
                        color:
                            g.difficulty == difficulties[i]
                                ? Colors.white
                                : appGreen,
                      ),
                    ),
                  ),
                ),
              ),
              if (i < 2) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          t('${g.difficulty}Detail'),
          style: TextStyle(color: muted, fontSize: 11 * textScale, height: 1.5),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.route, size: 15, color: appGreen),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                t('longTrail'),
                style: TextStyle(
                  color: muted,
                  fontSize: 10 * textScale,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget ageCard(int i) {
    final age = ages[i], selected = g.ageGroup == age;
    final foreground = i < 2 ? appGreen : ivory;
    return Semantics(
      selected: selected,
      button: true,
      label: t(age),
      child: InkWell(
        key: Key('age-$age'),
        onTap: () => profile(age, g.difficulty),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 92),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ageColors[i],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? appGreen : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    [
                      Icons.child_care,
                      Icons.hiking,
                      Icons.person_outline,
                      Icons.self_improvement,
                    ][i],
                    color: foreground,
                    size: 24,
                  ),
                  const Spacer(),
                  if (selected)
                    Icon(Icons.check_circle, color: foreground, size: 18),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                t(age),
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 14 * textScale,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t('${age}Detail'),
                style: TextStyle(
                  color: foreground.withValues(alpha: .95),
                  fontSize: 9 * textScale,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget journeyTab() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
    children: [
      section(t('journey'), size: 23),
      const SizedBox(height: 9),
      Text(
        t('longTrail'),
        style: TextStyle(color: muted, fontSize: 12 * textScale, height: 1.5),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${g.completedDecisions} / 12  ${t('journeyProgress')}',
              style: const TextStyle(
                color: appGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: g.completedDecisions / 12,
              minHeight: 6,
              borderRadius: BorderRadius.circular(9),
              backgroundColor: const Color(0xFFDDE5D5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      for (int i = 0; i < 6; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: cardDecoration(
              color:
                  i == g.zoneIndex
                      ? const Color(0xFFD8EBCB)
                      : const Color(0xFFF9FBF5),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        i <= g.zoneIndex ? appGreen : const Color(0xFFDAE1D4),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child:
                      i > g.zoneIndex
                          ? const Icon(
                            Icons.lock_outline,
                            color: muted,
                            size: 20,
                          )
                          : Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: ivory,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t('zone$i'),
                        style: TextStyle(
                          fontSize: 15 * textScale,
                          fontWeight: FontWeight.w700,
                          color: appGreen,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        t(
                          i < g.zoneIndex || g.journeyComplete
                              ? 'done'
                              : i == g.zoneIndex
                              ? 'current'
                              : 'locked',
                        ),
                        style: TextStyle(
                          color: muted,
                          fontSize: 11 * textScale,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < g.zoneIndex || g.journeyComplete)
                  const Icon(Icons.check_circle, color: appGreen),
              ],
            ),
          ),
        ),
      SizedBox(
        height: 49,
        child: FilledButton(
          onPressed: start,
          child: Text(t(g.journeyComplete ? 'newJourney' : 'resume')),
        ),
      ),
    ],
  );
  Widget journalTab() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
    children: [
      section(t('journal'), size: 23),
      const SizedBox(height: 17),
      Row(
        children: [
          stat(t('correct'), '${g.correct}'),
          const SizedBox(width: 9),
          stat(t('missed'), '${g.incorrect + g.timeouts}'),
          const SizedBox(width: 9),
          stat(t('best'), '${g.bestStreak}'),
        ],
      ),
      const SizedBox(height: 20),
      if (g.journal.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 65),
          child: Column(
            children: [
              const Icon(Icons.eco_outlined, size: 44, color: muted),
              const SizedBox(height: 15),
              Text(
                t('emptyJournal'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted),
              ),
            ],
          ),
        ),
      for (final entry in g.journal)
        Builder(
          builder: (context) {
            final matches = questions.where((q) => q.id == entry.questionId);
            if (matches.isEmpty) {
              return const SizedBox();
            }
            final q = matches.first;
            final good = entry.outcome == AnswerOutcome.correct;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          good
                              ? Icons.check_circle_outline
                              : Icons.info_outline,
                          color: good ? appGreen : const Color(0xFF8D5738),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t(
                              good
                                  ? 'correct'
                                  : entry.outcome == AnswerOutcome.timeout
                                  ? 'timeoutTitle'
                                  : 'missed',
                            ),
                            style: const TextStyle(
                              color: appGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${good ? '+' : '−'}${entry.delta.abs()} ${t('xp')}',
                          style: const TextStyle(
                            color: appGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      q.prompt.inLanguage(g.language),
                      style: TextStyle(
                        color: appGreen,
                        fontSize: 13 * textScale,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.explanation.inLanguage(g.language),
                      style: TextStyle(
                        color: muted,
                        fontSize: 11 * textScale,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    ],
  );
  Widget settingsTab() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
    children: [
      section(t('settings'), size: 23),
      const SizedBox(height: 20),
      section(t('language')),
      const SizedBox(height: 6),
      Text(
        t('languageNote'),
        style: TextStyle(color: muted, fontSize: 11 * textScale, height: 1.5),
      ),
      const SizedBox(height: 12),
      for (final pair in const [
        ['en', 'English'],
        ['hi', 'हिन्दी'],
        ['mr', 'मराठी'],
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color:
                g.language == pair[0] ? const Color(0xFFD8EBCB) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              key: Key('language-${pair[0]}'),
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                g.setLanguage(pair[0]);
                widget.onLocale?.call();
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Text(
                      pair[1],
                      style: const TextStyle(
                        fontFamily: 'NotoDevanagari',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: appGreen,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      g.language == pair[0]
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: appGreen,
                      size: 21,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      const SizedBox(height: 14),
      switchRow('sound', g.sound, (v) => g.sound = v),
      switchRow('haptics', g.haptics, (v) => g.haptics = v),
      switchRow('lightweight', g.lightweight, (v) => g.lightweight = v),
      switchRow('largeText', g.largeText, (v) => g.largeText = v),
      const SizedBox(height: 16),
      ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          t('help'),
          style: const TextStyle(
            color: appGreen,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        children: [
          Text(
            t('helpBody'),
            style: TextStyle(
              color: muted,
              fontSize: 12 * textScale,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            t('timerNote'),
            style: TextStyle(
              color: muted,
              fontSize: 11 * textScale,
              height: 1.6,
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      Text(
        t('privacy'),
        style: TextStyle(color: muted, fontSize: 10 * textScale, height: 1.6),
      ),
      const SizedBox(height: 13),
      Text(
        t('safety'),
        style: TextStyle(color: muted, fontSize: 10 * textScale, height: 1.6),
      ),
      if (browserPreview) ...[
        const SizedBox(height: 13),
        Text(
          t('previewNote'),
          style: const TextStyle(color: muted, fontSize: 10, height: 1.6),
        ),
      ],
    ],
  );
  Widget switchRow(String key, bool value, ValueChanged<bool> change) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          t(key),
          style: TextStyle(color: appGreen, fontSize: 13 * textScale),
        ),
        value: value,
        onChanged: (v) {
          setState(() => change(v));
          g.save();
        },
      );
  Widget section(String s, {double size = 16}) => Text(
    s,
    style: TextStyle(
      color: appGreen,
      fontWeight: FontWeight.w800,
      fontSize: size * textScale,
    ),
  );
  Widget stat(String s, String value) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: appGreen,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            s,
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 9 * textScale),
          ),
        ],
      ),
    ),
  );
  BoxDecoration cardDecoration({Color color = const Color(0xFFFAFCF5)}) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E7D9)),
      );

  Widget game() => LayoutBuilder(
    builder: (context, box) {
      final portrait = box.maxHeight > box.maxWidth;
      final encounter =
          g.phase == EncounterPhase.question ||
          g.phase == EncounterPhase.feedback;
      final cardHeight =
          portrait ? (box.maxHeight * .59).clamp(350.0, 520.0) : 0.0;
      final worldHeight =
          portrait && encounter
              ? math.max(150.0, box.maxHeight - cardHeight)
              : box.maxHeight;
      return ColoredBox(
        color: forestInk,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: worldHeight,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: ForestPainter(g, renderer, portrait: portrait),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 98,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        forestInk.withValues(alpha: .95),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 13,
              left: 14,
              right: 14,
              child: Row(
                children: [
                  gameIcon(
                    Icons.arrow_back,
                    home,
                    t('home'),
                    enabled:
                        !g.activeQuestion &&
                        g.phase != EncounterPhase.approaching,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${t('chapter')} ${g.zoneIndex + 1} / 6',
                          style: const TextStyle(color: leaf, fontSize: 9),
                        ),
                        Text(
                          t('zone${g.zoneIndex}'),
                          style: TextStyle(
                            color: ivory,
                            fontSize: 14 * textScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: forestInk.withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      '${g.xp} ${t('xp')}',
                      key: const Key('xp-value'),
                      style: const TextStyle(
                        color: leaf,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  gameIcon(
                    Icons.pause,
                    () => openPanel('pause'),
                    t('pause'),
                    enabled:
                        !g.activeQuestion &&
                        g.phase != EncounterPhase.approaching,
                  ),
                ],
              ),
            ),
            if (!encounter && !g.awaitingRoute) ...[
              Positioned(
                top: 83,
                left: 16,
                right: portrait ? 156 : box.maxWidth * .55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(g.checkpointIndex < 2 ? 'target' : 'camp'),
                      style: TextStyle(
                        color: ivory,
                        fontSize: 12 * textScale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Transform.rotate(
                          angle: project(g.destination - g.player).direction,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: amber,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '${g.completedDecisions} / 12',
                          style: const TextStyle(color: leaf, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                top: 81,
                width: portrait ? 119 : 130,
                height: portrait ? 110 : 114,
                child: GestureDetector(
                  onTap: () => openPanel('map'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomPaint(painter: TrailMap(g)),
                  ),
                ),
              ),
              if (g.canMove)
                Positioned(
                  left: 16,
                  bottom: 33,
                  child: Joystick(
                    onChange: (p) {
                      g.input = g.canMove ? p : Offset.zero;
                    },
                  ),
                ),
              if (g.canMove)
                Positioned(
                  right: 19,
                  bottom: 47,
                  child: Column(
                    children: [
                      gameIcon(
                        Icons.visibility_outlined,
                        () => openPanel('observe'),
                        t('observe'),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        t('observe'),
                        style: const TextStyle(color: ivory, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              if (g.canMove)
                Positioned(
                  left: 61,
                  bottom: 19,
                  child: Text(
                    t('explore'),
                    style: const TextStyle(color: leaf, fontSize: 10),
                  ),
                ),
            ],
            if (g.phase == EncounterPhase.approaching)
              Positioned(
                top: worldHeight * .35,
                left: 20,
                right: 20,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: forestInk.withValues(alpha: .9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      t('encounter'),
                      style: const TextStyle(
                        color: amber,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            if (encounter)
              Positioned(
                right: portrait ? 0 : 16,
                left: portrait ? 0 : null,
                top: portrait ? worldHeight : 76,
                bottom: portrait ? 0 : 15,
                width: portrait ? null : math.min(440, box.maxWidth * .49),
                child: quizCard(compact: !portrait && box.maxHeight < 500),
              ),
            if (g.awaitingRoute)
              Positioned.fill(child: modalSurface(routeCard())),
            if (panel != null)
              Positioned.fill(child: modalSurface(panelCard())),
          ],
        ),
      );
    },
  );
  Widget gameIcon(
    IconData icon,
    VoidCallback action,
    String label, {
    bool enabled = true,
  }) => Semantics(
    label: label,
    button: true,
    child: Material(
      color: forestInk.withValues(alpha: .85),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: enabled ? action : null,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: enabled ? leaf : leaf.withValues(alpha: .3),
            size: 23,
          ),
        ),
      ),
    ),
  );
  Widget quizCard({bool compact = false}) {
    final q = g.currentQuestion!,
        feedback = g.phase == EncounterPhase.feedback,
        good = g.outcome == AnswerOutcome.correct;
    final font = (compact ? 11.5 : 13.0) * textScale;
    return Container(
      key: const Key('encounter-card'),
      padding: EdgeInsets.all(compact ? 13 : 18),
      decoration: BoxDecoration(
        color: const Color(0xFF102C22),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
        border: Border.all(color: leaf.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(
                        feedback
                            ? good
                                ? 'goodTitle'
                                : g.outcome == AnswerOutcome.timeout
                                ? 'timeoutTitle'
                                : 'wrongTitle'
                            : 'decision',
                      ),
                      style: TextStyle(
                        color: ivory,
                        fontWeight: FontWeight.w700,
                        fontSize: (compact ? 15 : 19) * textScale,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${t(g.ageGroup)} · ${t(g.difficulty)}',
                      style: TextStyle(color: leaf, fontSize: compact ? 9 : 11),
                    ),
                  ],
                ),
              ),
              if (!feedback)
                SizedBox(
                  width: compact ? 40 : 48,
                  height: compact ? 40 : 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: g.remaining / 15,
                          strokeWidth: 3,
                          color: g.remaining <= 5 ? danger : leaf,
                          backgroundColor: const Color(0xFF2C503C),
                        ),
                      ),
                      Text(
                        '${g.secondsShown}',
                        key: const Key('countdown'),
                        style: TextStyle(
                          color: g.remaining <= 5 ? danger : ivory,
                          fontSize: compact ? 19 : 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              if (feedback)
                Text(
                  '${good ? '+' : '−'}${g.xpDelta.abs()} ${t('xp')}',
                  key: const Key('xp-change'),
                  style: TextStyle(
                    color: good ? mint : danger,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
          SizedBox(height: compact ? 9 : 13),
          Expanded(
            child:
                feedback
                    ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t('better'),
                            style: TextStyle(
                              color: mint,
                              fontWeight: FontWeight.w700,
                              fontSize: font,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: mint.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: mint.withValues(alpha: .3),
                              ),
                            ),
                            child: Text(
                              q.options[q.correctIndex].inLanguage(g.language),
                              style: TextStyle(
                                color: ivory,
                                fontSize: font,
                                height: 1.55,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            q.explanation.inLanguage(g.language),
                            style: TextStyle(
                              color: ivory.withValues(alpha: .75),
                              fontSize: font,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                    : LayoutBuilder(
                      builder: (context, box) {
                        // Natural-height content scrolls on compact screens or larger text, never clips choices.
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.prompt.inLanguage(g.language),
                                style: TextStyle(
                                  color: ivory.withValues(alpha: .9),
                                  fontSize: font,
                                  height: 1.45,
                                ),
                              ),
                              SizedBox(height: compact ? 9 : 13),
                              for (int i = 0; i < 4; i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: compact ? 5 : 7,
                                  ),
                                  child: Material(
                                    color: const Color(0xFF214331),
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      key: Key('answer-$i'),
                                      onTap: () => g.answer(i),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          minHeight: compact ? 40 : 48,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 11,
                                          vertical: compact ? 6 : 9,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 23,
                                              height: 23,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: forestInk.withValues(
                                                  alpha: .6,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '${i + 1}',
                                                style: const TextStyle(
                                                  color: leaf,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                q.options[g.choiceOrder[i]]
                                                    .inLanguage(g.language),
                                                style: TextStyle(
                                                  color: ivory,
                                                  fontSize: font - 1,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          SizedBox(height: compact ? 6 : 10),
          if (feedback)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                key: const Key('continue-trail'),
                onPressed: g.continueTrail,
                style: FilledButton.styleFrom(
                  backgroundColor: leaf,
                  foregroundColor: forestInk,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  t('continue'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          if (!feedback)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 18,
              runSpacing: 4,
              children: [
                Text(
                  t('reward'),
                  style: TextStyle(color: mint, fontSize: compact ? 9 : 10),
                ),
                Text(
                  t('penalty'),
                  style: TextStyle(color: amber, fontSize: compact ? 9 : 10),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget modalSurface(Widget child) => ColoredBox(
    color: const Color(0xC0092018),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: paper,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(23),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
  Widget routeCard() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.route, color: appGreen, size: 32),
      const SizedBox(height: 13),
      section(t(g.journeyComplete ? 'finishTitle' : 'routeTitle'), size: 22),
      const SizedBox(height: 12),
      Text(
        t(g.journeyComplete ? 'finishBody' : 'routeBody'),
        style: TextStyle(color: muted, fontSize: 12 * textScale, height: 1.7),
      ),
      const SizedBox(height: 20),
      if (g.journeyComplete) ...[
        Text(
          '${g.xp} ${t('xp')}',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: appGreen,
          ),
        ),
        const SizedBox(height: 17),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(onPressed: home, child: Text(t('returnHome'))),
        ),
      ] else ...[
        routeOption(0, Icons.shortcut, 'direct'),
        const SizedBox(height: 12),
        routeOption(1, Icons.forest_outlined, 'loop'),
      ],
    ],
  );
  Widget routeOption(int value, IconData icon, String key) => InkWell(
    key: Key('route-$value'),
    onTap: () {
      g.chooseRoute(value);
      setState(() {});
    },
    borderRadius: BorderRadius.circular(13),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: value == 0 ? const Color(0xFFDCECCF) : appGreen,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(icon, color: value == 0 ? appGreen : ivory),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(key),
                  style: TextStyle(
                    color: value == 0 ? appGreen : ivory,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t('${key}Detail'),
                  style: TextStyle(
                    color: value == 0 ? muted : leaf,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget panelCard() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: section(t(panel!), size: 21)),
          IconButton(
            onPressed: closePanel,
            icon: const Icon(Icons.close, color: appGreen),
          ),
        ],
      ),
      const SizedBox(height: 17),
      if (panel == 'pause') ...[
        SizedBox(
          width: double.infinity,
          height: 49,
          child: FilledButton(onPressed: closePanel, child: Text(t('resume'))),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 49,
          child: OutlinedButton(onPressed: home, child: Text(t('returnHome'))),
        ),
      ],
      if (panel == 'observe') ...[
        Text(
          t('observeNote'),
          style: TextStyle(color: muted, fontSize: 13 * textScale, height: 1.7),
        ),
        const SizedBox(height: 14),
        Text(
          t('safety'),
          style: TextStyle(color: muted, fontSize: 10 * textScale, height: 1.6),
        ),
      ],
      if (panel == 'map') ...[
        SizedBox(
          height: 280,
          child: CustomPaint(
            painter: TrailMap(g),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          t('mapLegend'),
          style: TextStyle(color: muted, fontSize: 11 * textScale),
        ),
      ],
    ],
  );
}

class Joystick extends StatefulWidget {
  final ValueChanged<Offset> onChange;
  const Joystick({super.key, required this.onChange});
  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset value = Offset.zero;
  int? pointer;
  void move(Offset local) {
    final p = (local - const Offset(66, 66)) / 46;
    value = p.distance > 1 ? unit(p) : p;
    widget.onChange(value);
    setState(() {});
  }

  void reset() {
    pointer = null;
    value = Offset.zero;
    widget.onChange(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.opaque,
    onPointerDown: (e) {
      if (pointer == null) {
        pointer = e.pointer;
        move(e.localPosition);
      }
    },
    onPointerMove: (e) {
      if (pointer == e.pointer) {
        move(e.localPosition);
      }
    },
    onPointerUp: (e) {
      if (pointer == e.pointer) {
        reset();
      }
    },
    onPointerCancel: (e) {
      if (pointer == e.pointer) {
        reset();
      }
    },
    child: SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: forestInk.withValues(alpha: .5),
              border: Border.all(color: leaf.withValues(alpha: .4)),
            ),
          ),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: leaf.withValues(alpha: .15)),
            ),
          ),
          Transform.translate(
            offset: value * 39,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF416A48),
                border: Border.all(color: leaf),
              ),
              child: const Icon(Icons.eco_outlined, color: ivory, size: 25),
            ),
          ),
        ],
      ),
    ),
  );
}
