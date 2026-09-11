import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../page/project/project.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({
    super.key,
    required this.project,
    this.onProjectDetailPage,
  });

  final List<Project> project;
  final void Function(int index)? onProjectDetailPage;

  void _openProject(BuildContext context, int index) {
    if (onProjectDetailPage != null) {
      onProjectDetailPage!(index);
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoute.projectDetailRoute,
      arguments: {'id': project[index].id, 'index': index},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (project.isEmpty) {
      return Text(
        projectEmptyMessage,
        style: AppStyle.bodySmall.copyWith(color: AppColors.textSub),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < project.length; index++) ...[
          if (index > 0) const SizedBox(height: 16),
          ProjectRowCard(
            project: project[index],
            index: index,
            onTap: () => _openProject(context, index),
          ),
        ],
      ],
    );
  }
}
