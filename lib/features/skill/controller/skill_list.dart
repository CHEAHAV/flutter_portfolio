import 'package:flutter/material.dart';
import 'package:portfolio/api/model/skill.dart';
import 'package:portfolio/features/skill/controller/full_width_skill.dart';
import 'package:portfolio/features/skill/controller/skill_pair.dart';
import 'package:portfolio/shared/theme/colors.dart';

class SkillList extends StatelessWidget {
  const SkillList({
    super.key,
    required this.skill,
    required this.animations,
    this.onSkillDetailPage,
  });

  final List<Skill> skill;
  final List<Animation<double>> animations;
  final void Function(int index)? onSkillDetailPage;

  @override
  Widget build(BuildContext context) {
    if (skill.isEmpty) {
      return const Text(
        'No backend skill yet.',
        style: TextStyle(color: AppColors.textSub, fontSize: 13),
      );
    }

    return Column(
      children: [
        if (skill.length == 1)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSkillDetailPage?.call(0),
            child: FullWidthSkill(
              skill: skill[0],
              index: 0,
              barAnimation: animations[0],
            ),
          ),
        if (skill.length >= 2)
          SkillPair(
            left: skill[0],
            right: skill[1],
            leftAnimation: animations[0],
            rightAnimation: animations[1],
            onLeftTap: () => onSkillDetailPage?.call(0),
            onRightTap: () => onSkillDetailPage?.call(1),
          ),
        ...List.generate(
          skill.length > 2 ? skill.length - 2 : 0,
          (i) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSkillDetailPage?.call(i + 2),
              child: FullWidthSkill(
                skill: skill[i + 2],
                index: i + 2,
                barAnimation: animations[i + 2],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
