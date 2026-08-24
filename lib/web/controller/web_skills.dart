import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../shared/shared.dart';

class WebSkills extends StatelessWidget {
  const WebSkills({
    super.key,
    required this.skills,
    required this.teachstack,
    required this.onSkillTap,
  });

  final List<Skill> skills;
  final List<TeachStack> teachstack;
  final void Function(int index) onSkillTap;

  List<String> get _stackLabels {
    if (teachstack.isEmpty) return const [];
    final stack = teachstack.first;
    return [stack.nameleft, stack.nameright]
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final labels    = _stackLabels;
    final isDesktop = context.isDesktop;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WebHeading(
          label: webSkillsLabel,
          title: webSkillsTitle,
          lead : webSkillsLead,
          trailing: (labels.isEmpty || !isDesktop)
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: labels
                      .map(
                        (label) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child  : WebChip(label: label, filled: true),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 44),
        if (skills.isEmpty)
          Text(webNoSkill, style: AppStyle.bodyMedium)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing    = 20.0;
              const itemHeight = 230.0;
              final columns    = isDesktop ? 4 : 2;
              final itemWidth  =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return GridView.builder(
                shrinkWrap  : true,
                physics     : const NeverScrollableScrollPhysics(),
                padding     : EdgeInsets.zero,
                itemCount   : skills.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount  : columns,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing : spacing,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemBuilder: (context, index) => WebSkillCard(
                  skill: skills[index],
                  onTap: () => onSkillTap(index),
                ),
              );
            },
          ),
      ],
    );
  }
}

class WebSkillCard extends StatefulWidget {
  const WebSkillCard({super.key, required this.skill, required this.onTap});

  final Skill skill;
  final VoidCallback onTap;

  @override
  State<WebSkillCard> createState() => _WebSkillCardState();
}

class _WebSkillCardState extends State<WebSkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final skill = widget.skill;

    return MouseRegion(
      cursor : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : widget.onTap,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          curve   : Curves.easeOut,
          offset  : _hovered ? const Offset(0, -0.022) : Offset.zero,
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
                      width  : 40,
                      height : 40,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color       : AppColors.bgTile,
                        borderRadius: BorderRadius.circular(AppStyle.radiusMd),
                        border      : Border.all(color: AppColors.tileBorder),
                      ),
                      child: Image(
                        image: ApiImage.imageProviderFor(
                          skill.image,
                          fallbackAsset: 'assets/icons/backend.png',
                        ),
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/icons/backend.png');
                        },
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${skill.score}',
                      style: AppStyle.bodyMedium.copyWith(
                        color     : AppColors.accent,
                        fontFamily: 'JetBrainsMono',
                        fontSize  : 13,
                      ),
                    ),
                    Text(
                      '/5',
                      style: AppStyle.bodySmall.copyWith(
                        color     : AppColors.textSub,
                        fontFamily: 'JetBrainsMono',
                        fontSize  : 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  skill.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headline3.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 8),
                Text(
                  skill.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodySmall.copyWith(
                    color : AppColors.textSub,
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                WebScoreBar(score: skill.score, active: _hovered),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebScoreBar extends StatelessWidget {
  const WebScoreBar({super.key, required this.score, this.active = false});

  final double score;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color       : AppColors.divider,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TweenAnimationBuilder<double>(
        tween   : Tween(begin: 0, end: (score / 5).clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 900),
        curve   : Curves.easeOutCubic,
        builder : (context, value, child) => FractionallySizedBox(
          alignment  : Alignment.centerLeft,
          widthFactor: value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [AppColors.accentDim, AppColors.accent],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(
                    alpha: active ? 0.6 : 0.35,
                  ),
                  blurRadius  : active ? 12 : 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
