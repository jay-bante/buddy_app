import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'forest_engine.dart';

void polygon(Canvas c, List<Offset> points, Color color) =>
    c.drawPath(Path()..addPolygon(points, true), Paint()..color = color);

class ForestRenderer {
  int cachedZone = -1;
  ui.Picture? ground;
  ui.Image? groundImage;
  void dispose() {
    groundImage?.dispose();
    ground?.dispose();
  }

  void prepare(ForestEngine g) {
    if (ground != null && cachedZone == g.zoneIndex) {
      return;
    }
    if (ground != null) {
      dispose();
      ground = null;
      groundImage = null;
    }
    cachedZone = g.zoneIndex;
    final recorder = ui.PictureRecorder(),
        r = math.Random(509 + g.zoneIndex * 97);
    final c = Canvas(recorder);
    polygon(c, [
      project(Offset.zero),
      project(const Offset(2200, 0)),
      project(const Offset(2200, 2200)),
      project(const Offset(0, 2200)),
    ], const Color(0xFF32583E));
    for (int i = 0; i < 3800; i++) {
      final p = project(Offset(r.nextDouble() * 2200, r.nextDouble() * 2200));
      final colors = [
        const Color(0xFF45734B),
        const Color(0xFF5B7C47),
        const Color(0xFF223F33),
        const Color(0xFF789250),
      ];
      c.drawOval(
        Rect.fromCenter(
          center: p,
          width: 12 + r.nextDouble() * 80,
          height: 5 + r.nextDouble() * 35,
        ),
        Paint()
          ..color = colors[i % 4].withValues(alpha: .12 + r.nextDouble() * .18),
      );
    }
    // Earth path ribbons are projected from world space, not a tiled floor.
    final route = [...g.landmarks, g.landmarks.first];
    for (int i = 0; i < route.length - 1; i++) {
      final from = route[i], to = route[i + 1];
      final direction = unit(to - from);
      final n = Offset(-direction.dy, direction.dx);
      final left = <Offset>[], right = <Offset>[];
      for (int j = 0; j <= 20; j++) {
        final t = j / 20;
        final p =
            Offset.lerp(from, to, t)! + n * (math.sin(t * math.pi * 2) * 24);
        final width = 34 + math.sin(t * math.pi) * 9;
        left.add(project(p + n * width));
        right.add(project(p - n * width));
      }
      polygon(c, [...left, ...right.reversed], const Color(0xFF6C7951));
      final track = Path();
      for (int j = 0; j <= 20; j++) {
        final t = j / 20;
        final p = project(
          Offset.lerp(from, to, t)! + n * (math.sin(t * math.pi * 2) * 24),
        );
        if (j == 0) {
          track.moveTo(p.dx, p.dy);
        } else {
          track.lineTo(p.dx, p.dy);
        }
      }
      c.drawPath(
        track,
        Paint()
          ..color = const Color(0x337F885E)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12,
      );
    }
    for (final b in g.ponds) {
      final pts = [
        project(b.topLeft),
        project(b.topRight),
        project(b.bottomRight),
        project(b.bottomLeft),
      ];
      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 0; i < 4; i++) {
        final a = pts[i], z = pts[(i + 1) % 4];
        path.quadraticBezierTo(
          a.dx,
          a.dy,
          (a.dx + z.dx) / 2,
          (a.dy + z.dy) / 2,
        );
      }
      path.close();
      c.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF213E35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22,
      );
      c.drawPath(path, Paint()..color = const Color(0xFF427B70));
      c.save();
      c.clipPath(path);
      for (int i = 0; i < 35; i++) {
        final p = project(
          b.topLeft +
              Offset(r.nextDouble() * b.width, r.nextDouble() * b.height),
        );
        c.drawLine(
          p,
          p + Offset(12 + r.nextDouble() * 35, 0),
          Paint()
            ..color = const Color(0x3388C3A0)
            ..strokeWidth = 1.5,
        );
      }
      c.restore();
      for (int i = 0; i < 9; i++) {
        final p = project(
          b.center +
              Offset(r.nextDouble() * 100 - 50, r.nextDouble() * 80 - 40),
        );
        c.drawOval(
          Rect.fromCenter(center: p, width: 10, height: 5),
          Paint()..color = const Color(0xFF79A35C),
        );
        if (i % 4 == 0) {
          c.drawCircle(p, 1.8, Paint()..color = ivory.withValues(alpha: .7));
        }
      }
    }
    for (int i = 0; i < 2200; i++) {
      final w = Offset(r.nextDouble() * 2200, r.nextDouble() * 2200);
      if (g.ponds.any((b) => b.inflate(10).contains(w))) {
        continue;
      }
      final p = project(w),
          pen =
              Paint()
                ..color = (i % 3 == 0
                        ? const Color(0xFF9BAF65)
                        : const Color(0xFF173F31))
                    .withValues(alpha: .5)
                ..strokeWidth = 1;
      c.drawLine(p, p + Offset(-3, -3 - r.nextDouble() * 7), pen);
      c.drawLine(p, p + Offset(2, -5 - r.nextDouble() * 6), pen);
      if (i % 7 == 0) {
        c.drawCircle(p, 1.5, Paint()..color = amber.withValues(alpha: .45));
      }
    }
    ground = recorder.endRecording();
    // Raster-cache the large static layer once (~14 MB RGBA). Avoid replaying
    // thousands of grass/moss paths on every animation frame.
    final rasterRecorder = ui.PictureRecorder();
    final rasterCanvas =
        Canvas(rasterRecorder)
          ..scale(.75)
          ..translate(1716, 0);
    rasterCanvas.drawPicture(ground!);
    final rasterPicture = rasterRecorder.endRecording();
    groundImage = rasterPicture.toImageSync(2574, 1386);
    rasterPicture.dispose();
  }
}

