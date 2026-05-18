import 'package:flutter/material.dart';
import 'package:portfolio/features/skill/model/skill_item.dart';
import 'package:portfolio/shared/theme/colors.dart';

class FullWidthSkill extends StatelessWidget {
  final SkillItem skillItem;
  final int index;
  final Animation<double> barAnimation;

  const FullWidthSkill({
    super.key,
    required this.skillItem,
    required this.index,
    required this.barAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skillItem.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${skillItem.score}/10',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
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
              animation: barAnimation,
              builder: (context, child) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: barAnimation.value * (skillItem.score / 10),
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
            skillItem.description,
            style: const TextStyle(
              color: AppColors.textSub,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
