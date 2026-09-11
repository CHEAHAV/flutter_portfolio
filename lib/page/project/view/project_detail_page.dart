import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';
import '../../../web/controller/web_section.dart';
import '../controller/project_detail_bar.dart';
import '../controller/project_detail_content.dart';
import '../model/project_model.dart';

/// Case study for a single project. The phone keeps the app bar it shares
/// with every other detail page; tablet and desktop get the site header, the
/// centred content column and the two-column reading layout.
class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({
    super.key,
    List<dynamic>? projectModel,
    this.loadContent,
  });

  final Future<ApiModel> Function()? loadContent;

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();

  late final AnimationController _fadeController;
  late final Animation<double> _fade;
  late Future<ApiModel> _content;

  /// Set when the reader moves to a neighbouring case study, so the pager
  /// swaps projects in place instead of pushing another route.
  String? _selectedId;
  bool _scrolled = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _content = _load();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<ApiModel> _load() =>
      widget.loadContent?.call() ?? ApiRepository().loadApiModel();

  Future<void> _refresh() async {
    final future = _load();
    setState(() {
      _content = future;
    });
    // FutureBuilder shows a recoverable error if the refresh itself fails.
    try {
      await future;
    } catch (_) {}
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;

    final offset = _scroll.offset;
    final maxExtra = _scroll.position.maxScrollExtent;
    final scrolled = offset > 12;
    final progress = maxExtra <= 0 ? 0.0 : (offset / maxExtra).clamp(0.0, 1.0);

    if (scrolled != _scrolled || (progress - _progress).abs() > 0.004) {
      setState(() {
        _scrolled = scrolled;
        _progress = progress;
      });
    }
  }

  void _backToTop() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOutCubic,
    );
  }

  void _backToWork() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoute.skillPageRoute);
    }
  }

  void _openSite() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoute.homePageRoute);
    }
  }

  void _selectProject(Project project) {
    setState(() => _selectedId = project.id);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  /// `-1` when the requested record is no longer served by the backend.
  int _selectedIndex(List<Project> projects) {
    if (projects.isEmpty) return -1;

    final pinned = _selectedId;
    if (pinned != null) {
      final index = projects.indexWhere((project) => project.id == pinned);
      if (index >= 0) return index;
    }

    final arguments = ModalRoute.of(context)?.settings.arguments;
    String? id;
    int? index;
    if (arguments is String) {
      id = arguments;
    } else if (arguments is int) {
      index = arguments;
    } else if (arguments is Map) {
      if (arguments['id'] is String) id = arguments['id'] as String;
      if (arguments['index'] is int) index = arguments['index'] as int;
    }

    // A supplied ID wins over a list index that may have gone stale.
    if (id != null && id.trim().isNotEmpty) {
      return projects.indexWhere((project) => project.id == id);
    }

    final selected = index ?? 0;
    return selected >= 0 && selected < projects.length ? selected : -1;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return FutureBuilder<ApiModel>(
      future: _content,
      builder: (context, snapshot) {
        final content = snapshot.data;
        final info = content != null && content.info.isNotEmpty
            ? content.info.first
            : null;

        return Scaffold(
          backgroundColor: AppColors.bgDeep,
          appBar: isMobile
              ? MyAppBar(
                  info: info,
                  index: 4,
                  contactme: content?.contactme ?? const [],
                )
              : null,
          body: Stack(
            children: [
              const Positioned.fill(child: AuroraBackground()),
              Positioned.fill(child: _body(context, snapshot)),
              if (!isMobile)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ProjectDetailBar(
                    scrolled: _scrolled,
                    progress: _progress,
                    onBrandTap: _openSite,
                    onBackToWork: _backToWork,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, AsyncSnapshot<ApiModel> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(semanticsLabel: projectLoadingLabel),
      );
    }

    if (snapshot.hasError) {
      return BackendMessage(
        title: projectErrorTitle,
        message: projectErrorMessage,
        actionLabel: projectRetryAction,
        onActionPressed: _refresh,
      );
    }

    final projects = snapshot.data?.project ?? const <Project>[];
    final index = _selectedIndex(projects);
    if (index < 0) {
      return BackendMessage(
        title: projectMissingTitle,
        message: projectMissingDetail,
        actionLabel: projectBackToWork,
        onActionPressed: _backToWork,
      );
    }

    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop;
    final padding = isMobile
        ? const EdgeInsets.fromLTRB(20, 26, 20, 44)
        : ResponsiveInsets.page(context).copyWith(
            top: WebSection.navHeight + (isDesktop ? 46 : 34),
            bottom: isDesktop ? 76 : 56,
          );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          child: ProjectDetailContent(
            project: projects[index],
            index: index,
            previous: index > 0 ? projects[index - 1] : null,
            next: index < projects.length - 1 ? projects[index + 1] : null,
            onSelectProject: _selectProject,
            onBackToWork: _backToWork,
            onBackToTop: _backToTop,
          ),
        ),
      ),
    );
  }
}
