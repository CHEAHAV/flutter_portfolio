import 'package:flutter/material.dart';
import 'package:portfolio/api/model/skill.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class MyFilterSkill extends StatelessWidget {
  const MyFilterSkill({
    super.key,
    required this.skills,
    this.onSkillDetailPage,
  });

  final List<Skill> skills;
  final void Function(int index)? onSkillDetailPage;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          return GestureDetector(
            onTap: () {
              if (onSkillDetailPage != null) {
                onSkillDetailPage!(index);
                return;
              }
              Navigator.pushNamed(
                context,
                AppRoute.skillDetailRoute,
                arguments: index,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(skill.name, style: AppStyle.label),
            ),
          );
        },
      ),
    );
  }
}
