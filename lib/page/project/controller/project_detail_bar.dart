import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../shared/shared.dart';
import '../../../web/controller/web_buttons.dart';
import '../../../web/controller/web_section.dart';
import '../../../web/model/web_text.dart';
import '../model/project_model.dart';

/// Sticky header for the case study on tablet and desktop. It mirrors the
/// site navigation bar — same height, blur, and reading-progress rule — so a
/// detail page never feels like a different product.
class ProjectDetailBar extends StatelessWidget {
  const ProjectDetailBar({
    super.key,
    required this.scrolled,
    required this.progress,
    required this.onBrandTap,
    required this.onBackToWork,
  });

  final bool scrolled;
  final double progress;
  final VoidCallback onBrandTap;
  final VoidCallback onBackToWork;

  @override
  Widget build(BuildContext context) {
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
                      ProjectBrandMark(onTap: onBrandTap),
                      const Spacer(),
                      WebGhostButton(
                        label: projectBackToWork,
                        icon: Icons.arrow_back,
                        dense: true,
                        onPressed: onBackToWork,
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

/// The `<> PORTFOLIO` lockup shared with the site navigation bar.
class ProjectBrandMark extends StatelessWidget {
  const ProjectBrandMark({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppStyle.radiusSm),
                border: Border.all(color: AppColors.accent, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Text(
                '<>',
                style: AppStyle.label.copyWith(
                  color: AppColors.accent,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.accent, AppColors.accentPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                webBrand,
                style: AppStyle.headline1.copyWith(
                  fontSize: context.isDesktop ? 19 : 16,
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
