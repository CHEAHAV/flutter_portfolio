import 'package:flutter/material.dart';
import '../../shared/shared.dart';

/// Faint blueprint grid plus an accent bloom, drawn behind the hero so the
/// first screen has depth instead of a flat fill.
class WebHeroBackground extends StatelessWidget {
  const WebHeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _HeroBackgroundPainter()),
    );
  }
}

class _HeroBackgroundPainter extends CustomPainter {
  static const double _cell = 64;

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.16),
          AppColors.accent.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.76, size.height * 0.34),
          radius: size.width * 0.34,
        ),
      );
    canvas.drawRect(Offset.zero & size, glow);

    final bloom = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentPurple.withValues(alpha: 0.10),
          AppColors.accentPurple.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.04, size.height * 0.86),
          radius: size.width * 0.30,
        ),
      );
    canvas.drawRect(Offset.zero & size, bloom);

    final line = Paint()
      ..color = AppColors.tileBorder.withValues(alpha: 0.34)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += _cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y <= size.height; y += _cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }

    final fade = Paint()
      ..shader = LinearGradient(
        begin : Alignment.topCenter,
        end   : Alignment.bottomCenter,
        colors: [
          AppColors.bgDeep.withValues(alpha: 0.0),
          AppColors.bgDeep.withValues(alpha: 0.65),
          AppColors.bgDeep,
        ],
        stops: const [0.45, 0.82, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, fade);
  }

  @override
  bool shouldRepaint(covariant _HeroBackgroundPainter oldDelegate) => false;
}
