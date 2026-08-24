import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../features/profile/profile.dart';
import '../../shared/shared.dart';

class WebHero extends StatelessWidget {
  const WebHero({
    super.key,
    required this.info,
    required this.experience,
    required this.story,
    required this.socials,
    required this.mycore,
    required this.onContactTap,
    required this.onWorkTap,
  });

  final Info info;
  final List<Experience> experience;
  final List<Story> story;
  final List<Social> socials;
  final List<MyCore> mycore;
  final VoidCallback onContactTap;
  final VoidCallback onWorkTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final viewport  = MediaQuery.sizeOf(context).height;
    final blurb     = webHeroBlurb(story);

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize      : MainAxisSize.min,
      children: [
        const WebAvailabilityBadge(),
        const SizedBox(height: 28),
        Text(
          webHelloLabel,
          style: AppStyle.label.copyWith(color: AppColors.accent),
        ),
        const SizedBox(height: 16),
        Text(
          info.name,
          style: AppStyle.headline1.copyWith(
            fontSize     : isDesktop ? 62 : 36,
            height       : 1.02,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.accent, AppColors.accentPurple],
            begin : Alignment.centerLeft,
            end   : Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            info.description,
            style: AppStyle.headline2.copyWith(
              color     : Colors.white,
              fontSize  : isDesktop ? 23 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (blurb.isNotEmpty) ...[
          const SizedBox(height: 22),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              blurb,
              style: AppStyle.bodyLarge.copyWith(
                color : AppColors.textSub,
                height: 1.8,
              ),
            ),
          ),
        ],
        const SizedBox(height: 36),
        Wrap(
          spacing   : 14,
          runSpacing: 14,
          children: [
            WebPrimaryButton(
              label    : webContactMe,
              icon     : Icons.arrow_forward,
              onPressed: onContactTap,
            ),
            WebGhostButton(
              label    : webViewWork,
              icon     : Icons.grid_view_rounded,
              onPressed: onWorkTap,
            ),
          ],
        ),
        const SizedBox(height: 40),
        WebHeroStats(experience: experience),
        if (socials.isNotEmpty) ...[
          const SizedBox(height: 34),
          WebSocialStrip(socials: socials),
        ],
      ],
    );

    final portrait = WebHeroPortrait(
      image : info.image,
      radius: isDesktop ? 140 : 96,
      mycore: mycore,
    );

    final body = isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 7, child: details),
              const SizedBox(width: 48),
              Expanded(flex: 5, child: Center(child: portrait)),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              details,
              const SizedBox(height: 48),
              Center(child: portrait),
            ],
          );

    return Stack(
      children: [
        const Positioned.fill(child: WebHeroBackground()),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: isDesktop ? (viewport - 8).clamp(620.0, 1000.0) : 0,
          ),
          child: Padding(
            padding: ResponsiveInsets.page(context).copyWith(
              top   : WebSection.navHeight + (isDesktop ? 56 : 48),
              bottom: isDesktop ? 96 : 64,
            ),
            child: Column(
              mainAxisAlignment : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [body],
            ),
          ),
        ),
        if (isDesktop)
          const Positioned(
            left  : 0,
            right : 0,
            bottom: 26,
            child : Center(child: WebScrollHint()),
          ),
      ],
    );
  }
}

