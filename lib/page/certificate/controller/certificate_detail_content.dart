import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../shared/shared.dart';
import '../../../web/web.dart';
import '../model/certificate_detail_model.dart';

typedef CertificateLinkOpener = Future<bool> Function(String url);

/// The case-study-style body for a credential — the same layout language
/// as [ProjectDetailContent]: a breadcrumb, a hero, a full-bleed (and
/// zoomable) cover, a facts panel, and a verify panel, so a certificate
/// reads as one more case study rather than a plain, backgroundless card.
class CertificateDetailContent extends StatelessWidget {
  const CertificateDetailContent({
    super.key,
    required this.certification,
    this.onBackToCareer,
    this.onBackToTop,
    this.openLink,
  });

  final Certification certification;
  final VoidCallback? onBackToCareer;
  final VoidCallback? onBackToTop;
  final CertificateLinkOpener? openLink;

  bool get _hasLink => certification.certificateurl.trim().isNotEmpty;

  Future<void> _openCertificate(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final opener = openLink ?? ExternalLink.open;

    var opened = false;
    try {
      opened = await opener(certification.certificateurl);
    } catch (_) {
      opened = false;
    }

    if (!opened) {
      messenger.showSnackBar(const SnackBar(content: Text(webLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isMobile = context.isMobile;

    final facts = CertificateFactsPanel(certification: certification);

    final verify = OfficialWebsitePanel(
      name: certification.name,
      officialUrl: certification.certificateurl,
      noLinkMessage: certificateNoLinkMessage,
      openWebsite: openLink,
      sectionIcon: Icons.verified_rounded,
      sectionLabel: 'VERIFY CREDENTIAL',
      headingPrefix: 'View',
      availableMessage:
          'Open the original certificate to verify this credential.',
      ctaLabel: certificateViewAction,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailBreadcrumb(
          rootLabel: certificateCrumbRoot,
          name: certification.name,
          onRootTap: onBackToCareer,
        ),
        SizedBox(height: isMobile ? 18 : 26),
        _hero(context),
        SizedBox(height: isDesktop ? 56 : 36),
        CertificateCover(certification: certification),
        SizedBox(height: isDesktop ? 64 : 40),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: facts),
              const SizedBox(width: 24),
              Expanded(flex: 4, child: verify),
            ],
          )
        else ...[
          facts,
          const SizedBox(height: 20),
          verify,
        ],
        SizedBox(height: isDesktop ? 72 : 48),
        DetailFooterStrip(onBackToTop: onBackToTop),
      ],
    );
  }

  Widget _hero(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 22, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                certificateCaseLabel.toUpperCase(),
                style: AppStyle.label.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SelectionArea(
          child: Text(
            certification.name,
            style: AppStyle.headline1.copyWith(
              fontSize: isDesktop ? 46 : (isMobile ? 30 : 38),
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
        ),
        if (certification.title.trim().isNotEmpty) ...[
          const SizedBox(height: 22),
          DetailTag(label: certification.title.toUpperCase(), accented: true),
        ],
        const SizedBox(height: 30),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            if (_hasLink)
              WebPrimaryButton(
                label: certificateViewAction,
                icon: Icons.north_east,
                dense: isMobile,
                onPressed: () => _openCertificate(context),
              ),
            if (onBackToCareer != null)
              WebGhostButton(
                label: certificateBackAction,
                icon: Icons.arrow_back,
                dense: isMobile,
                onPressed: onBackToCareer!,
              ),
          ],
        ),
      ],
    );
  }
}

/// Full-bleed certificate artwork. Tapping it — or the magnifier badge —
/// opens a zoomable lightbox, the same as a project's cover image.
class CertificateCover extends StatefulWidget {
  const CertificateCover({super.key, required this.certification});

  final Certification certification;

  @override
  State<CertificateCover> createState() => _CertificateCoverState();
}

class _CertificateCoverState extends State<CertificateCover> {
  bool _hovered = false;

  ImageProvider get _image => ApiImage.imageProviderFor(
    widget.certification.icon,
    fallbackAsset: 'assets/images/computer.png',
  );

  void _openZoom() {
    showZoomableImage(
      context,
      image: _image,
      title: widget.certification.name,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/computer.png', fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppStyle.radiusLg + 4);

    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _openZoom,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.42),
                  blurRadius: 42,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: AspectRatio(
                aspectRatio: context.responsive(
                  mobile: 4 / 3,
                  tablet: 16 / 9,
                  desktop: 16 / 9,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Image(
                          image: _image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/images/computer.png',
                                fit: BoxFit.contain,
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 18,
                      top: 18,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 160),
                        opacity: _hovered ? 1 : 0.72,
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.bgDeep.withValues(alpha: 0.82),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.tileBorder),
                          ),
                          child: const Icon(
                            Icons.zoom_in_rounded,
                            size: 18,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Credential ID, date earned, and issuer beside the certificate.
class CertificateFactsPanel extends StatelessWidget {
  const CertificateFactsPanel({super.key, required this.certification});

  final Certification certification;

  @override
  Widget build(BuildContext context) {
    final values = [
      certification.credentialId,
      certification.dateEarned,
      certification.issuer,
    ];
    final facts = <CertificateFactModel, String>{
      for (var i = 0; i < certificateFactModel.length; i++)
        certificateFactModel[i]: values[i],
    }..removeWhere((key, value) => value.trim().isEmpty);

    return DetailPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            certificateFactsTitle.toUpperCase(),
            style: AppStyle.label.copyWith(
              color: AppColors.textSub,
              fontSize: 10,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 22),
          if (facts.isEmpty)
            Text(
              '—',
              style: AppStyle.bodyMedium.copyWith(color: AppColors.textSub),
            )
          // The tablet panel spans the full column, so the facts read
          // across it instead of stacking against a wide empty margin.
          else if (context.isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in facts.entries) ...[
                  if (entry.key != facts.keys.first) const SizedBox(width: 20),
                  Expanded(
                    child: DetailFactRow(
                      icon: entry.key.icon,
                      label: entry.key.label,
                      value: entry.value,
                    ),
                  ),
                ],
              ],
            )
          else
            ...facts.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == facts.keys.last ? 0 : 18,
                ),
                child: DetailFactRow(
                  icon: entry.key.icon,
                  label: entry.key.label,
                  value: entry.value,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
