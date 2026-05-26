import 'package:flutter/material.dart';
import 'package:portfolio/api/repository/api_repository.dart';
import 'package:portfolio/api/model/api_model.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/features/skill/controller/dev_story.dart';
import 'package:portfolio/features/skill/model/skillbackend_message.dart';
import 'package:portfolio/shared/components/backend_message.dart';
import 'package:portfolio/shared/components/myapp_bar.dart';
import 'package:portfolio/shared/components/profile_card.dart';
import 'package:portfolio/features/skill/controller/detailed_expertise_card.dart';
import 'package:portfolio/features/skill/controller/skill_title.dart';
import 'package:portfolio/shared/theme/colors.dart';

class SkillPage extends StatefulWidget {
  const SkillPage({
    super.key,
    required this.skillBackendMessage,
    this.onProfileTap,
  });

  final List<SkillbackendMessage> skillBackendMessage;
  final VoidCallback? onProfileTap;

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Future<ApiModel> apiModelFuture;
  Info? _info;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    apiModelFuture = loadApiModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<ApiModel> loadApiModel() {
    return ApiRepository().loadApiModel();
  }

  void _retryLoadSkillContent() {
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
          index: 1,
          onProfileTap: widget.onProfileTap,
        ),
        body: FadeTransition(
          opacity: _fadeIn,
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

              final teachStack = content.teachstack.isNotEmpty
                  ? content.teachstack.first
                  : null;
              final info = content.info.isNotEmpty ? content.info.first : null;
              if (_info == null && info != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _info = info);
                });
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.accent, Color(0xFFB0C4FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'My Teach Stack',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (teachStack != null && info != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SkillTile(
                            assetPath: teachStack.imageleft,
                            label: teachStack.nameleft.toUpperCase(),
                          ),
                          const SizedBox(width: 12),
                          ProfileCard(assetPath: info.image),
                          const SizedBox(width: 12),
                          SkillTile(
                            assetPath: teachStack.imageright,
                            label: teachStack.nameright.toUpperCase(),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (info != null)
                      Text(
                        info.name,
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
                    DetailedExpertiseCard(
                      skill: content.skill,
                      project: content.project,
                      certification: content.certification,
                    ),
                    const SizedBox(height: 20),
                    DevStory(stories: content.story),
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