class WebAvailabilityBadge extends StatelessWidget {
  const WebAvailabilityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color       : AppColors.bgTile,
        borderRadius: BorderRadius.circular(AppStyle.radiusFull),
        border      : Border.all(color: AppColors.tileBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width : 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color     : AppColors.success.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            webAvailable,
            style: AppStyle.bodySmall.copyWith(
              color     : AppColors.textPrimary,
              fontSize  : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Portrait ringed by an orbit: the core competency tags ride the circle
/// while a glowing arc traces the path between them.
class WebHeroPortrait extends StatefulWidget {
  const WebHeroPortrait({
    super.key,
    required this.image,
    required this.radius,
    required this.mycore,
  });

  final String image;
  final double radius;
  final List<MyCore> mycore;

  static const Duration orbitDuration = Duration(seconds: 24);
  static const Duration stormDuration = Duration(milliseconds: 2800);
  static const int maxOrbitTags       = 5;
  static const int stormBolts         = 3;

  @override
  State<WebHeroPortrait> createState() => _WebHeroPortraitState();
}

class _WebHeroPortraitState extends State<WebHeroPortrait>
    with TickerProviderStateMixin {
  late final AnimationController _orbit;
  late final AnimationController _storm;

  @override
  void initState() {
    super.initState();
    _orbit = AnimationController(
      vsync   : this,
      duration: WebHeroPortrait.orbitDuration,
    )..repeat();
    _storm = AnimationController(
      vsync   : this,
      duration: WebHeroPortrait.stormDuration,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Respect the viewer's reduced-motion preference.
    final still = MediaQuery.disableAnimationsOf(context);
    for (final controller in [_orbit, _storm]) {
      if (still) {
        controller.stop();
      } else if (!controller.isAnimating) {
        controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _orbit.dispose();
    _storm.dispose();
    super.dispose();
  }

  List<MyCore> get _tags {
    final items = widget.mycore
        .where((item) => item.name.trim().isNotEmpty)
        .toList();

    return items.length <= WebHeroPortrait.maxOrbitTags
        ? items
        : items.sublist(0, WebHeroPortrait.maxOrbitTags);
  }

  @override
  Widget build(BuildContext context) {
    final radius      = widget.radius;
    final frame       = radius * 2.5;
    final orbitRadius = frame / 2;
    final tags        = _tags;

    return SizedBox(
      width : frame,
      height: frame,
      child: Stack(
        alignment   : Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _orbit,
            builder: (context, child) => CustomPaint(
              size   : Size.square(frame),
              painter: WebOrbitPainter(
                progress: _orbit.value,
                tagCount: tags.length,
              ),
            ),
          ),
          Container(
            width : radius * 2.08,
            height: radius * 2.08,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.18),
              ),
            ),
          ),
          AppAvatar(imageUrl: widget.image, radius: radius),
          AnimatedBuilder(
            animation: _storm,
            builder: (context, child) => CustomPaint(
              size   : Size.square(frame),
              painter: WebLightningPainter(
                storm: _storm.value,
                bolts: WebHeroPortrait.stormBolts,
              ),
            ),
          ),
          ...List.generate(tags.length, (index) {
            final tag   = tags[index];
            final phase = index / tags.length;

            return AnimatedBuilder(
              animation: _orbit,
              builder: (context, child) {
                // Start upper-left, then travel clockwise around the ring.
                final angle =
                    (_orbit.value + phase) * 2 * math.pi +
                    WebOrbitPainter.leadAngle;

                // 0 at the top of the ring (far side), 1 at the bottom
                // (nearest the viewer): the tag grows and brightens as it
                // comes forward.
                final depth = (math.sin(angle) + 1) / 2;

                return Transform.translate(
                  offset: Offset(
                    math.cos(angle) * orbitRadius,
                    math.sin(angle) * orbitRadius,
                  ),
                  child: Transform.scale(
                    scale: 0.90 + depth * 0.14,
                    child: Opacity(
                      opacity: 0.74 + depth * 0.26,
                      child  : child,
                    ),
                  ),
                );
              },
              child: WebFloatingTag(label: tag.name, image: tag.image),
            );
          }),
        ],
      ),
    );
  }
}

/// Draws the orbit: a dashed technical track, a comet that sweeps the gap
/// between two tags, and the glowing head that leads it.
class WebOrbitPainter extends CustomPainter {
  const WebOrbitPainter({required this.progress, required this.tagCount});

  final double progress;
  final int tagCount;

  /// Where the first tag starts, so the painter and the tags stay in phase.
  static const double leadAngle = -math.pi * 0.85;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect   = Rect.fromCircle(center: center, radius: radius);

    final slots = tagCount < 1 ? 1 : tagCount;
    final gap   = 2 * math.pi / slots;

    // The bright crest rides the middle of the gap between two tags, so it is
    // never hidden behind one.
    final crest = progress * 2 * math.pi + leadAngle + gap / 2;

