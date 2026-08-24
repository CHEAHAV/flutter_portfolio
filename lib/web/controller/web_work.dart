import 'package:flutter/material.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../shared/shared.dart';

class WebWork extends StatelessWidget {
  const WebWork({
    super.key,
    required this.projects,
    required this.onProjectTap,
  });

  final List<Project> projects;
  final void Function(int index) onProjectTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WebHeading(
          label: webWorkLabel,
          title: webWorkTitle,
          lead : webWorkLead,
        ),
        const SizedBox(height: 52),
        if (projects.isEmpty)
          Text(webNoProject, style: AppStyle.bodyMedium)
        else
          ...List.generate(projects.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == projects.length - 1
                    ? 0
                    : (isDesktop ? 72 : 48),
              ),
              child: WebProjectRow(
                project: projects[index],
                index  : index,
                onTap  : () => onProjectTap(index),
              ),
            );
          }),
      ],
    );
  }
}

class WebProjectRow extends StatefulWidget {
  const WebProjectRow({
    super.key,
    required this.project,
    required this.index,
    required this.onTap,
  });

  final Project project;
  final int index;
  final VoidCallback onTap;

  @override
  State<WebProjectRow> createState() => _WebProjectRowState();
}

class _WebProjectRowState extends State<WebProjectRow> {
  bool _hovered = false;

  Future<void> _openLive() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!await ExternalLink.open(widget.project.projecturl)) {
      messenger.showSnackBar(const SnackBar(content: Text(webLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final project   = widget.project;
    final isDesktop = context.isDesktop;
    final flipped   = isDesktop && widget.index.isOdd;

    final preview = MouseRegion(
      cursor : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap   : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppStyle.radiusLg),
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.divider,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColors.accentGlow
                    : Colors.black.withValues(alpha: 0.34),
                blurRadius: _hovered ? 34 : 22,
                offset    : const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppStyle.radiusLg - 1),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 420),
                    curve   : Curves.easeOut,
                    scale   : _hovered ? 1.05 : 1.0,
                    child: Image(
                      image: ApiImage.imageProviderFor(
                        project.image,
                        fallbackAsset: 'assets/images/computer.png',
                      ),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/computer.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin : Alignment.topCenter,
                        end   : Alignment.bottomCenter,
                        colors: [
                          AppColors.bgDeep.withValues(alpha: 0.05),
                          AppColors.bgDeep.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top : 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical  : 5,
                      ),
                      decoration: BoxDecoration(
                        color       : AppColors.bgDeep.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(AppStyle.radiusSm),
                        border      : Border.all(color: AppColors.tileBorder),
                      ),
                      child: Text(
                        webIndexLabel(widget.index),
                        style: AppStyle.label.copyWith(
                          color   : AppColors.accent,
                          fontSize: 10,
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
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize      : MainAxisSize.min,
      children: [
        if (webProjectTags(project).isNotEmpty) ...[
          Wrap(
            spacing   : 8,
            runSpacing: 8,
            children: webProjectTags(project)
                .map((tag) => WebChip(label: tag, filled: true))
                .toList(),
          ),
          const SizedBox(height: 20),
        ],
        Text(
          project.name,
          style: AppStyle.headline1.copyWith(
            fontSize     : isDesktop ? 30 : 24,
            height       : 1.2,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          project.description,
          style: AppStyle.bodyLarge.copyWith(
            color : AppColors.textSub,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 24),
        WebProjectMeta(project: project),
        const SizedBox(height: 26),
        Wrap(
          spacing   : 28,
          runSpacing: 14,
          children: [
            WebTextLink(label: webWorkAction, onTap: widget.onTap),
            if (project.projecturl.trim().isNotEmpty)
              WebTextLink(
                label: webWorkLive,
                icon : Icons.north_east,
                color: AppColors.textSub,
                onTap: _openLive,
              ),
          ],
        ),
      ],
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [preview, const SizedBox(height: 28), details],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: flipped
          ? [
              Expanded(flex: 5, child: details),
              const SizedBox(width: 56),
              Expanded(flex: 6, child: preview),
            ]
          : [
              Expanded(flex: 6, child: preview),
              const SizedBox(width: 56),
              Expanded(flex: 5, child: details),
            ],
    );
  }
}

class WebProjectMeta extends StatelessWidget {
  const WebProjectMeta({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final entries = <String, String>{
      webMetaDuration: project.duration,
      webMetaRole    : project.role,
      webMetaPlatform: project.platform,
    }..removeWhere((key, value) => value.trim().isEmpty);

    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      width  : double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          top   : BorderSide(color: AppColors.divider),
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Wrap(
        spacing   : 36,
        runSpacing: 16,
        children: entries.entries
            .map(
              (entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize      : MainAxisSize.min,
                children: [
                  Text(
                    entry.key.toUpperCase(),
                    style: AppStyle.bodySmall.copyWith(
                      color        : AppColors.textSub,
                      fontFamily   : 'JetBrainsMono',
                      fontSize     : 9,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.value,
                    style: AppStyle.bodyMedium.copyWith(
                      color     : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
