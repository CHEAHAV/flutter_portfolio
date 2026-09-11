import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../shared/shared.dart';

class SkillDetailContent extends StatelessWidget {
  const SkillDetailContent({super.key, required this.skill, this.openWebsite});

  final Skill skill;
  final Future<bool> Function(String)? openWebsite;

  @override
  Widget build(BuildContext context) {
    final resource = SkillResource.forName(skill.name);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 800 &&
            MediaQuery.textScalerOf(context).scale(16) <= 24;
        final overview = _Overview(skill: skill, resource: resource);
        final sidebar = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Proficiency(score: skill.score),
            const SizedBox(height: 20),
            OfficialWebsitePanel(
              name: skill.name,
              // Existing API deployments use the catalog until the new
              // field is deployed.
              officialUrl: skill.officialUrl ?? resource?.url,
              noLinkMessage:
                  'An official website is not available for this skill yet.',
              openWebsite: openWebsite,
            ),
          ],
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'DEVELOPMENT TOOLKIT / SKILL DETAILS',
              style: AppStyle.label.copyWith(
                color: AppColors.accent,
                fontSize: 11,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            _SkillHeader(skill: skill, resource: resource),
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

class _SkillHeader extends StatelessWidget {
  const _SkillHeader({required this.skill, required this.resource});
  final Skill skill;
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
            child: skill.image.trim().isEmpty
                ? const _LogoFallback()
                : Image(
                    image: ApiImage.imageProviderFor(
                      skill.image,
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
              skill.name,
              style: AppStyle.headline1.copyWith(
                fontSize: compact ? 36 : 52,
                height: 1.15,
                letterSpacing: -1.6,
              ),
            ),
            const SizedBox(height: 14),
            DetailTag(label: resource?.category ?? 'Technology', accented: true),
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
      const Icon(Icons.code_rounded, color: Color(0xFF176B94), size: 40);
}

class _Overview extends StatelessWidget {
  const _Overview({required this.skill, required this.resource});
  final Skill skill;
  final SkillResource? resource;

  @override
  Widget build(BuildContext context) => DetailPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionLabel(icon: Icons.subject_rounded, text: 'OVERVIEW'),
        const SizedBox(height: 20),
        Text('About ${skill.name}', style: AppStyle.headline2),
        const SizedBox(height: 16),
        Text(
          skill.description.trim().isEmpty
              ? 'More details about this technology will be added soon.'
              : skill.description.trim(),
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

class _Proficiency extends StatelessWidget {
  const _Proficiency({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    final valid = score.isFinite;
    final value = valid ? score.clamp(0.0, 5.0) : 0.0;
    return DetailPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailSectionLabel(
            icon: Icons.bar_chart_rounded,
            text: 'PROFICIENCY',
          ),
          const SizedBox(height: 18),
          Semantics(
            label: valid
                ? 'Skill score ${value.toStringAsFixed(1)} out of 5'
                : 'Skill score not available',
            excludeSemantics: true,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: valid ? value.toStringAsFixed(1) : '—',
                    style: AppStyle.headline1.copyWith(
                      fontSize: 42,
                      color: AppColors.accent,
                    ),
                  ),
                  TextSpan(
                    text: ' / 5',
                    style: AppStyle.bodyLarge.copyWith(
                      color: AppColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value / 5,
              minHeight: 6,
              color: AppColors.accent,
              backgroundColor: AppColors.divider,
                semanticsLabel: valid ? 'Proficiency' : 'Proficiency not available',
                semanticsValue: '${(value * 20).round()}%',
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Self-assessed skill level',
            style: AppStyle.bodySmall.copyWith(color: AppColors.textSub),
          ),
        ],
      ),
    );
  }
}
