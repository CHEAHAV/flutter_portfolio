import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../features/home/home.dart';
import '../../certificate/certificate.dart';
import '../../project/project.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key, required List<dynamic> projectModel});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeIn;
  late Future<ApiModel> apiModelFuture;
  Info? _info;
  int? _projectIndex;
  String? _projectId;

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
      _projectIndex = arguments;
    } else if (arguments is String) {
      _projectId = arguments;
    } else if (arguments is Map<String, dynamic>) {
      final id = arguments['id'];
      final index = arguments['index'];
      if (id is String && id.isNotEmpty) {
        _projectId = id;
      }
      if (index is int) {
        _projectIndex = index;
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<ApiModel> loadApiModel() => ApiRepository().loadApiModel();

  void _retryLoadHomeContent() {
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
        appBar: MyAppBar(info: _info, index: 4, contactme: []),
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
                  title: homeBackendMessage[0].title,
                  message: homeBackendMessage[0].message,
                  actionLabel: homeBackendMessage[0].actionLabel,
                  onActionPressed: _retryLoadHomeContent,
                );
              }
              final content = snapshot.data;
              if (content == null || content.isEmpty) {
                return BackendMessage(
                  title: homeBackendMessage[1].title,
                  message: homeBackendMessage[1].message,
                );
              }
              final info = content.info.isNotEmpty ? content.info.first : null;
              if (info == null) {
                return BackendMessage(
                  title: homeBackendMessage[2].title,
                  message: homeBackendMessage[2].message,
                );
              }
              final projects = content.project;
              final indexById = _projectId == null
                  ? -1
                  : projects.indexWhere((project) => project.id == _projectId);
              final selectedIndex = indexById >= 0
                  ? indexById
                  : (_projectIndex ?? 0);
              if (projects.isEmpty ||
                  selectedIndex < 0 ||
                  selectedIndex >= projects.length) {
                return BackendMessage(
                  title: homeBackendMessage[3].title,
                  message: homeBackendMessage[3].message,
                );
              }
              final project = projects[selectedIndex];
              if (_info == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _info = info);
                });
              }

              return SingleChildScrollView(
                padding: ResponsiveInsets.page(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProjectCard(project: project),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: MetaTile(
                              icon: projectModel[0].icon,
                              label: projectModel[0].label,
                              value: project.duration,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MetaTile(
                              icon: projectModel[1].icon,
                              label: projectModel[1].label,
                              value: project.role,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 250,
                          child: MetaTile(
                            icon: projectModel[2].icon,
                            label: projectModel[2].label,
                            value: project.platform,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentCyan,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    projectModel[3].label,
                                    style: AppStyle.headline2.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  project.description,
                                  style: AppStyle.bodyMedium.copyWith(
                                    color: AppColors.textSub,
                                    height: 1.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentCyan,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    projectModel[4].label,
                                    style: AppStyle.headline2.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  project.challenge,
                                  style: AppStyle.bodyMedium.copyWith(
                                    color: AppColors.textSub,
                                    height: 1.7,
                                  ),
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
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: ActionButton(
                            icon: actionButtonModel[2].icon,
                            label: actionButtonModel[2].label,
                            onTap: () async {
                              await ExternalLink.open(project.projecturl);
                            },
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: ActionButton(
                            icon: actionButtonModel[1].icon,
                            label: actionButtonModel[1].label,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.homePageRoute,
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
