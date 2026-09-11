import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../shared/shared.dart';
import '../../../web/controller/web_buttons.dart';
import '../../../web/controller/web_detail_chrome.dart';
import '../../../web/controller/web_section.dart';
import '../../../web/model/web_text.dart';
import '../model/project_model.dart';

typedef ProjectLinkOpener = Future<bool> Function(String url);

/// The case study body. One widget serves every breakpoint: the phone reads
/// it as a single column, the desktop splits the narrative from the facts
/// panel, and both share the type scale used by the rest of the site.
class ProjectDetailContent extends StatelessWidget {
  const ProjectDetailContent({
    super.key,
    required this.project,
    required this.index,
    this.previous,
    this.next,
    this.onSelectProject,
    this.onBackToWork,
    this.onBackToTop,
    this.openLink,
  });

  final Project project;
  final int index;
  final Project? previous;
  final Project? next;
  final ValueChanged<Project>? onSelectProject;
  final VoidCallback? onBackToWork;
  final VoidCallback? onBackToTop;
  final ProjectLinkOpener? openLink;

  bool get _hasLiveLink => project.projecturl.trim().isNotEmpty;

  Future<void> _openLive(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final opener = openLink ?? ExternalLink.open;

    var opened = false;
    try {
      opened = await opener(project.projecturl);
    } catch (_) {
      opened = false;
    }

    if (!opened) {
      messenger.showSnackBar(const SnackBar(content: Text(webLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isMobile = context.isMobile;

    final narrative = SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectNarrativeBlock(
            title: projectModel[3].label,
            body: project.description,
          ),
          const SizedBox(height: 40),
          ProjectNarrativeBlock(
            title: projectModel[4].label,
            body: project.challenge,
          ),
        ],
      ),
    );

    final facts = ProjectFactsPanel(
      project: project,
      onOpenLive: _hasLiveLink ? () => _openLive(context) : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailBreadcrumb(
          rootLabel: projectCrumbRoot,
          name: project.name,
          onRootTap: onBackToWork,
        ),
        SizedBox(height: isMobile ? 18 : 26),
        _hero(context),
        SizedBox(height: isDesktop ? 56 : 36),
        ProjectCover(project: project, index: index),
        SizedBox(height: isDesktop ? 64 : 40),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: narrative),
              const SizedBox(width: 56),
              Expanded(flex: 4, child: facts),
            ],
          )
        else ...[
          facts,
          const SizedBox(height: 40),
          narrative,
        ],
        SizedBox(height: isDesktop ? 96 : 64),
        ProjectPager(
          previous: previous,
          next: next,
          onSelectProject: onSelectProject,
        ),
        SizedBox(height: isDesktop ? 72 : 48),
        DetailFooterStrip(onBackToTop: onBackToTop),
      ],
    );
  }

  Widget _hero(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isMobile = context.isMobile;
    final tags = webProjectTags(project);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 22, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                '${projectCaseLabel.toUpperCase()} · ${webIndexLabel(index)}',
                style: AppStyle.label.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SelectionArea(
          child: Text(
            project.name,
            style: AppStyle.headline1.copyWith(
              fontSize: isDesktop ? 46 : (isMobile ? 30 : 38),
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((tag) => WebChip(label: tag, filled: true))
                .toList(),
          ),
        ],
        const SizedBox(height: 30),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            if (_hasLiveLink)
              WebPrimaryButton(
                label: projectLiveAction,
                icon: Icons.north_east,
                dense: isMobile,
                onPressed: () => _openLive(context),
              ),
            if (onBackToWork != null)
              WebGhostButton(
                label: projectBackToWork,
                icon: Icons.arrow_back,
                dense: isMobile,
                onPressed: onBackToWork!,
              ),
          ],
        ),
      ],
    );
  }
}


/// Full-bleed cover art for the case study. Tapping it — or the magnifier
/// badge — opens a zoomable lightbox so screenshot detail is never stuck at
/// the card's fixed size.
class ProjectCover extends StatefulWidget {
  const ProjectCover({super.key, required this.project, required this.index});

  final Project project;
  final int index;

  @override
  State<ProjectCover> createState() => _ProjectCoverState();
}

class _ProjectCoverState extends State<ProjectCover> {
  bool _hovered = false;

  ImageProvider get _image => ApiImage.imageProviderFor(
    widget.project.image,
    fallbackAsset: 'assets/images/computer.png',
  );

