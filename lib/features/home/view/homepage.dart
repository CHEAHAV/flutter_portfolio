import 'package:flutter/material.dart';
import '../../home/home.dart';
import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.homeBackendMessage,
    this.onContactTap,
    this.onProfileTap,
  });

  final List<HomeBackendMessage> homeBackendMessage;
  final VoidCallback? onContactTap;
  final VoidCallback? onProfileTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late AnimationController controller;
  late Animation<double> fadeIn;
  late Future<ApiModel> apiModelFuture;
  Info? _info;
  String _searchQuery = '';

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
  void dispose() {
    controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<ApiModel> loadApiModel() {
    return ApiRepository().loadApiModel();
  }

  void _retryLoadHomeContent() {
    setState(() {
      apiModelFuture = loadApiModel();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });
  }

  void _clearSearch() {
    searchController.clear();
    _onSearchChanged('');
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
        appBar: MyAppBar(
          info: _info,
          index: 0,
          onProfileTap: widget.onProfileTap,
          contactme: [],
        ),
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
              final skills = content.skill;
              final mycore = content.mycore;
              final projects = content.project;
              final filteredSkills = _searchQuery.isEmpty
                  ? skills
                  : skills
                      .where(
                        (skill) =>
                            skill.name.toLowerCase().contains(_searchQuery),
                      )
                      .toList();
              final filteredProjects = _searchQuery.isEmpty
                  ? projects
                  : projects
                      .where(
                        (project) =>
                            project.name.toLowerCase().contains(_searchQuery),
                      )
                      .toList();
              final info = content.info.isNotEmpty ? content.info.first : null;
              if (info == null) {
                return BackendMessage(
                  title: homeBackendMessage[2].title,
                  message: homeBackendMessage[2].message,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSearchBar(
                        controller: searchController,
                        hinttext: 'Search Projects & Skills...',
                        prefixicon: const Icon(Icons.search, size: 24),
                        onChanged: _onSearchChanged,
                        onClear: _clearSearch,
                      ),
                      const SizedBox(height: 10),
                      if (filteredSkills.isNotEmpty)
                        MyFilterSkill(
                          skills: filteredSkills,
                          onSkillDetailPage: (index) {
                            Navigator.pushNamed(
                              context,
                              AppRoute.skillDetailRoute,
                              arguments: {
                                'id': filteredSkills[index].id,
                                'index': skills.indexOf(filteredSkills[index]),
                              },
                            );
                          },
                        ),
                      if (_searchQuery.isNotEmpty &&
                          filteredSkills.isEmpty &&
                          filteredProjects.isEmpty) ...[
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'No projects or skills found.',
                            style: AppStyle.bodyMedium,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      MyInfo(info: info, onContactTap: widget.onContactTap),
                      if (mycore.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text("My Core Competencies", style: AppStyle.headline3),
                        const SizedBox(height: 10),
                        MyCoreList(mycore: mycore),
                      ],
                      if (filteredProjects.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text("Featured Project", style: AppStyle.headline3),
                        MyprojectList(
                          projects: filteredProjects,
                          onProjectDetailPage: (index) {
                            Navigator.pushNamed(
                              context,
                              AppRoute.projectDetailRoute,
                              arguments: {
                                'id': filteredProjects[index].id,
                                'index': projects.indexOf(
                                  filteredProjects[index],
                                ),
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
