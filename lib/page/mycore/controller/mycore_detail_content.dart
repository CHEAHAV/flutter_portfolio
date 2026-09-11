import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../shared/shared.dart';

/// The case-study-style body for a core competency: the same layout
/// language as [SkillDetailContent] — a hero header, an overview panel and
/// an official-website panel — so both detail screens feel like one system.
class MyCoreDetailContent extends StatelessWidget {
  const MyCoreDetailContent({
    super.key,
    required this.myCore,
    this.openWebsite,
  });

  final MyCore myCore;
  final Future<bool> Function(String)? openWebsite;

  @override
  Widget build(BuildContext context) {
    // Core competencies name the same technologies as skills, so the
    // catalog of categories, common uses and fallback links applies here
    // too, until every competency carries its own backend link.
    final resource = SkillResource.forName(myCore.name);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 800 &&
            MediaQuery.textScalerOf(context).scale(16) <= 24;
        final overview = _Overview(myCore: myCore, resource: resource);
        final sidebar = OfficialWebsitePanel(
          name: myCore.name,
          officialUrl: myCore.officialUrl ?? resource?.url,
          noLinkMessage:
              'An official website is not available for this competency yet.',
          openWebsite: openWebsite,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'MY EXPERTISE / CORE COMPETENCY',
              style: AppStyle.label.copyWith(
                color: AppColors.accent,
                fontSize: 11,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            _MyCoreHeader(myCore: myCore, resource: resource),
            const SizedBox(height: 28),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: overview),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: sidebar),
                ],
              )
            else ...[
              overview,
              const SizedBox(height: 20),
              sidebar,
            ],
          ],
        );
      },
    );
  }
}

class _MyCoreHeader extends StatelessWidget {
  const _MyCoreHeader({required this.myCore, required this.resource});
  final MyCore myCore;
  final SkillResource? resource;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(context.isMobile ? 24 : 36),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.tileBorder),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF162C47), AppColors.bgCard, Color(0xFF191C40)],
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;
        final logo = Container(
          width: compact ? 80 : 112,
          height: compact ? 80 : 112,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: myCore.image.trim().isEmpty
                ? const _LogoFallback()
                : Image(
                    image: ApiImage.imageProviderFor(
                      myCore.image,
                      fallbackAsset: 'assets/icons/backend.png',
                    ),
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                    errorBuilder: (_, error, stackTrace) =>
                        const _LogoFallback(),
                  ),
          ),
        );
        final identity = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              myCore.name,
              style: AppStyle.headline1.copyWith(
                fontSize: compact ? 36 : 52,
                height: 1.15,
                letterSpacing: -1.6,
              ),
            ),
            const SizedBox(height: 14),
            DetailTag(
              label: resource?.category ?? 'Core competency',
              accented: true,
            ),
          ],
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [logo, const SizedBox(height: 24), identity],
          );
        }
        return Row(
          children: [
            logo,
            const SizedBox(width: 28),
            Expanded(child: identity),
          ],
        );
      },
    ),
  );
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();
  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.workspace_premium_rounded, color: Color(0xFF176B94), size: 40);
}

class _Overview extends StatelessWidget {
  const _Overview({required this.myCore, required this.resource});
  final MyCore myCore;
  final SkillResource? resource;

  @override
  Widget build(BuildContext context) => DetailPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionLabel(icon: Icons.subject_rounded, text: 'OVERVIEW'),
        const SizedBox(height: 20),
        Text('About ${myCore.name}', style: AppStyle.headline2),
        const SizedBox(height: 16),
        Text(
          myCore.description.trim().isEmpty
              ? 'More details about this competency will be added soon.'
              : myCore.description.trim(),
          style: AppStyle.bodyLarge.copyWith(
            color: const Color(0xFFAFBCD2),
            height: 1.85,
          ),
        ),
        if (resource != null) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          Text(
            'COMMON USES',
            style: AppStyle.label.copyWith(
              color: AppColors.textSub,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [for (final use in resource!.uses) DetailTag(label: use)],
          ),
        ],
      ],
    ),
  );
}