    // ── Bloom around the whole ring ─────────────────────────────
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 10
        ..color       = AppColors.accent.withValues(alpha: 0.17)
        ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, 13),
    );

    // ── The ring: lit the whole way round, brightest at the crest ──
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..shader = SweepGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.52),
            AppColors.accent.withValues(alpha: 0.74),
            AppColors.accent,
            AppColors.accent.withValues(alpha: 0.74),
            AppColors.accent.withValues(alpha: 0.52),
          ],
          stops    : const [0.0, 0.32, 0.5, 0.68, 1.0],
          transform: GradientRotation(crest - math.pi),
        ).createShader(rect),
    );

    // ── Extra bloom travelling with the crest ───────────────────
    canvas.drawArc(
      rect,
      crest - gap * 0.3,
      gap * 0.6,
      false,
      Paint()
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap   = StrokeCap.round
        ..color       = AppColors.accent.withValues(alpha: 0.26)
        ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // ── Crest node ──────────────────────────────────────────────
    final node = center +
        Offset(math.cos(crest) * radius, math.sin(crest) * radius);

    canvas.drawCircle(
      node,
      10,
      Paint()
        ..color      = AppColors.accent.withValues(alpha: 0.32)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(node, 3.4, Paint()..color = AppColors.accent);
    canvas.drawCircle(
      node,
      1.3,
      Paint()..color = AppColors.textPrimary.withValues(alpha: 0.92),
    );

    // ── Dashed halo drifting outside the lit ring ───────────────
    final haloRadius = radius * 1.085;
    _dashedCircle(
      canvas,
      Rect.fromCircle(center: center, radius: haloRadius),
      haloRadius,
      Paint()
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 1
        ..strokeCap   = StrokeCap.round
        ..color       = AppColors.tileBorder,
      dash  : 4,
      gap   : 11,
      offset: -progress * 2 * math.pi * 0.3,
    );
  }

  void _dashedCircle(
    Canvas canvas,
    Rect rect,
    double radius,
    Paint paint, {
    required double dash,
    required double gap,
    required double offset,
  }) {
    if (radius <= 0) return;

    final dashAngle = dash / radius;
    final gapAngle  = gap / radius;
    final step      = dashAngle + gapAngle;

    for (double angle = 0; angle < 2 * math.pi; angle += step) {
      canvas.drawArc(rect, offset + angle, dashAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WebOrbitPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.tagCount != tagCount;
  }
}

/// Electrical storm crackling along the orbit: short, irregular strikes that
/// hug the ring, each with a forked branch and a flash of bloom.
class WebLightningPainter extends CustomPainter {
  const WebLightningPainter({required this.storm, required this.bolts});

  /// Repeating 0..1 storm clock.
  final double storm;

  /// How many strike slots share the clock.
  final int bolts;

  /// Fraction of a cycle a single strike stays alive.
  static const double _life = 0.24;

  /// A slot below this threshold sits the round out, so strikes stay irregular.
  static const double _quiet = 0.30;

  static const int _segments  = 12;
  static const double _jitter = 15;

  @override
  void paint(Canvas canvas, Size size) {
    if (bolts < 1) return;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    if (radius <= 0) return;

    var flash = 0.0;

    for (var slot = 0; slot < bolts; slot++) {
      final raw   = storm + slot / bolts;
      final cycle = raw.floor();
      final t     = raw - cycle;
      if (t > _life) continue;

      // Irregular: some slots stay quiet on some rounds.
      if (_hash(cycle * 17 + slot * 3) < _quiet) continue;

      final intensity = _envelope(t / _life);
      if (intensity <= 0.02) continue;

      flash = math.max(flash, intensity);
      _drawBolt(canvas, center, radius, cycle * 31 + slot * 7, intensity);
    }

    if (flash > 0.02) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style       = PaintingStyle.stroke
          ..strokeWidth = 14
          ..color       = AppColors.accent.withValues(alpha: 0.24 * flash)
          ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }
  }

  /// Instant attack, flickering decay - the shape of a discharge.
  double _envelope(double phase) {
    final decay   = math.pow(1 - phase, 1.7).toDouble();
    final flicker = 0.7 + 0.3 * math.sin(phase * math.pi * 7);
    return (decay * flicker).clamp(0.0, 1.0);
  }

  void _drawBolt(
    Canvas canvas,
    Offset center,
    double radius,
    int seed,
    double intensity,
  ) {
    final span       = 0.7 + _hash(seed) * 0.7;
    final startAngle = _hash(seed + 1) * 2 * math.pi;
    final direction = _hash(seed + 2) > 0.5 ? 1.0 : -1.0;

    Offset pointAt(double angle, double offset) {
      final r = radius + offset;
      return center + Offset(math.cos(angle) * r, math.sin(angle) * r);
    }

    final points = <Offset>[];
    for (var step = 0; step <= _segments; step++) {
      final fraction = step / _segments;
      final angle    = startAngle + direction * span * fraction;
      // Taper to zero at both ends so the bolt melts back into the ring.
      final taper  = math.sin(fraction * math.pi);
      final offset = (_hash(seed * 13 + step) - 0.5) * 2 * _jitter * taper;
      points.add(pointAt(angle, offset));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    // Forked branches peeling off mid points.
    for (var fork = 0; fork < 2; fork++) {
      final index =
          2 + fork * 4 + (_hash(seed + 5 + fork) * 3).floor();
      if (index >= points.length - 1) continue;

      final baseAngle = startAngle + direction * span * (index / _segments);
      final outward   = _hash(seed + 6 + fork * 11) > 0.5 ? 1.0 : -1.0;
      final branch    = Path()
        ..moveTo(points[index].dx, points[index].dy);

      for (var step = 1; step <= 3; step++) {
        final key   = seed + fork * 100 + step;
        final angle = baseAngle +
            direction * 0.055 * step +
            (_hash(key + 30) - 0.5) * 0.05;
        final offset =
            outward * 7.5 * step + (_hash(key + 20) - 0.5) * 8;
        final tip = pointAt(angle, offset);
        branch.lineTo(tip.dx, tip.dy);
      }
      path.addPath(branch, Offset.zero);
    }

    void stroke(double width, Color color, {double? blur}) {
      final paint = Paint()
        ..style      = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap  = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color      = color;
      if (blur != null) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
      }
      canvas.drawPath(path, paint);
    }

    // Localized flash where the bolt lands.
    final strikePoint = points[points.length ~/ 2];
    canvas.drawCircle(
      strikePoint,
      42,
      Paint()
        ..color      = AppColors.accent.withValues(alpha: 0.20 * intensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 26),
    );

    stroke(
      14,
      AppColors.accent.withValues(alpha: 0.30 * intensity),
      blur: 14,
    );
    stroke(
      6,
      AppColors.accent.withValues(alpha: 0.55 * intensity),
      blur: 6,
    );
    stroke(2.8, AppColors.accent.withValues(alpha: 0.92 * intensity));
    stroke(
      1.2,
      AppColors.textPrimary.withValues(alpha: 0.95 * intensity),
    );

    // Sparks flung off the discharge.
    for (var spark = 0; spark < 3; spark++) {
      final anchor = points[1 + (_hash(seed + 40 + spark) * (_segments - 1)).floor()];
      final drift  = Offset(
        (_hash(seed + 50 + spark) - 0.5) * 22,
        (_hash(seed + 60 + spark) - 0.5) * 22,
      );
      canvas.drawCircle(
        anchor + drift,
        1.5,
        Paint()
          ..color = AppColors.textPrimary.withValues(alpha: 0.8 * intensity),
      );
    }
  }

  /// Deterministic 0..1 hash: the same seed always draws the same bolt, so a
  /// strike holds its shape for its whole life instead of buzzing randomly.
  static double _hash(int seed) {
    final value = math.sin(seed * 12.9898) * 43758.5453;
    return value - value.floorToDouble();
  }

  @override
  bool shouldRepaint(covariant WebLightningPainter oldDelegate) {
    return oldDelegate.storm != storm || oldDelegate.bolts != bolts;
  }
}

/// Small glass tag that floats beside the portrait.
class WebFloatingTag extends StatelessWidget {
  const WebFloatingTag({super.key, required this.label, required this.image});

  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyle.radiusFull),
        gradient: LinearGradient(
          begin : Alignment.topLeft,
          end   : Alignment.bottomRight,
          colors: [
            AppColors.card,
            AppColors.bgTile.withValues(alpha: 0.94),
          ],
        ),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color     : Colors.black.withValues(alpha: 0.55),
            blurRadius: 26,
            offset    : const Offset(0, 12),
          ),
          BoxShadow(
            color       : AppColors.accentGlow,
            blurRadius  : 20,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width  : 26,
            height : 26,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.bgDeep,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.22),
              ),
            ),
            child: Image(
              image: ApiImage.imageProviderFor(
                image,
                fallbackAsset: 'assets/icons/flutter.png',
              ),
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/icons/flutter.png');
              },
            ),
          ),
          const SizedBox(width: 11),
          Text(
            label.toUpperCase(),
            style: AppStyle.bodySmall.copyWith(
              color        : AppColors.textPrimary,
              fontFamily   : 'JetBrainsMono',
              fontSize     : 10,
              fontWeight   : FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class WebHeroStats extends StatelessWidget {
  const WebHeroStats({super.key, required this.experience});

  final List<Experience> experience;

  @override
  Widget build(BuildContext context) {
    final stats = buildExperienceStats(experience);

    return Wrap(
      spacing   : 12,
      runSpacing: 12,
      children: stats
          .map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical  : 14,
              ),
              decoration: BoxDecoration(
                color       : AppColors.card.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(AppStyle.radiusMd),
                border      : Border.all(color: AppColors.tileBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize      : MainAxisSize.min,
                children: [
                  Text(
                    item.data,
                    style: AppStyle.headline1.copyWith(
                      fontSize     : 24,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.title.toUpperCase(),
                    style: AppStyle.bodySmall.copyWith(
                      color        : AppColors.textSub,
                      fontFamily   : 'JetBrainsMono',
                      fontSize     : 9,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Social icons introduced by a small rule and label so they read as a set.
class WebSocialStrip extends StatelessWidget {
  const WebSocialStrip({super.key, required this.socials});

  final List<Social> socials;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 26, height: 1, color: AppColors.divider),
        const SizedBox(width: 12),
        Text(
          webFollowTitle.toUpperCase(),
          style: AppStyle.bodySmall.copyWith(
            color        : AppColors.textSub,
            fontFamily   : 'JetBrainsMono',
            fontSize     : 9,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(width: 18),
        WebSocialRow(socials: socials),
      ],
    );
  }
}

class WebSocialRow extends StatelessWidget {
  const WebSocialRow({super.key, required this.socials});

  final List<Social> socials;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing   : 12,
      runSpacing: 12,
      children: socials.map((item) => WebSocialDot(social: item)).toList(),
    );
  }
}

class WebSocialDot extends StatefulWidget {
  const WebSocialDot({super.key, required this.social});

  final Social social;

  @override
  State<WebSocialDot> createState() => _WebSocialDotState();
}

class _WebSocialDotState extends State<WebSocialDot> {
  bool _hovered = false;

  Future<void> _open() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!await ExternalLink.open(widget.social.socialUrl)) {
      messenger.showSnackBar(const SnackBar(content: Text(webLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.social.name,
      child: MouseRegion(
        cursor : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit : (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap   : _open,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width   : 42,
            height  : 42,
            padding : const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color       : _hovered ? AppColors.bgTile : Colors.transparent,
              borderRadius: BorderRadius.circular(AppStyle.radiusMd),
              border: Border.all(
                color: _hovered ? AppColors.accent : AppColors.tileBorder,
              ),
            ),
            child: Image(
              image: ApiImage.imageProviderFor(
                widget.social.icon,
                fallbackAsset: 'assets/icons/github.png',
              ),
              color: _hovered ? AppColors.accent : AppColors.textSub,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/icons/github.png',
                  color: _hovered ? AppColors.accent : AppColors.textSub,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class WebScrollHint extends StatefulWidget {
  const WebScrollHint({super.key});

  @override
  State<WebScrollHint> createState() => _WebScrollHintState();
}

class _WebScrollHintState extends State<WebScrollHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync   : this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          webScrollHint,
          style: AppStyle.bodySmall.copyWith(
            color        : AppColors.textSub,
            fontFamily   : 'JetBrainsMono',
            fontSize     : 9,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 8),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.25),
            end  : const Offset(0, 0.25),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
          child: const Icon(
            Icons.keyboard_arrow_down,
            size : 20,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}
