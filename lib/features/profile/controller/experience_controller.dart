import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../profile/profile.dart';
import '../../../shared/shared.dart';

class ExperienceController extends StatelessWidget {
  const ExperienceController({super.key, required this.items});

  final List<Experience> items;

  @override
  Widget build(BuildContext context) {
    final stats = buildExperienceStats(items);

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(stats.length, (index) {
          final item = stats[index];
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
