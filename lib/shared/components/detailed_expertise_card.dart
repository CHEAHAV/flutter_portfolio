import 'package:flutter/material.dart';
import 'package:portfolio/features/skill/model/skill_item.dart';
import 'package:portfolio/shared/components/full_width_skill.dart';
import 'package:portfolio/shared/components/skill_pair.dart';
import 'package:portfolio/shared/components/tab_bar.dart';
import 'package:portfolio/shared/theme/colors.dart';

class DetailedExpertiseCard extends StatefulWidget {
  const DetailedExpertiseCard({super.key});

  @override
  State<DetailedExpertiseCard> createState() => _DetailedExpertiseCardState();
}

class _DetailedExpertiseCardState extends State<DetailedExpertiseCard>
    with TickerProviderStateMixin {
  int selectedTab = 0;
  late List<AnimationController> _barControllers;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    _barControllers = List.generate(
      skillItems.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700 + i * 150),
      ),
    );
    _barAnimations = _barControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOutCubic))
        .toList();

    for (int i = 0; i < _barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) _barControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _barControllers) {
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            detail,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),

          ExpertiseTabBar(
            onTabSelected: (i) => setState(() => selectedTab = i),
          ),
          const SizedBox(height: 20),

          if (skillItems.length >= 2)
            SkillPair(
              left: skillItems[0],
              right: skillItems[1],
              leftAnimation: _barAnimations[0],
              rightAnimation: _barAnimations[1],
            ),
          ...List.generate(
            skillItems.length > 2 ? skillItems.length - 2 : 0,
            (i) => FullWidthSkill(
              skillItem: skillItems[i + 2],
              index: i + 2,
              barAnimation: _barAnimations[i + 2],
            ),
          ),
        ],
      ),
    );
  }
}