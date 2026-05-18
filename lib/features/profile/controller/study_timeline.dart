import 'package:flutter/material.dart';
import 'package:portfolio/features/profile/model/career_timeline_model.dart';
import 'package:portfolio/features/profile/model/study_timeline_model.dart';
import 'package:portfolio/shared/theme/colors.dart';

class StudyTimeline extends StatefulWidget {
  const StudyTimeline({super.key});

  @override
  State<StudyTimeline> createState() => _StudyTimelineState();
}

class _StudyTimelineState extends State<StudyTimeline>
    with TickerProviderStateMixin {
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;

  @override
  void initState() {
    super.initState();
    barControllers = List.generate(
      studyTimeLine.length,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: vertical line
            SizedBox(
              width: 20,
              child: Column(
                children: [
                  Container(
                    width: 1.5,
                    // Approximate height; stretches with content
                    height: studyTimeLine.length * 250,
                    color: AppColors.accentGlow,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                children: List.generate(studyTimeLine.length, (index) {
                  final item = studyTimeLine[index];
                  final isLast = index == studyTimeLine.length - 1;

                  return FadeTransition(
                    opacity: barAnimations[index],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.12),
                        end: Offset.zero,
                      ).animate(barAnimations[index]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dot
                          Padding(
                            padding: const EdgeInsets.only(top: 14, right: 12),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentDim,
                                boxShadow: [
                                  BoxShadow(
                                    color:AppColors.accentGlow.withValues(alpha: 0.4),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Card
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.bgCard,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:AppColors.bgColor.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title + Date
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            color:AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                          color:AppColors.neutral,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  // Subtitle
                                  Text(
                                    item.subtitle,
                                    style: const TextStyle(
                                      color: AppColors.accentCyan,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Description
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.65,
                                    ),
                                  ),

                                  // Subject chips — first card only
                                  if (index == 0) ...[
                                    const SizedBox(height: 14),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: subjects
                                          .map(
                                            (tag) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 5,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.card,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color:AppColors.accentDim,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                tag,
                                                style: const TextStyle(
                                                  color:AppColors.textPrimary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
