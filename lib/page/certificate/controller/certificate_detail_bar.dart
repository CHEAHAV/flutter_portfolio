import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../shared/shared.dart';
import '../../../web/controller/web_buttons.dart';
import '../../../web/controller/web_section.dart';
import '../../project/controller/project_detail_bar.dart' show ProjectBrandMark;
import '../model/certificate_detail_model.dart';

/// Sticky header for the credential page on tablet and desktop — the same
/// height, blur, and reading-progress rule as the case-study header, so a
/// certificate detail page reads as part of the same site.
class CertificateDetailBar extends StatelessWidget {
  const CertificateDetailBar({
    super.key,
    required this.scrolled,
    required this.progress,
    required this.onBrandTap,
    required this.onBack,
  });

  final bool scrolled;
  final double progress;
  final VoidCallback onBrandTap;
  final VoidCallback onBack;

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
                        label: certificateBackAction,
                        icon: Icons.arrow_back,
                        dense: true,
                        onPressed: onBack,
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
