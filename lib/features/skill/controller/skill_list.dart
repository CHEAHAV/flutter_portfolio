import 'package:flutter/material.dart';
import '../../skill/skill.dart';
import '../../../api/api.dart';
import '../../../shared/shared.dart';

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
        final leftIndex = i;
        final rightIndex = i + 1;
        final leftAnimation = leftIndex < animations.length
            ? animations[leftIndex]
            : const AlwaysStoppedAnimation<double>(1);
        final rightAnimation = rightIndex < animations.length
            ? animations[rightIndex]
            : const AlwaysStoppedAnimation<double>(1);

        // Pair: left + right
        rows.add(
          SkillPair(
            left: skill[leftIndex],
            right: skill[rightIndex],
            leftAnimation: leftAnimation,
            rightAnimation: rightAnimation,
            onLeftTap: () => onSkillDetailPage?.call(leftIndex),
            onRightTap: () => onSkillDetailPage?.call(rightIndex),
          ),
        );
        i += 2;
      } else {
        // Odd item left — show full width
        final index = i;
        final animation = index < animations.length
            ? animations[index]
            : const AlwaysStoppedAnimation<double>(1);
        rows.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSkillDetailPage?.call(index),
              child: FullWidthSkill(
                skill: skill[index],
                index: index,
                barAnimation: animation,
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
