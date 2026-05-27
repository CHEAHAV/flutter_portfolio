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

    final List<Widget> rows = [];

    int i = 0;
    while (i < skill.length) {
      if (i + 1 < skill.length) {
        // Pair: left + right
        rows.add(
          SkillPair(
            left: skill[i],
            right: skill[i + 1],
            leftAnimation: animations[i],
            rightAnimation: animations[i + 1],
            onLeftTap: () => onSkillDetailPage?.call(i),
            onRightTap: () => onSkillDetailPage?.call(i + 1),
          ),
        );
        i += 2;
      } else {
        // Odd item left — show full width
        final index = i;
        rows.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSkillDetailPage?.call(index),
              child: FullWidthSkill(
                skill: skill[index],
                index: index,
                barAnimation: animations[index],
              ),
            ),
          ),
        );
        i += 1;
      }
    }

    return Column(children: rows);
  }
}