class ForestPainter extends CustomPainter {
  final ForestEngine g;
  final ForestRenderer renderer;
  final bool title;
  final bool portrait;
  ForestPainter(
    this.g,
    this.renderer, {
    this.title = false,
    this.portrait = false,
  }) : super(repaint: g);
  @override
  void paint(Canvas c, Size size) {
    renderer.prepare(g);
    c.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF19372A));
    final zoom = (size.height / 650).clamp(.7, 1.25);
    final focus = title ? const Offset(850, 1230) : g.camera;
    final origin =
        Offset(
          size.width *
              (title
                  ? .67
                  : portrait
                  ? .5
                  : g.cameraFraction),
          size.height * .55,
        ) -
        project(focus) * zoom;
    c.save();
    c.translate(origin.dx, origin.dy);
    c.scale(zoom);
    c.drawImageRect(
      renderer.groundImage!,
      const Rect.fromLTWH(0, 0, 2574, 1386),
      const Rect.fromLTWH(-1716, 0, 3432, 1848),
      Paint()..filterQuality = FilterQuality.low,
    );
    final visible = Rect.fromLTWH(
      -origin.dx / zoom - 130,
      -origin.dy / zoom - 30,
      size.width / zoom + 260,
      size.height / zoom + 260,
    );
    for (final b in g.ponds) {
      final p = project(b.center);
      final t = (g.time * 8) % 65;
      c.drawOval(
        Rect.fromCenter(center: p, width: 30 + t, height: 12 + t * .35),
        Paint()
          ..color = mint.withValues(alpha: .18 * (1 - t / 65))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
    if (!title && !g.hasTiger && !g.journeyComplete) {
      final marker = project(g.destination);
      c.drawOval(
        Rect.fromCenter(center: marker, width: 64, height: 30),
        Paint()..color = amber.withValues(alpha: .3),
      );
      c.drawOval(
        Rect.fromCenter(center: marker, width: 64, height: 30),
        Paint()
          ..color = amber
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      final bob = math.sin(g.time * 3) * 5;
      polygon(c, [
        marker + Offset(0, -55 + bob),
        marker + Offset(12, -38 + bob),
        marker + Offset(0, -23 + bob),
        marker + Offset(-12, -38 + bob),
      ], amber);
    }
    if (g.hasTiger && !title) {
      final p = project(g.player);
      c.drawOval(
        Rect.fromCenter(center: p, width: 192, height: 102),
        Paint()
          ..color = amber.withValues(alpha: .13)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      for (int i = 0; i < 12; i++) {
        final a = i * math.pi / 6;
        final p1 = p + Offset(math.cos(a) * 96, math.sin(a) * 51);
        final p2 = p + Offset(math.cos(a + .12) * 96, math.sin(a + .12) * 51);
        c.drawLine(
          p1,
          p2,
          Paint()
            ..color = amber.withValues(alpha: .5)
            ..strokeWidth = 1.7,
        );
      }
    }
    final drawables = <({double depth, VoidCallback draw})>[];
    for (final prop in g.scenery) {
      if (!visible.contains(project(prop.pos))) {
        continue;
      }
      drawables.add((
        depth: prop.pos.dx + prop.pos.dy,
        draw: () => scenery(c, prop),
      ));
    }
    for (int i = 0; i < g.landmarks.length; i++) {
      final pos = g.landmarks[i] + const Offset(-62, 25);
      drawables.add((depth: pos.dx + pos.dy, draw: () => sign(c, pos, i)));
    }
    drawables.add((depth: g.player.dx + g.player.dy, draw: () => hero(c)));
    if (g.hasTiger && !title) {
      drawables.add((depth: g.tiger.dx + g.tiger.dy, draw: () => tiger(c)));
    }
    drawables.sort((a, b) => a.depth.compareTo(b.depth));
    for (final d in drawables) {
      d.draw();
    }
    c.restore();
    if (!g.lightweight) {
      // Soft shafts and drifting motes: simple alpha geometry, no blur layers.
      for (int i = 0; i < 4; i++) {
        final x = size.width * (.35 + i * .24);
        polygon(c, [
          Offset(x, -10),
          Offset(x + 35, -10),
          Offset(x - 170, size.height),
          Offset(x - 265, size.height),
        ], const Color(0x059CD581));
      }
      for (int i = 0; i < 16; i++) {
        final x = (i * 137.7 + math.sin(g.time * .3 + i) * 30) % size.width;
        final y = (i * 61.3 - g.time * 5) % size.height;
        c.drawCircle(
          Offset(x, y),
          i % 3 == 0 ? 1.8 : 1.1,
          Paint()
            ..color = leaf.withValues(
              alpha: .12 + (.5 + .5 * math.sin(g.time + i)) * .25,
            ),
        );
      }
    }
    c.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width * .5, size.height * .49),
          size.width * .7,
          [Colors.transparent, const Color(0xA5081D18)],
          [.3, 1],
        ),
    );
  }

  void scenery(Canvas c, Scenery p) {
    final at = project(p.pos), s = p.size;
    if (p.kind == 0) {
      // Fade a canopy near the explorer's screen position without offscreen layers.
      final delta = at - project(g.player);
      final obscures =
          delta.dy > 0 && delta.dy < s * 2.7 && delta.dx.abs() < s * .85;
      final tigerDelta = at - project(g.tiger);
      final overTiger =
          g.hasTiger &&
          tigerDelta.dy > 0 &&
          tigerDelta.dy < s * 2.7 &&
          tigerDelta.dx.abs() < s * .85;
      final alpha = obscures || overTiger ? .07 : 1.0;
      c.drawOval(
        Rect.fromCenter(
          center: at + Offset(s * .2, 4),
          width: s * 1.4,
          height: s * .58,
        ),
        Paint()..color = const Color(0x30102722),
      );
      c.drawLine(
        at,
        at + Offset(-4, -s * 1.3),
        Paint()
          ..color = const Color(0xFF5C5940).withValues(alpha: alpha)
          ..strokeWidth = s * .14,
      );
      c.drawLine(
        at + Offset(0, -s * .6),
        at + Offset(s * .35, -s * 1.1),
        Paint()
          ..color = const Color(0xFF5C5940).withValues(alpha: alpha)
          ..strokeWidth = s * .075,
      );
      for (int i = 0; i < 4; i++) {
        final top =
            at + Offset((i % 2 == 0 ? -1 : 1) * s * .18, -s * (.92 + i * .19));
        final color =
            Color.lerp(
              const Color(0xFF204C36),
              const Color(0xFF729853),
              p.variant * .45 + i * .16,
            )!;
        polygon(c, [
          top + Offset(-s * .64, s * .12),
          top + Offset(-s * .7, -s * .2),
          top + Offset(-s * .35, -s * .53),
          top + Offset(s * .15, -s * .62),
          top + Offset(s * .6, -s * .3),
          top + Offset(s * .65, s * .06),
          top + Offset(s * .1, s * .28),
        ], color.withValues(alpha: alpha));
        polygon(c, [
          top + Offset(-s * .35, -s * .53),
          top + Offset(s * .15, -s * .62),
          top + Offset(s * .6, -s * .3),
          top + Offset(s * .04, -s * .2),
        ], Color.lerp(color, leaf, .13)!.withValues(alpha: alpha));
        c.drawLine(
          top + Offset(-s * .25, -s * .35),
          top + Offset(s * .12, -s * .28),
          Paint()
            ..color = leaf.withValues(alpha: alpha * .13)
            ..strokeWidth = 2,
        );
      }
    } else if (p.kind == 1) {
      c.drawOval(
        Rect.fromCenter(center: at, width: s * 1.3, height: s * .4),
        Paint()..color = const Color(0x3310251D),
      );
      polygon(c, [
        at + Offset(-s * .6, 0),
        at + Offset(-s * .4, -s * .4),
        at + Offset(s * .13, -s * .6),
        at + Offset(s * .5, -s * .25),
        at + Offset(s * .55, s * .12),
        at + Offset(-s * .1, s * .2),
      ], const Color(0xFF516B58));
      polygon(c, [
        at + Offset(-s * .4, -s * .4),
        at + Offset(s * .13, -s * .6),
        at + Offset(s * .5, -s * .25),
        at + Offset(-s * .05, -s * .15),
      ], const Color(0xFF71856A));
      c.drawOval(
        Rect.fromCenter(
          center: at - Offset(s * .12, s * .28),
          width: s * .55,
          height: s * .16,
        ),
        Paint()..color = const Color(0xFF7B9856),
      );
    } else if (p.kind == 2) {
      for (int i = 0; i < 7; i++) {
        final a = (i - 3) * .4;
        final end = at + Offset(math.sin(a) * s * .7, -math.cos(a) * s * .6);
        final mid = Offset.lerp(at, end, .5)! + Offset(i < 3 ? -4 : 4, 0);
        polygon(c, [
          at,
          mid,
          end,
          Offset.lerp(at, end, .5)! + Offset(i < 3 ? 2 : -2, -4),
        ], i % 2 == 0 ? const Color(0xFF6A9C55) : const Color(0xFF3F8249));
      }
    } else {
      for (int i = 0; i < 3; i++) {
        final b = at + Offset(i * 6.0 - 6, i % 2 * 3.0);
        c.drawLine(
          b,
          b - const Offset(0, 9),
          Paint()
            ..color = const Color(0xFFD1CEA3)
            ..strokeWidth = 2,
        );
        c.drawOval(
          Rect.fromCenter(center: b - const Offset(0, 9), width: 9, height: 5),
          Paint()..color = const Color(0xFFC68E53),
        );
      }
    }
  }

  void hero(Canvas c) {
    final p = project(g.player);
    final walk = g.canMove && g.input.distance > .12;
    final bob = walk ? math.sin(g.time * 13) * 1.7 : math.sin(g.time * 2) * .5;
    c.drawOval(
      Rect.fromCenter(center: p, width: 34, height: 16),
      Paint()..color = const Color(0x66132A20),
    );
    c.drawOval(
      Rect.fromCenter(center: p, width: 35, height: 17),
      Paint()
        ..color = ivory.withValues(alpha: .5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    c.save();
    c.translate(p.dx, p.dy + bob);
    final stride = walk ? math.sin(g.time * 13) * 3 : 0.0;
    // Same explorer silhouette as before: blue-green cape, cream tunic, empty hands.
    polygon(c, const [
      Offset(-10, -35),
      Offset(9, -35),
      Offset(15, -9),
      Offset(-17, -10),
    ], const Color(0xFF285965));
    c.drawLine(
      const Offset(-5, -19),
      Offset(-7, -2 + stride),
      Paint()
        ..color = const Color(0xFF34453D)
        ..strokeWidth = 7,
    );
    c.drawLine(
      const Offset(6, -19),
      Offset(9, -2 - stride),
      Paint()
        ..color = const Color(0xFF34453D)
        ..strokeWidth = 7,
    );
    polygon(c, const [
      Offset(-9, -37),
      Offset(8, -37),
      Offset(12, -23),
      Offset(4, -16),
      Offset(-8, -21),
    ], const Color(0xFFE0D8B8));
    polygon(c, const [
      Offset(-9, -37),
      Offset(-2, -32),
      Offset(-3, -18),
      Offset(-8, -21),
    ], const Color(0xFFA79C76));
    c.drawLine(
      const Offset(-8, -22),
      const Offset(9, -22),
      Paint()
        ..color = const Color(0xFF806B43)
        ..strokeWidth = 3,
    );
    c.drawCircle(
      const Offset(0, -44),
      8,
      Paint()..color = const Color(0xFFE4BE89),
    );
    polygon(c, const [
      Offset(-8, -44),
      Offset(-7, -51),
      Offset(0, -55),
      Offset(8, -50),
      Offset(8, -45),
      Offset(0, -48),
    ], const Color(0xFFC79F59));
    c.drawLine(
      const Offset(10, -32),
      Offset(14, -21 + stride),
      Paint()
        ..color = const Color(0xFFDAB783)
        ..strokeWidth = 5,
    );
    c.drawCircle(
      Offset(14, -20 + stride),
      2.7,
      Paint()..color = const Color(0xFFE4BE89),
    );
    c.drawLine(
      const Offset(-9, -31),
      Offset(-12, -20 - stride),
      Paint()
        ..color = const Color(0xFFDAB783)
        ..strokeWidth = 4,
    );
    c.restore();
  }

  void tiger(Canvas c) {
    final p = project(g.tiger), direction = project(g.tigerFacing);
    final moving = g.phase != EncounterPhase.feedback;
    final stride = moving ? math.sin(g.time * 11) * 5 : 0.0;
    c.drawOval(
      Rect.fromCenter(center: p + const Offset(0, 2), width: 90, height: 28),
      Paint()..color = const Color(0x66142620),
    );
    c.save();
    c.translate(p.dx, p.dy);
    c.scale(direction.dx >= 0 ? 1 : -1, 1);
    c.rotate(direction.dy.clamp(-1, 1) * .13);
    final tail =
        Path()
          ..moveTo(-29, -19)
          ..cubicTo(-48, -21, -45, -37, -58, -34 - math.sin(g.time * 2) * 3);
    c.drawPath(
      tail,
      Paint()
        ..color = const Color(0xFFD69442)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    c.drawLine(
      Offset(-54, -34 - math.sin(g.time * 2) * 3),
      Offset(-59, -34 - math.sin(g.time * 2) * 3),
      Paint()
        ..color = forestInk
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    for (final x in [-24.0, 20.0]) {
      c.drawLine(
        Offset(x, -16),
        Offset(x + stride, -1),
        Paint()
          ..color = const Color(0xFFB66F33)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round,
      );
    }
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-34, -38, 70, 29),
        const Radius.circular(14),
      ),
      Paint()..color = const Color(0xFFDC9845),
    );
    c.drawOval(
      const Rect.fromLTWH(-22, -24, 47, 16),
      Paint()..color = const Color(0xFFEED3A0),
    );
    for (final x in [-21.0, 23.0]) {
      c.drawLine(
        Offset(x, -20),
        Offset(x - stride, 4),
        Paint()
          ..color = const Color(0xFFE4A151)
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round,
      );
      c.drawLine(
        Offset(x - stride - 3, 4),
        Offset(x - stride + 4, 4),
        Paint()
          ..color = const Color(0xFFEED3A0)
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round,
      );
      c.drawLine(
        Offset(x - 3, -6),
        Offset(x + 3, -5),
        Paint()
          ..color = forestInk
          ..strokeWidth = 2,
      );
    }
    for (int i = 0; i < 6; i++) {
      final x = -26 + i * 9.0;
      polygon(c, [
        Offset(x, -37),
        Offset(x + 5, -37),
        Offset(x + 8, -26),
        Offset(x + 5, -16),
        Offset(x + 3, -27),
      ], const Color(0xFF2C3328));
    }
    c.drawCircle(
      const Offset(32, -35),
      17,
      Paint()..color = const Color(0xFFEBA34D),
    );
    c.drawCircle(const Offset(21, -47), 6, Paint()..color = forestInk);
    c.drawCircle(const Offset(36, -50), 5.5, Paint()..color = forestInk);
    c.drawCircle(
      const Offset(21, -47),
      2.7,
      Paint()..color = const Color(0xFFE8D1A2),
    );
    c.drawCircle(
      const Offset(36, -50),
      2.5,
      Paint()..color = const Color(0xFFE8D1A2),
    );
    c.drawOval(
      const Rect.fromLTWH(31, -33, 20, 12),
      Paint()..color = const Color(0xFFF1E5C1),
    );
    c.drawCircle(const Offset(48, -29), 3, Paint()..color = forestInk);
    c.drawOval(const Rect.fromLTWH(34, -40, 5, 3), Paint()..color = ivory);
    c.drawCircle(const Offset(37, -39), 1.4, Paint()..color = forestInk);
    c.drawLine(
      const Offset(27, -46),
      const Offset(30, -39),
      Paint()
        ..color = forestInk
        ..strokeWidth = 3,
    );
    c.drawLine(
      const Offset(18, -36),
      const Offset(25, -32),
      Paint()
        ..color = forestInk
        ..strokeWidth = 3,
    );
    c.drawLine(
      const Offset(19, -28),
      const Offset(26, -27),
      Paint()
        ..color = forestInk
        ..strokeWidth = 2.5,
    );
    c.drawLine(
      const Offset(41, -27),
      const Offset(49, -25),
      Paint()
        ..color = const Color(0x99695437)
        ..strokeWidth = .8,
    );
    c.restore();
  }

  void sign(Canvas c, Offset pos, int i) {
    final at = project(pos);
    c.drawLine(
      at,
      at - const Offset(0, 43),
      Paint()
        ..color = const Color(0xFF746A42)
        ..strokeWidth = 5,
    );
    polygon(c, [
      at + const Offset(-19, -48),
      at + const Offset(18, -48),
      at + const Offset(24, -39),
      at + const Offset(18, -31),
      at + const Offset(-19, -31),
    ], const Color(0xFFA69E66));
    final t = TextPainter(
      text: TextSpan(
        text: i == 0 ? g.text('trail') : '0${i + 1} →',
        style: TextStyle(
          color: forestInk,
          fontSize: 8,
          fontFamily: g.language == 'en' ? 'Inter' : 'NotoDevanagari',
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    t.paint(c, at - Offset(t.width / 2, 44));
    t.dispose();
  }

  @override
  bool shouldRepaint(covariant ForestPainter old) =>
      old.title != title || old.g != g;
}

class TrailMap extends CustomPainter {
  final ForestEngine g;
  TrailMap(this.g) : super(repaint: g);
  @override
  void paint(Canvas c, Size size) {
    final scale = math.min(size.width, size.height) / 2400;
    final origin = Offset(
      (size.width - 2200 * scale) / 2,
      (size.height - 2200 * scale) / 2,
    );
    Offset p(Offset v) => origin + v * scale;
    final paint = Paint();
    c.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      paint..color = const Color(0xFF163D30),
    );
    for (final pond in g.ponds) {
      c.drawOval(
        Rect.fromPoints(p(pond.topLeft), p(pond.bottomRight)),
        paint..color = const Color(0xFF527F71),
      );
    }
    final route = Path()..addPolygon(g.landmarks.map(p).toList(), true);
    c.drawPath(
      route,
      paint
        ..color = leaf.withValues(alpha: .5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    paint.style = PaintingStyle.fill;
    for (final l in g.landmarks) {
      c.drawCircle(p(l), 2.5, paint..color = leaf);
    }
    if (!g.journeyComplete) {
      c.drawCircle(p(g.destination), 6, paint..color = amber);
      c.drawCircle(
        p(g.destination),
        10,
        paint..color = amber.withValues(alpha: .2),
      );
    }
    if (g.hasTiger) {
      c.drawCircle(p(g.tiger), 3.5, paint..color = amber);
    }
    c.drawCircle(p(g.player), 7, paint..color = ivory.withValues(alpha: .15));
    c.drawCircle(p(g.player), 3, paint..color = ivory);
  }

  @override
  bool shouldRepaint(covariant TrailMap old) => true;
}
