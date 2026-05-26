import 'package:flutter/material.dart';
import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/model/skill.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.skill});
  final Skill skill;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image(
            image: ApiImage.imageProviderFor(
              skill.image,
              fallbackAsset: 'assets/images/computer.png',
            ),
            width: double.infinity,
            height: 260,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.asset(
              'assets/images/computer.png',
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
            ),
          ),
          // Bottom gradient fade
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.bgColor.withValues(alpha: 0.85),
                    AppColors.bgColor,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: AppStyle.headline2.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  skill.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodyMedium.copyWith(
                    color: AppColors.textSub,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
