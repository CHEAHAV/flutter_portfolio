import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/style.dart';
import '../theme/colors.dart';
import '../utils/external_link.dart';

/// The titled card used throughout case-study / detail pages (skills, core
/// competencies, …) for one section of the layout.
class DetailPanel extends StatelessWidget {
  const DetailPanel({super.key, required this.child, this.accented = false});

  final Widget child;
  final bool accented;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: accented ? const Color(0xFF10233C) : AppColors.bgCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: accented ? const Color(0xFF21485F) : AppColors.tileBorder,
      ),
    ),
    child: child,
  );
}

/// A small icon + eyebrow label heading a [DetailPanel]'s section.
class DetailSectionLabel extends StatelessWidget {
  const DetailSectionLabel({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: AppColors.accentGlow, blurRadius: 10, spreadRadius: 1),
          ],
        ),
        child: Icon(icon, color: AppColors.accent, size: 19),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: AppStyle.label.copyWith(
            fontSize: 11,
            color: AppColors.textSub,
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}

/// A rounded pill, used for categories and "common uses" chips.
class DetailTag extends StatelessWidget {
  const DetailTag({super.key, required this.label, this.accented = false});

  final String label;
  final bool accented;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: accented
          ? AppColors.accent.withValues(alpha: 0.08)
          : AppColors.bgTile,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: accented
            ? AppColors.accent.withValues(alpha: 0.2)
            : AppColors.tileBorder,
      ),
    ),
    child: Text(
      label,
      style: AppStyle.bodySmall.copyWith(
        color: accented ? AppColors.accent : const Color(0xFFAFBCD2),
        height: 1.4,
      ),
    ),
  );
}

/// An icon-tile fact row: a short label over a value, used for the small
/// details beside a case study, credential, or competency (duration, role,
/// credential ID, issuer, …).
class DetailFactRow extends StatelessWidget {
  const DetailFactRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
  });

  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.bgTile,
            borderRadius: BorderRadius.circular(AppStyle.radiusMd),
            border: Border.all(color: AppColors.tileBorder),
          ),
          child: Icon(icon, size: 18, color: AppColors.accent),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: AppStyle.bodySmall.copyWith(
                  color: AppColors.textSub,
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: AppStyle.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A panel offering the official website for a skill or core competency:
/// validates the URL, opens it externally, and falls back to a
/// copy-to-clipboard snack bar when the launcher fails.
class OfficialWebsitePanel extends StatelessWidget {
  const OfficialWebsitePanel({
    super.key,
    required this.name,
    required this.officialUrl,
    required this.noLinkMessage,
    this.openWebsite,
    this.sectionIcon = Icons.language_rounded,
    this.sectionLabel = 'OFFICIAL RESOURCE',
    this.headingPrefix = 'Explore',
    this.availableMessage = 'Learn more from the official source.',
    this.ctaIcon = Icons.open_in_new_rounded,
    this.ctaLabel = 'Official website',
  });

  /// Shown as "{headingPrefix} {name}".
  final String name;

  /// Already-resolved URL (backend value or catalog fallback), or null/blank
  /// when none is available.
  final String? officialUrl;

  /// Shown in place of the button when no valid link is available.
  final String noLinkMessage;

  final Future<bool> Function(String)? openWebsite;

  final IconData sectionIcon;
  final String sectionLabel;
  final String headingPrefix;
  final String availableMessage;
  final IconData ctaIcon;
  final String ctaLabel;

  String? get _url {
    final value = officialUrl?.trim();
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      return null;
    }
    return value;
  }

  Future<void> _open(BuildContext context) async {
    final url = _url!;
    try {
      if (await (openWebsite ?? ExternalLink.open)(url)) return;
    } catch (_) {
      // Unsupported platforms and launcher errors share the same recovery path.
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Could not open the website. You can copy the link and open it in your browser.',
        ),
        action: SnackBarAction(
          label: 'Copy link',
          onPressed: () => Clipboard.setData(ClipboardData(text: url)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = _url;
    return DetailPanel(
      accented: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailSectionLabel(icon: sectionIcon, text: sectionLabel),
          const SizedBox(height: 18),
          Text('$headingPrefix $name', style: AppStyle.headline3),
          const SizedBox(height: 10),
          Text(
            url == null ? noLinkMessage : availableMessage,
            style: AppStyle.bodyMedium.copyWith(color: const Color(0xFFAFBCD2)),
          ),
          if (url != null) ...[
            const SizedBox(height: 18),
            Text(
              Uri.parse(url).host.replaceFirst(RegExp(r'^www\.'), ''),
              style: AppStyle.bodyMedium.copyWith(color: AppColors.accent),
            ),
            const SizedBox(height: 18),
            Tooltip(
              message: '$url (opens in a new tab)',
              child: FilledButton.icon(
                onPressed: () => _open(context),
                icon: Icon(ctaIcon, size: 18),
                label: Text(ctaLabel, textAlign: TextAlign.center),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bgDeep,
                  minimumSize: const Size(48, 52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  textStyle: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Opens in a new tab',
              textAlign: TextAlign.center,
              style: AppStyle.bodySmall.copyWith(color: AppColors.textSub),
            ),
          ],
        ],
      ),
    );
  }
}