  void _openZoom() {
    showZoomableImage(
      context,
      image: _image,
      title: widget.project.name,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/computer.png', fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppStyle.radiusLg + 4);

    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _openZoom,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.42),
                  blurRadius: 42,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: AspectRatio(
                aspectRatio: context.responsive(
                  mobile: 4 / 3,
                  tablet: 16 / 9,
                  desktop: 16 / 9,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(
                      image: _image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                            'assets/images/computer.png',
                            fit: BoxFit.cover,
                          ),
                    ),
                    // Keeps the counter badge legible over a bright screenshot.
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.35, 1],
                          colors: [
                            AppColors.bgDeep.withValues(alpha: 0.42),
                            AppColors.bgDeep.withValues(alpha: 0.04),
                            AppColors.bgDeep.withValues(alpha: 0.32),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      top: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgDeep.withValues(alpha: 0.82),
                          borderRadius: BorderRadius.circular(
                            AppStyle.radiusSm,
                          ),
                          border: Border.all(color: AppColors.tileBorder),
                        ),
                        child: Text(
                          webIndexLabel(widget.index),
                          style: AppStyle.label.copyWith(
                            color: AppColors.accent,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 18,
                      top: 18,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 160),
                        opacity: _hovered ? 1 : 0.72,
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.bgDeep.withValues(alpha: 0.82),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.tileBorder),
                          ),
                          child: const Icon(
                            Icons.zoom_in_rounded,
                            size: 18,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Accent-ruled heading with its paragraph, used for Overview and Challenge.
class ProjectNarrativeBlock extends StatelessWidget {
  const ProjectNarrativeBlock({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = body.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Text(
                title,
                style: AppStyle.headline2.copyWith(
                  fontSize: context.isMobile ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          text.isEmpty ? '—' : text,
          style: AppStyle.bodyLarge.copyWith(
            color: AppColors.textSub,
            height: 1.85,
          ),
        ),
      ],
    );
  }
}

/// Duration, role and platform in one panel beside the narrative.
class ProjectFactsPanel extends StatelessWidget {
  const ProjectFactsPanel({super.key, required this.project, this.onOpenLive});

  final Project project;
  final VoidCallback? onOpenLive;

  @override
  Widget build(BuildContext context) {
    final facts = <ProjectModel, String>{
      projectModel[0]: project.duration,
      projectModel[1]: project.role,
      projectModel[2]: project.platform,
    }..removeWhere((key, value) => value.trim().isEmpty);

    return WebCard(
      padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            projectFactsTitle.toUpperCase(),
            style: AppStyle.label.copyWith(
              color: AppColors.textSub,
              fontSize: 10,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 22),
          if (facts.isEmpty)
            Text(
              '—',
              style: AppStyle.bodyMedium.copyWith(color: AppColors.textSub),
            )
          // The tablet panel spans the full column, so the facts read across
          // it instead of stacking against a wide empty margin.
          else if (context.isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in facts.entries) ...[
                  if (entry.key != facts.keys.first) const SizedBox(width: 20),
                  Expanded(
                    child: DetailFactRow(
                      icon: entry.key.icon,
                      label: entry.key.label,
                      value: entry.value,
                    ),
                  ),
                ],
              ],
            )
          else
            ...facts.entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == facts.keys.last ? 0 : 18,
                ),
                child: DetailFactRow(
                  icon: entry.key.icon,
                  label: entry.key.label,
                  value: entry.value,
                ),
              ),
            ),
          const SizedBox(height: 24),
          const AppDivider(),
          const SizedBox(height: 20),
          if (onOpenLive != null)
            WebTextLink(
              label: projectVisitAction,
              icon: Icons.north_east,
              onTap: onOpenLive!,
            )
          else
            Text(
              projectNoLiveLink,
              style: AppStyle.bodySmall.copyWith(
                color: AppColors.textSub,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}

/// Previous / next case study, so the reader never dead-ends.
class ProjectPager extends StatelessWidget {
  const ProjectPager({
    super.key,
    this.previous,
    this.next,
    this.onSelectProject,
  });

  final Project? previous;
  final Project? next;
  final ValueChanged<Project>? onSelectProject;

  @override
  Widget build(BuildContext context) {
    if (previous == null && next == null) return const SizedBox.shrink();

    final cards = <Widget>[
      if (previous != null)
        ProjectPagerCard(
          tag: projectPreviousTag,
          project: previous!,
          isNext: false,
          onTap: () => onSelectProject?.call(previous!),
        ),
      if (next != null)
        ProjectPagerCard(
          tag: projectNextTag,
          project: next!,
          isNext: true,
          onTap: () => onSelectProject?.call(next!),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 22, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                projectMoreLabel.toUpperCase(),
                style: AppStyle.label.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (context.isMobile)
          Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                cards[i],
              ],
            ],
          )
        else
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: 20),
                  Expanded(child: cards[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class ProjectPagerCard extends StatefulWidget {
  const ProjectPagerCard({
    super.key,
    required this.tag,
    required this.project,
    required this.isNext,
    required this.onTap,
  });

  final String tag;
  final Project project;
  final bool isNext;
  final VoidCallback onTap;

  @override
  State<ProjectPagerCard> createState() => _ProjectPagerCardState();
}

class _ProjectPagerCardState extends State<ProjectPagerCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final arrow = AnimatedSlide(
      duration: const Duration(milliseconds: 180),
      offset: _hovered ? Offset(widget.isNext ? 0.25 : -0.25, 0) : Offset.zero,
      child: Icon(
        widget.isNext ? Icons.arrow_forward : Icons.arrow_back,
        size: 18,
        color: _hovered ? AppColors.accent : AppColors.textSub,
      ),
    );

    final label = Column(
      crossAxisAlignment: widget.isNext
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.tag.toUpperCase(),
          style: AppStyle.bodySmall.copyWith(
            color: AppColors.textSub,
            fontFamily: 'JetBrainsMono',
            fontSize: 9,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          widget.project.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: widget.isNext ? TextAlign.end : TextAlign.start,
          style: AppStyle.bodyLarge.copyWith(
            color: _hovered ? AppColors.accent : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
      ],
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: WebCard(
          hovered: _hovered,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Row(
            children: widget.isNext
                ? [Expanded(child: label), const SizedBox(width: 14), arrow]
                : [arrow, const SizedBox(width: 14), Expanded(child: label)],
          ),
        ),
      ),
    );
  }
}

