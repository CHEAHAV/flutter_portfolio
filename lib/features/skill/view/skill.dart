import 'package:flutter/material.dart';
import 'package:portfolio/features/skill/model/headerdata.dart';
import 'package:portfolio/features/skill/model/teach_stack.dart';
import 'package:portfolio/shared/components/profile_card.dart';
import 'package:portfolio/shared/components/detailed_expertise_card.dart';
import 'package:portfolio/shared/components/skill_title.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class SkillPage extends StatefulWidget {
  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        elevation: 0,
        title: Row(
          children: [
            Icon(headerData.iconLeft, color: AppColors.textPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              headerData.title,
              style: AppStyle.headline1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(headerData.iconRight, color: AppColors.textPrimary),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.bgCard,
                  AppColors.accent.withValues(alpha: 0.5),
                  AppColors.bgCard,
                ],
              ),
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // "My Tech Stack" heading
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.accent, Color(0xFFB0C4FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'My Tech Stack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SkillTile(
                    assetPath: teachStack.imageLeft,
                    label: teachStack.labelLeft,
                  ),
                  const SizedBox(width: 12),
                  ProfileCard(assetPath: teachStack.profile),
                  const SizedBox(width: 12),
                  SkillTile(
                    assetPath: teachStack.imageRight,
                    label: teachStack.labelRight,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'It Cheahav',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DetailedExpertiseCard(),
            ],
          ),
        ),
      ),
    );
  }
}