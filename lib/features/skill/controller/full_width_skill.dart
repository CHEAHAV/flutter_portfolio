import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../shared/shared.dart';

class FullWidthSkill extends StatelessWidget {
  final Skill skill;
  final int index;
  final Animation<double> barAnimation;

  const FullWidthSkill({
    super.key,
    required this.skill,
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
                skill.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${skill.score}/5',
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
                widthFactor: barAnimation.value * (skill.score.toDouble() / 5),
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
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
