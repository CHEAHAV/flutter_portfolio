import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../shared/shared.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({
    super.key,
    required this.info,
    required this.socials,
    required this.contactme,
    required this.onNavigate,
    required this.onBackToTop,
  });

  final Info? info;
  final List<Social> socials;
  final List<ContactMe> contactme;
  final ValueChanged<WebAnchor> onNavigate;
  final VoidCallback onBackToTop;

  Future<void> _open(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    if (!await ExternalLink.open(url)) {
      messenger.showSnackBar(const SnackBar(content: Text(webLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final name      = info?.name ?? '';

    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize      : MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.accent, AppColors.accentPurple],
            begin : Alignment.topLeft,
            end   : Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            webBrand,
            style: AppStyle.headline1.copyWith(
              fontSize     : 18,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            info?.description ?? '',
            style: AppStyle.bodyMedium.copyWith(height: 1.7),
          ),
        ),
        if (socials.isNotEmpty) ...[
          const SizedBox(height: 20),
          WebSocialRow(socials: socials),
        ],
      ],
    );

    final navigate = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize      : MainAxisSize.min,
      children: [
        Text(
          webFooterLinks.toUpperCase(),
          style: AppStyle.label.copyWith(
            color        : AppColors.textPrimary,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 18),
        ...webNavItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WebTextLink(
              label: item.label,
              icon : Icons.chevron_right,
              color: AppColors.textSub,
              onTap: () => onNavigate(item.anchor),
            ),
          ),
        ),
      ],
    );

    final reach = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize      : MainAxisSize.min,
      children: [
        Text(
          webFooterReach.toUpperCase(),
          style: AppStyle.label.copyWith(
            color        : AppColors.textPrimary,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 18),
        ...contactme.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WebTextLink(
              label: item.description,
              icon : Icons.north_east,
              color: AppColors.textSub,
              onTap: () => _open(context, item.effectiveContactUrl),
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color : AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: ResponsiveInsets.page(context).copyWith(top: 56, bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: brand),
                  const SizedBox(width: 40),
                  Expanded(flex: 3, child: navigate),
                  const SizedBox(width: 40),
                  Expanded(flex: 4, child: reach),
                ],
              )
            else ...[
              brand,
              const SizedBox(height: 36),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: navigate),
                  const SizedBox(width: 24),
                  Expanded(child: reach),
                ],
              ),
            ],
            const SizedBox(height: 44),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '© ${DateTime.now().year} $name. $webFooterNote',
                    style: AppStyle.bodySmall.copyWith(
                      color: AppColors.textSub,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                WebTextLink(
                  label: webBackToTop,
                  icon : Icons.arrow_upward,
                  color: AppColors.textSub,
                  onTap: onBackToTop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
