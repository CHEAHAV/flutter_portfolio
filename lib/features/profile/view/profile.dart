import 'package:flutter/material.dart';
import 'package:portfolio/api/model/api_model.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/api/repository/api_repository.dart';
import 'package:portfolio/features/profile/controller/contace_button.dart';
import 'package:portfolio/features/profile/controller/experience_controller.dart';
import 'package:portfolio/features/profile/controller/experience_history.dart';
import 'package:portfolio/features/profile/controller/career_timeline.dart';
import 'package:portfolio/features/profile/controller/profile_controller.dart';
import 'package:portfolio/features/profile/controller/resume_button.dart';
import 'package:portfolio/features/profile/controller/section_title.dart';
import 'package:portfolio/features/profile/controller/study_timeline.dart';
import 'package:portfolio/features/profile/model/data_section_title.dart';
import 'package:portfolio/features/profile/model/profilebackend_message.dart';
import 'package:portfolio/shared/components/backend_message.dart';
import 'package:portfolio/shared/components/myapp_bar.dart';
import 'package:portfolio/shared/theme/colors.dart';
import 'package:portfolio/features/profile/controller/certification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.profileBackendMessage,
    required this.dataSectionTitle,
    this.onContactTap,
    this.onProfileTap,
  });

  final List<ProfileBackendMessage> profileBackendMessage;
  final List<DataSectionTitle> dataSectionTitle;
  final VoidCallback? onContactTap;
  final VoidCallback? onProfileTap;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ApiModel> apiModelFuture;
  Info? _info;

  @override
  void initState() {
    super.initState();
    apiModelFuture = loadApiModel();
  }

  Future<ApiModel> loadApiModel() {
    return ApiRepository().loadApiModel();
  }

  void _retryLoadProfileContent() {
    setState(() {
      apiModelFuture = loadApiModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          apiModelFuture = loadApiModel();
        });
        await apiModelFuture;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgDeep,
        appBar: MyAppBar(
          info: _info,
          index: 3,
          onProfileTap: widget.onProfileTap, contactme: [],
        ),
        body: FutureBuilder<ApiModel>(
          future: apiModelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return BackendMessage(
                title: profileBackendMessage[0].title,
                message: profileBackendMessage[0].message,
                actionLabel: profileBackendMessage[0].actionLabel,
                onActionPressed: _retryLoadProfileContent,
              );
            }

            final content = snapshot.data;
            if (content == null || content.isEmpty) {
              return BackendMessage(
                title: profileBackendMessage[1].title,
                message: profileBackendMessage[1].message,
              );
            }

            final info = content.info.isNotEmpty ? content.info.first : null;
            if (info == null) {
              return BackendMessage(
                title: profileBackendMessage[2].title,
                message: profileBackendMessage[2].message,
              );
            }
            if (_info == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _info = info);
              });
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ProfileController(image: info.image),
                    const SizedBox(height: 16),
                    Text(
                      info.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      info.description.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const ExperienceController(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(child: ResumeButton()),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ContaceButton(
                              onContactTap: widget.onContactTap,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ExperienceHistory(stories: content.story),
                    if (content.study.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      SectionTitle(
                        icon: dataSectionTitle[0].icon,
                        title: dataSectionTitle[0].title,
                      ),
                      const SizedBox(height: 10),
                      StudyTimeline(items: content.study),
                    ],
                    if (content.career.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      SectionTitle(
                        icon: dataSectionTitle[1].icon,
                        title: dataSectionTitle[1].title,
                      ),
                      const SizedBox(height: 10),
                      CareerTimeline(items: content.career),
                    ],
                    if (content.certification.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      SectionTitle(
                        icon: dataSectionTitle[2].icon,
                        title: dataSectionTitle[2].title,
                      ),
                      const SizedBox(height: 10),
                      CertificationCard(items: content.certification),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
