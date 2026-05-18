import 'package:flutter/material.dart';
import 'package:portfolio/features/home/model/home_model.dart';
import 'package:portfolio/features/profile/controller/certification.dart';
import 'package:portfolio/features/profile/controller/contace_button.dart';
import 'package:portfolio/features/profile/controller/experience_controller.dart';
import 'package:portfolio/features/profile/controller/experience_history.dart';
import 'package:portfolio/features/profile/controller/history_timeline.dart';
import 'package:portfolio/features/profile/controller/profile_controller.dart';
import 'package:portfolio/features/profile/controller/resume_button.dart';
import 'package:portfolio/features/profile/model/history_model.dart';
import 'package:portfolio/shared/components/divider.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final HomeModel homeModel = HomeModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(homeModel.headerdata.imageUrl),
              radius: 20,
            ),
            SizedBox(width: 16),
            Text(
              homeModel.headerdata.name,
              style: AppStyle.headline1,
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(homeModel.headerdata.icon)),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: AppDivider(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Avatar with online dot
              ProfileController(),
              const SizedBox(height: 16),
              // Name
              Text(
                homeModel.info.name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              // Title/subtitle uppercase
              Text(
                homeModel.info.description.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              // Stats row
              ExperienceController(),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Left button — filled light
                    Expanded(child: ResumeButton()),

                    const SizedBox(width: 12),

                    // Right button — outlined
                    Expanded(child: ContaceButton()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ExperienceHistory(),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(timeline[0]['icon'], color: AppColors.accent),
                  SizedBox(width: 5),
                  Text(
                    '// ${timeline[0]['title']}',
                    style: AppStyle.labelLarge.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              HistoryTimeline(),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(timeline[1]['icon'], color: AppColors.accent),
                  SizedBox(width: 5),
                  Text(
                    '// ${timeline[1]['title']}',
                    style: AppStyle.labelLarge.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Certification(),
            ],
          ),
        ),
      ),
    );
  }
}
