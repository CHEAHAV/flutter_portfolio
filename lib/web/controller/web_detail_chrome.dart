import 'package:flutter/material.dart';

import '../../shared/shared.dart';
import '../model/web_text.dart' show webBackToTop, webFooterNote;
import 'web_buttons.dart';

/// `{Root} / {name}` trail that keeps a deep link on a detail page oriented
/// — the case-study page, the credential page, or any future one.
class DetailBreadcrumb extends StatelessWidget {
  const DetailBreadcrumb({
    super.key,
    required this.rootLabel,
    required this.name,
    this.onRootTap,
  });

  final String rootLabel;
  final String name;
  final VoidCallback? onRootTap;

  @override
  Widget build(BuildContext context) {
    final root = Text(
      rootLabel,
      style: AppStyle.bodySmall.copyWith(color: AppColors.textSub),
    );

    return Row(
      children: [
        if (onRootTap == null)
          root
        else
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRootTap,
              child: root,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '/',
            style: AppStyle.bodySmall.copyWith(color: AppColors.tileBorder),
          ),
        ),
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Closing rule with the site note and a jump back to the top, shared by
/// every detail page.
class DetailFooterStrip extends StatelessWidget {
  const DetailFooterStrip({super.key, this.onBackToTop});

  final VoidCallback? onBackToTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 20,
        runSpacing: 14,
        children: [
          Text(
            webFooterNote,
            style: AppStyle.bodySmall.copyWith(color: AppColors.textSub),
          ),
          if (onBackToTop != null)
            WebTextLink(
              label: webBackToTop,
              icon: Icons.arrow_upward,
              color: AppColors.textSub,
              onTap: onBackToTop!,
            ),
        ],
      ),
    );
  }
}
