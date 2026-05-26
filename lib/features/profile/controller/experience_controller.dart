import 'package:flutter/material.dart';
import 'package:portfolio/features/profile/model/profile_model.dart';
import 'package:portfolio/shared/theme/colors.dart';

class ExperienceController extends StatelessWidget {
  const ExperienceController({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(experience.length, (index) {
          final item = experience[index];
          return Row(
            children: [
              if (index != 0)
                Container(
                  width: 1,
                  color: AppColors.divider,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
              Column(
                children: [
                  Text(
                    item.data,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
