import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../shared/shared.dart';
import '../../../web/model/web_text.dart';

/// Compact project row for the phone layout. The thumbnail alternates sides
/// the way the desktop case study rows do, so a small screen keeps the same
/// zigzag rhythm as the website.
class ProjectRowCard extends StatefulWidget {
  const ProjectRowCard({
    super.key,
    required this.project,
    required this.index,
    required this.onTap,
    this.flipped,
  });

  final Project project;
  final int index;
  final VoidCallback onTap;

  /// Overrides the automatic left/right alternation driven by [index].
  final bool? flipped;

  @override
  State<ProjectRowCard> createState() => _ProjectRowCardState();
}

class _ProjectRowCardState extends State<ProjectRowCard> {
  static const double _thumbSize = 104;

  bool _pressed = false;
  bool _hovered = false;

  bool get _active => _pressed || _hovered;

  @override
  Widget build(BuildContext context) {
    final imageOnRight = widget.flipped ?? widget.index.isOdd;

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageOnRight
          ? [Expanded(child: _details()), const SizedBox(width: 16), _thumb()]
          : [_thumb(), const SizedBox(width: 16), Expanded(child: _details())],
    );

    return Semantics(
      button: true,
      label: widget.project.name,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            scale: _pressed ? 0.98 : 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppStyle.radiusLg + 2),
                border: Border.all(
                  color: _active ? AppColors.accent : AppColors.divider,
                ),
                // Ambient spread, a tighter contact shadow, and an accent
                // bloom while the row is held.
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.34),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                    spreadRadius: -8,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                    spreadRadius: -2,
                  ),
                  if (_active)
                    BoxShadow(
                      color: AppColors.accentGlow,
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                      spreadRadius: -6,
                    ),
                ],
              ),
              child: row,
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumb() {
    final radius = BorderRadius.circular(AppStyle.radiusMd + 2);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        // Lifts the artwork off the card so it reads as a physical tile.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 18,
            offset: const Offset(0, 9),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: _active ? 0.3 : 0.1),
            blurRadius: 22,
            offset: const Offset(0, 6),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          width: _thumbSize,
          height: _thumbSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOut,
                scale: _active ? 1.06 : 1,
                child: Image(
                  image: ApiImage.imageProviderFor(
                    widget.project.image,
                    fallbackAsset: 'assets/images/computer.png',
                  ),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/computer.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bgDeep.withValues(alpha: 0.06),
                      AppColors.bgDeep.withValues(alpha: 0.42),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _details() {
    final tags = webProjectTags(widget.project);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              webIndexLabel(widget.index),
              style: AppStyle.label.copyWith(
                color: AppColors.accent,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            if (tags.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: AppColors.textSub,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tags.first.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodySmall.copyWith(
                    color: AppColors.textSub,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppStyle.bodyLarge.copyWith(
            color: _active ? AppColors.accent : AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
          child: Text(
            widget.project.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.project.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodyMedium.copyWith(
            color: AppColors.textSub,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
