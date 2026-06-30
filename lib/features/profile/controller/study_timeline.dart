import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../shared/shared.dart';

class StudyTimeline extends StatefulWidget {
  const StudyTimeline({super.key, required this.items});

  final List<Study> items;

  @override
  State<StudyTimeline> createState() => _StudyTimelineState();
}

class _StudyTimelineState extends State<StudyTimeline>
    with TickerProviderStateMixin {
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;
  int _animationRun = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(covariant StudyTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _disposeAnimations();
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    _animationRun++;
    barControllers = List.generate(
      widget.items.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700 + i * 150),
      ),
    );
    barAnimations = barControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOutCubic))
        .toList();

    for (int i = 0; i < barControllers.length; i++) {
      final controller = barControllers[i];
      final animationRun = _animationRun;
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted && animationRun == _animationRun) {
          controller.forward();
        }
      });
    }
  }

  void _disposeAnimations() {
    _animationRun++;
    for (final c in barControllers) {
      c.dispose();
    }
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final lineAnimation = barAnimations.last;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 9.25,
          top: 0,
          bottom: 0,
          child: ExcludeSemantics(
            child: ScaleTransition(
              scale: lineAnimation,
              alignment: Alignment.topCenter,
              child: Container(width: 1.5, color: AppColors.accentDim),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isLast = index == widget.items.length - 1;
                  final itemAnimation = barAnimations[index];

                  return FadeTransition(
                    opacity: itemAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.12),
                        end: Offset.zero,
                      ).animate(itemAnimation),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    color: AppColors.accentGlow.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                    color: AppColors.bgColor.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
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
                                          color: AppColors.neutral,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.subtitle,
                                    style: const TextStyle(
                                      color: AppColors.accentCyan,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.65,
                                    ),
                                  ),
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
