import 'package:flutter/material.dart';
import '../skill.dart';
import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class DetailedExpertiseCard extends StatefulWidget {
  const DetailedExpertiseCard({
    super.key,
    required this.skill,
    required this.project,
    required this.certification,
  });

  final List<Skill> skill;
  final List<Project> project;
  final List<Certification> certification;

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
    _setupAnimations(widget.skill.length);
  }

  @override
  void didUpdateWidget(covariant DetailedExpertiseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skill.length != widget.skill.length) {
      for (final c in _barControllers) {
        c.dispose();
      }
      _setupAnimations(widget.skill.length);
    }
  }

  void _setupAnimations(int count) {
    _barControllers = List.generate(
      count,
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
    final skill = widget.skill;
    final project = widget.project;
    final certification = widget.certification;

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

          if (selectedTab == 0)
            SkillList(
              skill: skill,
              animations: _barAnimations,
              onSkillDetailPage: (index) {
                if (index < 0 || index >= skill.length) return;

                Navigator.pushNamed(
                  context,
                  AppRoute.skillDetailRoute,
                  arguments: {'id': skill[index].id, 'index': index},
                );
              },
            ),
          if (selectedTab == 1) ProjectList(project: project),
          if (selectedTab == 2) CertificationList(certification: certification),
          if (selectedTab > 2)
            const Text(
              'No backend data for this tab yet.',
              style: TextStyle(color: AppColors.textSub, fontSize: 13),
            ),
        ],
      ),
    );
  }
}
