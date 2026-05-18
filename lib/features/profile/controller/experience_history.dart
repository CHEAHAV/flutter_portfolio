import 'package:flutter/material.dart';
import 'package:portfolio/features/skill/model/dev_story_model.dart';
import 'package:portfolio/shared/theme/colors.dart';

class ExperienceHistory extends StatefulWidget {
  const ExperienceHistory({super.key});

  @override
  State<ExperienceHistory> createState() => _ExperienceHistoryState();
}

class _ExperienceHistoryState extends State<ExperienceHistory>
    with TickerProviderStateMixin {
  bool expanded = false;
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;

  @override
  void initState() {
    super.initState();
    barControllers = List.generate(
      devStory.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700 + i * 150),
      ),
    );
    barAnimations = barControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOutCubic))
        .toList();

    for (int i = 0; i < barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) barControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in barControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: icon + // Title
            Row(
              children: [
                Icon(terminalicon, color: AppColors.accentDim, size: 18),
                const SizedBox(width: 8),
                Text(
                  '// ${devStory[0].title}',
                  style: TextStyle(
                    color: AppColors.accentDim,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Description
            Text(
              devStory[0].description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
