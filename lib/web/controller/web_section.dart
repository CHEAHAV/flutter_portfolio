import 'package:flutter/material.dart';
import '../../shared/shared.dart';

/// Vertical rhythm shared by every band of the site, plus the anchor padding
/// that keeps a scrolled-to heading clear of the sticky navigation bar.
class WebSection extends StatelessWidget {
  const WebSection({
    super.key,
    required this.child,
    this.background,
    this.selectable = true,
    this.topPadding,
    this.bottomPadding,
  });

  final Widget child;
  final Color? background;
  final bool selectable;
  final double? topPadding;
  final double? bottomPadding;

  static const double navHeight = 72;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final content   = Padding(
      padding: ResponsiveInsets.page(context).copyWith(
        top   : topPadding ?? (isDesktop ? 110 : 80),
        bottom: bottomPadding ?? (isDesktop ? 110 : 80),
      ),
      child: child,
    );

    return Container(
      width : double.infinity,
      color : background,
      child : selectable ? SelectionArea(child: content) : content,
    );
  }
}

/// Eyebrow label, headline and optional lead paragraph.
class WebHeading extends StatelessWidget {
  const WebHeading({
    super.key,
    required this.label,
    required this.title,
    this.lead,
    this.trailing,
    this.center = false,
  });

  final String label;
  final String title;
  final String? lead;
  final Widget? trailing;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final align     = center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    final heading = Column(
      crossAxisAlignment: align,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width : 22,
              height: 1,
              color : AppColors.accent,
            ),
            const SizedBox(width: 10),
            Text(
              label.replaceAll('// ', '').toUpperCase(),
              style: AppStyle.label.copyWith(
                color        : AppColors.accent,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: AppStyle.headline1.copyWith(
            fontSize     : isDesktop ? 38 : 28,
            height       : 1.15,
            letterSpacing: -0.8,
          ),
        ),
        if (lead != null) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              lead!,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: AppStyle.bodyLarge.copyWith(
                color : AppColors.textSub,
                height: 1.7,
              ),
            ),
          ),
        ],
      ],
    );

    if (trailing == null) return heading;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: heading),
        const SizedBox(width: 24),
        trailing!,
      ],
    );
  }
}

/// Small bordered pill used for tech labels.
class WebChip extends StatelessWidget {
  const WebChip({super.key, required this.label, this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color       : filled ? AppColors.bgTile : Colors.transparent,
        borderRadius: BorderRadius.circular(AppStyle.radiusFull),
        border      : Border.all(color: AppColors.tileBorder),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppStyle.bodySmall.copyWith(
          color        : AppColors.textSub,
          fontFamily   : 'JetBrainsMono',
          fontSize     : 10,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// Card surface used across the site so every panel shares one elevation.
class WebCard extends StatelessWidget {
  const WebCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.color,
    this.hovered = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding : padding,
      decoration: BoxDecoration(
        color       : color ?? AppColors.card,
        borderRadius: BorderRadius.circular(AppStyle.radiusLg),
        border: Border.all(
          color: hovered ? AppColors.accent : AppColors.divider,
        ),
        boxShadow: [
          BoxShadow(
            color: hovered
                ? AppColors.accentGlow
                : Colors.black.withValues(alpha: 0.3),
            blurRadius: hovered ? 28 : 20,
            offset    : const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Fades and lifts its child the first time it scrolls into the viewport.
class WebReveal extends StatefulWidget {
  const WebReveal({
    super.key,
    required this.controller,
    required this.child,
    this.delay = Duration.zero,
  });

  final ScrollController controller;
  final Widget child;
  final Duration delay;

  @override
  State<WebReveal> createState() => _WebRevealState();
}

class _WebRevealState extends State<WebReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_visible || !mounted) return;

    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;

    final top      = box.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top > viewport * 0.94) return;

    widget.controller.removeListener(_check);
    if (widget.delay == Duration.zero) {
      setState(() => _visible = true);
      return;
    }
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 520),
      curve   : Curves.easeOutCubic,
      offset  : _visible ? Offset.zero : const Offset(0, 0.06),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 520),
        curve   : Curves.easeOut,
        opacity : _visible ? 1 : 0,
        child   : widget.child,
      ),
    );
  }
}
