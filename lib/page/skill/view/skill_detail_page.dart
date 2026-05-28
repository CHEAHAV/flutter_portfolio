import 'package:flutter/material.dart';
import 'package:portfolio/api/model/api_model.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/api/repository/api_repository.dart';
import 'package:portfolio/features/skill/model/skillbackend_message.dart';
import 'package:portfolio/page/certificate/controller/action_button.dart';
import 'package:portfolio/page/certificate/model/action_button_model.dart';
import 'package:portfolio/page/skill/controller/skill_card.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/components/backend_message.dart';
import 'package:portfolio/shared/components/myapp_bar.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class SkillDetailPage extends StatefulWidget {
  const SkillDetailPage({super.key, required List<dynamic> projectModel});

  @override
  State<SkillDetailPage> createState() => _SkillDetailPageState();
}

class _SkillDetailPageState extends State<SkillDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeIn;
  late Future<ApiModel> apiModelFuture;
  Info? _info;
  int? skillIndex;
  String? skillId;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    fadeIn = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    apiModelFuture = loadApiModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is int) {
      skillIndex = arguments;
    } else if (arguments is String) {
      skillId = arguments;
    } else if (arguments is Map<String, dynamic>) {
      final id = arguments['id'];
      final index = arguments['index'];
      if (id is String && id.isNotEmpty) {
        skillId = id;
      }
      if (index is int) {
        skillIndex = index;
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<ApiModel> loadApiModel() => ApiRepository().loadApiModel();

  void _retryLoadSkillContent() {
    setState(() {
      apiModelFuture = loadApiModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => apiModelFuture = loadApiModel());
        await apiModelFuture;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: MyAppBar(info: _info, index: 1, contactme: []),
        body: FadeTransition(
          opacity: fadeIn,
          child: FutureBuilder<ApiModel>(
            future: apiModelFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return BackendMessage(
                  title: skillBackendMessage[0].title,
                  message: skillBackendMessage[0].message,
                  actionLabel: skillBackendMessage[0].actionLabel,
                  onActionPressed: _retryLoadSkillContent,
                );
              }

              final content = snapshot.data;
              if (content == null || content.isEmpty) {
                return BackendMessage(
                  title: skillBackendMessage[1].title,
                  message: skillBackendMessage[1].message,
                );
              }

              final info = content.info.isNotEmpty ? content.info.first : null;
              final skills = content.skill;
              final indexById = skillId == null
                  ? -1
                  : skills.indexWhere((skill) => skill.id == skillId);
              final selectedIndex = indexById >= 0
                  ? indexById
                  : (skillIndex ?? 0);
              if (skills.isEmpty ||
                  selectedIndex < 0 ||
                  selectedIndex >= skills.length) {
                return BackendMessage(
                  title: skillBackendMessage[1].title,
                  message: skillBackendMessage[1].message,
                );
              }

              final skill = skills[selectedIndex];
              if (_info == null && info != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _info = info);
                });
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkillCard(skill: skill),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(
                            AppStyle.radiusLg,
                          ),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Skill Score',
                                    style: AppStyle.bodyLarge.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${skill.score}/5',
                                    style: AppStyle.bodyLarge.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  minHeight: 8,
                                  value: (skill.score / 5).clamp(0, 1),
                                  backgroundColor: AppColors.divider,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppColors.accent,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'About ${skill.name}',
                                style: AppStyle.headline2.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                skill.description,
                                style: AppStyle.bodyMedium.copyWith(
                                  color: AppColors.textSub,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: ActionButton(
                            icon: actionButtonModel[1].icon,
                            label: actionButtonModel[1].label,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.skillPageRoute,
                              );
                            },
                            filled: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
