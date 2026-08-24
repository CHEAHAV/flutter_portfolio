import 'package:flutter/material.dart';
import '../../shared/shared.dart';

/// Filled accent call to action.
class WebPrimaryButton extends StatefulWidget {
  const WebPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.dense = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool dense;

  @override
  State<WebPrimaryButton> createState() => _WebPrimaryButtonState();
}

class _WebPrimaryButtonState extends State<WebPrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding : EdgeInsets.symmetric(
            horizontal: widget.dense ? 20 : 28,
            vertical  : widget.dense ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color       : _hovered ? AppColors.accentDim : AppColors.accent,
            borderRadius: BorderRadius.circular(AppStyle.radiusFull),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(
                  alpha: _hovered ? 0.45 : 0.22,
                ),
                blurRadius: _hovered ? 26 : 16,
                offset    : const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppStyle.bodyMedium.copyWith(
                  color        : AppColors.bgDeep,
                  fontWeight   : FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 10),
                Icon(widget.icon, size: 14, color: AppColors.bgDeep),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined secondary action.
class WebGhostButton extends StatefulWidget {
  const WebGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.dense = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool dense;

  @override
  State<WebGhostButton> createState() => _WebGhostButtonState();
}

class _WebGhostButtonState extends State<WebGhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovered ? AppColors.accent : AppColors.textPrimary;

    return MouseRegion(
      cursor : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding : EdgeInsets.symmetric(
            horizontal: widget.dense ? 20 : 28,
            vertical  : widget.dense ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color       : _hovered ? AppColors.bgTile : Colors.transparent,
            borderRadius: BorderRadius.circular(AppStyle.radiusFull),
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.tileBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppStyle.bodyMedium.copyWith(
                  color     : color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 10),
                Icon(widget.icon, size: 14, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline text link with a trailing icon.
class WebTextLink extends StatefulWidget {
  const WebTextLink({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.arrow_forward,
    this.mono = false,
    this.color,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final bool mono;
  final Color? color;

  @override
  State<WebTextLink> createState() => _WebTextLinkState();
}

class _WebTextLinkState extends State<WebTextLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final base  = widget.color ?? AppColors.textPrimary;
    final color = _hovered ? AppColors.accent : base;

    return MouseRegion(
      cursor : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : widget.onTap,
        child: Column(
          mainAxisSize      : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: widget.mono
                        ? AppStyle.label.copyWith(color: color)
                        : AppStyle.bodyMedium.copyWith(
                            color     : color,
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  offset  : _hovered ? const Offset(0.25, 0) : Offset.zero,
                  child   : Icon(widget.icon, size: 14, color: color),
                ),
              ],
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height  : 1,
              width   : _hovered ? widget.label.length * 7.0 : 0,
              color   : AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
