import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../shared/shared.dart';

class WebAbout extends StatefulWidget {
  const WebAbout({
    super.key,
    required this.stories,
    required this.study,
    required this.career,
    required this.teachstack,
    required this.onContactTap,
  });

  final List<Story> stories;
  final List<Study> study;
  final List<Career> career;
  final List<TeachStack> teachstack;
  final VoidCallback onContactTap;

  @override
  State<WebAbout> createState() => _WebAboutState();
}

class _WebAboutState extends State<WebAbout> {
  bool _expanded = false;

  List<Story> get _paragraphs =>
      _expanded ? widget.stories : widget.stories.take(2).toList();

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    final narrative = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WebHeading(label: webAboutLabel, title: webAboutTitle),
        const SizedBox(height: 26),
        ..._paragraphs.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.title.trim().isNotEmpty) ...[
                  Text(
                    item.title,
                    style: AppStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  item.description,
                  style: AppStyle.bodyLarge.copyWith(
                    color : AppColors.textSub,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.stories.length > 2) ...[
          const SizedBox(height: 4),
          WebTextLink(
            label: _expanded ? webAboutLess : webAboutMore,
            icon : _expanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ],
      ],
    );

    final facts = WebFactsCard(
      study     : widget.study,
      career    : widget.career,
      teachstack: widget.teachstack,
      onContactTap: widget.onContactTap,
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [narrative, const SizedBox(height: 32), facts],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: narrative),
        const SizedBox(width: 56),
        Expanded(flex: 5, child: facts),
      ],
    );
  }
}

class WebFactsCard extends StatelessWidget {
  const WebFactsCard({
    super.key,
    required this.study,
    required this.career,
    required this.teachstack,
    required this.onContactTap,
  });

  final List<Study> study;
  final List<Career> career;
  final List<TeachStack> teachstack;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    final latestStudy  = study.isNotEmpty ? study.first : null;
    final latestCareer = career.isNotEmpty ? career.first : null;
    final stack        = teachstack.isNotEmpty ? teachstack.first : null;

    return WebCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize      : MainAxisSize.min,
        children: [
          Text(
            webFactsTitle,
            style: AppStyle.labelLarge.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: 24),
          if (latestCareer != null)
            WebFactRow(
              icon    : Icons.work_outline,
              label   : webFactCurrent,
              title   : latestCareer.title,
              subtitle: [latestCareer.subtitle, latestCareer.date]
                  .where((value) => value.trim().isNotEmpty)
                  .join(' · '),
            ),
          if (latestStudy != null)
            WebFactRow(
              icon    : Icons.school_outlined,
              label   : webFactEducation,
              title   : latestStudy.title,
              subtitle: [latestStudy.subtitle, latestStudy.date]
                  .where((value) => value.trim().isNotEmpty)
                  .join(' · '),
            ),
          if (stack != null)
            WebFactRow(
              icon    : Icons.layers_outlined,
              label   : webFactFocus,
              title   : [stack.nameleft, stack.nameright]
                  .where((value) => value.trim().isNotEmpty)
                  .join(' · '),
              subtitle: '',
              last    : true,
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: WebGhostButton(
                  label    : webContactMe,
                  dense    : true,
                  icon     : Icons.arrow_forward,
                  onPressed: onContactTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WebFactRow extends StatelessWidget {
  const WebFactRow({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
    required this.subtitle,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String title;
  final String subtitle;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 20 : 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width : 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color       : AppColors.bgTile,
              borderRadius: BorderRadius.circular(AppStyle.radiusMd),
              border      : Border.all(color: AppColors.tileBorder),
            ),
            child: Icon(icon, size: 17, color: AppColors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppStyle.bodySmall.copyWith(
                    color        : AppColors.textSub,
                    fontFamily   : 'JetBrainsMono',
                    fontSize     : 9,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: AppStyle.bodyMedium.copyWith(
                    color     : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppStyle.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
