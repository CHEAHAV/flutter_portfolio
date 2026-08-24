import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../shared/shared.dart';

class WebCareer extends StatelessWidget {
  const WebCareer({
    super.key,
    required this.study,
    required this.career,
    required this.certification,
    required this.onCertificationTap,
  });

  final List<Study> study;
  final List<Career> career;
  final List<Certification> certification;
  final void Function(int index) onCertificationTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    final education = WebTimeline(
      heading: webEducationHeading,
      icon   : Icons.school_outlined,
      entries: study
          .map(
            (item) => WebTimelineEntry(
              title      : item.title,
              subtitle   : item.subtitle,
              description: item.description,
              date       : item.date,
            ),
          )
          .toList(),
    );

    final experience = WebTimeline(
      heading: webCareerHeading,
      icon   : Icons.work_outline,
      entries: career
          .map(
            (item) => WebTimelineEntry(
              title      : item.title,
              subtitle   : item.subtitle,
              description: item.description,
              date       : item.date,
            ),
          )
          .toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WebHeading(
          label: webCareerLabel,
          title: webCareerTitle,
          lead : webCareerLead,
        ),
        const SizedBox(height: 48),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: education),
              const SizedBox(width: 48),
              Expanded(child: experience),
            ],
          )
        else ...[
          education,
          const SizedBox(height: 40),
          experience,
        ],
        if (certification.isNotEmpty) ...[
          SizedBox(height: isDesktop ? 64 : 48),
          Text(
            webCertHeading,
            style: AppStyle.headline3.copyWith(fontSize: 19),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing    = 20.0;
              const itemHeight = 210.0;
              final columns    = isDesktop ? 3 : 2;
              final itemWidth  =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return GridView.builder(
                shrinkWrap  : true,
                physics     : const NeverScrollableScrollPhysics(),
                padding     : EdgeInsets.zero,
                itemCount   : certification.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount  : columns,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing : spacing,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemBuilder: (context, index) => WebCertificationCard(
                  item : certification[index],
                  onTap: () => onCertificationTap(index),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class WebTimelineEntry {
  const WebTimelineEntry({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.date,
  });

  final String title;
  final String subtitle;
  final String description;
  final String date;
}

class WebTimeline extends StatelessWidget {
  const WebTimeline({
    super.key,
    required this.heading,
    required this.icon,
    required this.entries,
  });

  final String heading;
  final IconData icon;
  final List<WebTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(heading, style: AppStyle.headline3.copyWith(fontSize: 19)),
          ],
        ),
        const SizedBox(height: 24),
        ...List.generate(entries.length, (index) {
          final entry = entries[index];
          final last  = index == entries.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width : 11,
                      height: 11,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: AppColors.bgDeep,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.45),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    if (!last)
                      Expanded(
                        child: Container(
                          width : 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color : AppColors.divider,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: last ? 0 : 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (entry.date.trim().isNotEmpty) ...[
                          Text(
                            entry.date,
                            style: AppStyle.bodySmall.copyWith(
                              color        : AppColors.accent,
                              fontFamily   : 'JetBrainsMono',
                              fontSize     : 10,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 7),
                        ],
                        Text(
                          entry.title,
                          style: AppStyle.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (entry.subtitle.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            entry.subtitle,
                            style: AppStyle.bodyMedium.copyWith(
                              color: AppColors.textSub,
                            ),
                          ),
                        ],
                        if (entry.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            entry.description,
                            style: AppStyle.bodyMedium.copyWith(
                              color : AppColors.textSub,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class WebCertificationCard extends StatefulWidget {
  const WebCertificationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final Certification item;
  final VoidCallback onTap;

  @override
  State<WebCertificationCard> createState() => _WebCertificationCardState();
}

class _WebCertificationCardState extends State<WebCertificationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      cursor : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : widget.onTap,
        child: WebCard(
          hovered: _hovered,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width  : 44,
                    height : 44,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color       : AppColors.bgTile,
                      borderRadius: BorderRadius.circular(AppStyle.radiusMd),
                      border      : Border.all(color: AppColors.tileBorder),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppStyle.radiusSm),
                      child: Image(
                        image: ApiImage.imageProviderFor(
                          item.icon,
                          fallbackAsset: 'assets/icons/resume.png',
                        ),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/icons/resume.png',
                            color: AppColors.accent,
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (item.dateEarned.trim().isNotEmpty)
                    Text(
                      item.dateEarned,
                      style: AppStyle.bodySmall.copyWith(
                        color     : AppColors.textSub,
                        fontFamily: 'JetBrainsMono',
                        fontSize  : 10,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodySmall.copyWith(
                  color : AppColors.textSub,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  if (item.issuer.trim().isNotEmpty)
                    Expanded(
                      child: Text(
                        item.issuer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodySmall.copyWith(
                          color     : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.north_east,
                    size : 14,
                    color: _hovered ? AppColors.accent : AppColors.textSub,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
