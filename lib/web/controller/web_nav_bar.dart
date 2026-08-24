import 'dart:ui';
import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../shared/shared.dart';

class WebNavBar extends StatelessWidget {
  const WebNavBar({
    super.key,
    required this.activeAnchor,
    required this.onNavigate,
    required this.contactme,
    required this.scrolled,
    required this.progress,
  });

  final WebAnchor activeAnchor;
  final ValueChanged<WebAnchor> onNavigate;
  final List<ContactMe> contactme;
  final bool scrolled;
  final double progress;

  Future<void> _openEmail(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    for (final item in contactme) {
      if (webIsEmailContact(item) &&
          item.effectiveContactUrl.trim().isNotEmpty) {
        if (await ExternalLink.open(item.effectiveContactUrl)) return;
        break;
      }
    }

    messenger.showSnackBar(const SnackBar(content: Text(webLinkError)));
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: scrolled ? 18 : 0,
          sigmaY: scrolled ? 18 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: scrolled
                ? AppColors.bgDeep.withValues(alpha: 0.86)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: scrolled ? AppColors.divider : Colors.transparent,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: WebSection.navHeight,
                child: Padding(
                  padding: ResponsiveInsets.page(context),
                  child: Row(
                    children: [
                      _WebBrand(onTap: () => onNavigate(WebAnchor.home)),
                      Expanded(
                        child: FittedBox(
                          fit      : BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: webNavItems
                                .map(
                                  (item) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 15 : 9,
                                    ),
                                    child: WebNavLink(
                                      label   : item.label,
                                      selected: item.anchor == activeAnchor,
                                      onTap   : () => onNavigate(item.anchor),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip  : webEmailTooltip,
                        onPressed: () => _openEmail(context),
                        icon: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.accent, AppColors.accentPurple],
                            begin : Alignment.topLeft,
                            end   : Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Icon(Icons.email_outlined, size: 20),
                        ),
                      ),
                      const SizedBox(width: 6),
                      WebPrimaryButton(
                        label    : webResume,
                        dense    : true,
                        onPressed: () => onNavigate(WebAnchor.career),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.accentDim, AppColors.accent],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebBrand extends StatelessWidget {
  const _WebBrand({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width : 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppStyle.radiusSm),
                border      : Border.all(color: AppColors.accent, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color     : AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Text(
                '<>',
                style: AppStyle.label.copyWith(
                  color   : AppColors.accent,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.accent, AppColors.accentPurple],
                begin : Alignment.topLeft,
                end   : Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                webBrand,
                style: AppStyle.headline1.copyWith(
                  fontSize     : context.isDesktop ? 19 : 16,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebNavLink extends StatefulWidget {
  const WebNavLink({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<WebNavLink> createState() => _WebNavLinkState();
}

class _WebNavLinkState extends State<WebNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovered;

    return MouseRegion(
      cursor : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: AppStyle.bodyMedium.copyWith(
                color     : active ? AppColors.textPrimary : AppColors.textSub,
                fontWeight: widget.selected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
              child: Text(widget.label),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve   : Curves.easeOutCubic,
              height  : 2,
              width   : widget.selected ? widget.label.length * 8.0 : 0,
              decoration: BoxDecoration(
                color       : AppColors.accent,
                borderRadius: BorderRadius.circular(2),
                boxShadow: widget.selected
                    ? [
                        BoxShadow(
                          color     : AppColors.accent.withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ]
                    : const [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
