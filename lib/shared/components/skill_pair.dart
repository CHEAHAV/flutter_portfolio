import 'package:flutter/material.dart';
import 'package:portfolio/features/skill/model/skill_item.dart';
import 'package:portfolio/shared/theme/colors.dart';

class SkillPair extends StatelessWidget {
  final SkillItem left;
  final SkillItem right;
  final Animation<double> leftAnimation;
  final Animation<double> rightAnimation;

  const SkillPair({
    super.key,
    required this.left,
    required this.right,
    required this.leftAnimation,
    required this.rightAnimation,
  });

  // ── Single column ─────────────────────────────────────────────────────────
  Widget skillColumn(SkillItem skill, Animation<double> animation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${skill.score}/10',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedBuilder(
            animation: animation,
            builder: (_, __) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: animation.value * (skill.score / 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [AppColors.accentDim, AppColors.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          skill.description,
          style: const TextStyle(
            color: AppColors.textSub,
            fontSize: 11,
            height: 1.5,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: skillColumn(left, leftAnimation)),
          const SizedBox(width: 16),
          Expanded(child: skillColumn(right, rightAnimation)),
        ],
      ),
    );
  }
}