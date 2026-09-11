import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/colors.dart';

/// A viewport-sized night sky. Only the canvas repaints on animation ticks;
/// scrolling content and pointer events are independent of the decoration.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _motion;
  late final _AuroraPainter _painter;
  bool _reduceMotion = false;
  bool _visible = true;
  bool _active = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _active =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 36),
    );
    _painter = _AuroraPainter(_motion);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    _visible = TickerMode.valuesOf(context).enabled;
    _syncMotion();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    _syncMotion();
  }

  void _syncMotion() {
    if (_active && _visible && !_reduceMotion) {
      if (!_motion.isAnimating) _motion.repeat();
    } else {
      _motion.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _painter,
            willChange: _active && _visible && !_reduceMotion,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter(this.motion) : super(repaint: motion);

  final Animation<double> motion;
  static const _tau = math.pi * 2;
  static final List<_Star> _stars = _makeStars();
  final Paint _paint = Paint();
  _CurtainMesh? _mesh;

  static List<_Star> _makeStars() {
    final random = math.Random(42);
    return List.generate(220, (index) {
      return _Star(
        position: Offset(random.nextDouble(), random.nextDouble()),
        radius: 0.55 + random.nextDouble() * 0.8,
        phase: random.nextDouble() * _tau,
        speed: 2 + random.nextInt(4),
        sparkle: index % 19 == 0,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final bounds = Offset.zero & size;
    final time = motion.value * _tau;
    final compact = size.width < 650;

    canvas.save();
    canvas.clipRect(bounds);
    canvas.drawColor(AppColors.bgDeep, BlendMode.srcOver);

    _glow(
      canvas,
      bounds,
      Offset(size.width * 0.85, size.height * 0.18),
      size.longestSide * 0.65,
      AppColors.accentPurple,
      0.16,
    );
    _glow(
      canvas,
      bounds,
      Offset(size.width * 0.05, size.height * 0.8),
      size.longestSide * 0.5,
      AppColors.accent,
      0.1,
    );

    // Soft, translucent curtains with luminous folds. Vertex colors feather
    // both ends without full-screen blur filters or offscreen saveLayer calls.
    _curtain(
      canvas,
      size,
      time,
      base: 0.23,
      slope: -0.16,
      depth: 0.38,
      phase: 0.2,
      opacity: compact ? 0.85 : 1.0,
      colors: const [
        AppColors.accentCyan,
        AppColors.accent,
        AppColors.accentPurple,
      ],
    );
    _curtain(
      canvas,
      size,
      time,
      base: 0.36,
      slope: -0.2,
      depth: 0.3,
      phase: 2.4,
      opacity: 0.85,
      colors: const [
        AppColors.accentPurple,
        AppColors.accentPurple,
        AppColors.secondary,
      ],
    );
    _curtain(
      canvas,
      size,
      time,
      base: 0.91,
      slope: -0.12,
      depth: 0.28,
      phase: 4.1,
      opacity: compact ? 0.55 : 0.68,
      colors: const [
        AppColors.accentPurple,
        AppColors.accent,
        AppColors.accentCyan,
      ],
    );

    // Leave a calm navy area behind the main copy and cards.
    _glow(
      canvas,
      bounds,
      Offset(size.width * 0.4, size.height * 0.52),
      size.longestSide * 0.57,
      AppColors.bgDeep,
      0.56,
    );

    // Stars are painted last so white points remain visible over the aurora.
    final count = (size.width * size.height / 8600).round().clamp(60, 220);
    _paint.shader = null;
    for (final star in _stars.take(count)) {
      final twinkle = 0.5 + 0.5 * math.sin(time * star.speed + star.phase);
      final position = Offset(
        star.position.dx * size.width + math.sin(time + star.phase) * 3,
        star.position.dy * size.height + math.cos(time + star.phase) * 4,
      );
      final alpha = 0.42 + twinkle * 0.46;
      if (star.sparkle) {
        _glow(
          canvas,
          Rect.fromCircle(center: position, radius: 7),
          position,
          7,
          Colors.white,
          0.12 + twinkle * 0.08,
        );
        _paint
          ..shader = null
          ..color = Colors.white.withValues(alpha: alpha * 0.45)
          ..strokeWidth = 0.65;
        final reach = 2.2 + twinkle * 1.3;
        canvas.drawLine(
          position - Offset(reach, 0),
          position + Offset(reach, 0),
          _paint,
        );
        canvas.drawLine(
          position - Offset(0, reach),
          position + Offset(0, reach),
          _paint,
        );
      }
      _paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(position, star.radius, _paint);
    }
    canvas.restore();
  }

  void _glow(
    Canvas canvas,
    Rect bounds,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    _paint.shader = RadialGradient(
      colors: [
        color.withValues(alpha: opacity),
        color.withValues(alpha: 0),
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(bounds, _paint);
    _paint.shader = null;
  }

  void _curtain(
    Canvas canvas,
    Size size,
    double time, {
    required double base,
    required double slope,
    required double depth,
    required double phase,
    required double opacity,
    required List<Color> colors,
  }) {
    final columns = size.width < 650 ? 56 : 88;
    const rows = 18;
    if (_mesh?.columns != columns) _mesh = _CurtainMesh(columns, rows);
    final mesh = _mesh!;
    final height = size.height.clamp(500.0, 1100.0);

    for (var x = 0; x <= columns; x++) {
      final u = x / columns;
      final wave =
          math.sin(u * 5.2 + time + phase) * 0.065 +
          math.sin(u * 10.4 - time + phase) * 0.024;
      final edge = size.height * base + height * (slope * u + wave);
      final spread =
          height * depth * (0.78 + 0.22 * math.sin(u * 6 + time + phase));
      final fold = 0.73 + 0.27 * math.sin(u * 19 + time * 2 + phase);
      final tint = u < 0.5
          ? Color.lerp(colors[0], colors[1], u * 2)!
          : Color.lerp(colors[1], colors[2], (u - 0.5) * 2)!;
      final endFade = math.pow(math.sin(u * math.pi), 0.45).toDouble();

      for (var y = 0; y <= rows; y++) {
        final v = y / rows;
        // A broad veil and a brighter, narrow fold toward its lower edge.
        final veil = math.pow(math.sin(v * math.pi), 2) * 0.13;
        final ridge = math.exp(-math.pow((v - 0.72) / 0.14, 2)) * 0.32;
        final fade = y == 0 || y == rows ? 0.0 : (veil + ridge);
        final index = x * (rows + 1) + y;
        mesh.positions[index * 2] =
            (u * 1.16 - 0.08) * size.width +
            math.sin(v * 2.8 + u * 7 + time + phase) * height * 0.025 * v;
        mesh.positions[index * 2 + 1] = edge + (v - 0.72) * spread;
        mesh.colors[index] = tint
            .withValues(
              alpha: (fade * fold * endFade * opacity).clamp(0.0, 1.0),
            )
            .toARGB32();
      }
    }

    final vertices = ui.Vertices.raw(
      ui.VertexMode.triangles,
      mesh.positions,
      colors: mesh.colors,
      indices: mesh.indices,
    );
    _paint
      ..shader = null
      ..color = Colors.white;
    canvas.drawVertices(vertices, BlendMode.modulate, _paint);
    vertices.dispose();
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) =>
      oldDelegate.motion != motion;
}

/// Reuse the buffers and triangle topology across curtains and frames.
class _CurtainMesh {
  _CurtainMesh(this.columns, int rows)
    : positions = Float32List((columns + 1) * (rows + 1) * 2),
      colors = Int32List((columns + 1) * (rows + 1)),
      indices = Uint16List(columns * rows * 6) {
    var index = 0;
    for (var x = 0; x < columns; x++) {
      for (var y = 0; y < rows; y++) {
        final a = x * (rows + 1) + y;
        final b = a + rows + 1;
        for (final vertex in [a, b, a + 1, a + 1, b, b + 1]) {
          indices[index++] = vertex;
        }
      }
    }
  }

  final int columns;
  final Float32List positions;
  final Int32List colors;
  final Uint16List indices;
}

class _Star {
  const _Star({
    required this.position,
    required this.radius,
    required this.phase,
    required this.speed,
    required this.sparkle,
  });

  final Offset position;
  final double radius;
  final double phase;
  final int speed;
  final bool sparkle;
}
