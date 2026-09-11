import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../page/project/project.dart';
import '../../../routes/route.dart';

class MyprojectList extends StatelessWidget {
  const MyprojectList({
    super.key,
    required this.projects,
    this.onProjectDetailPage,
  });

  final List<Project> projects;
  final void Function(int index)? onProjectDetailPage;

  void _openProject(BuildContext context, int index) {
    if (onProjectDetailPage != null) {
      onProjectDetailPage!(index);
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoute.projectDetailRoute,
      arguments: {'id': projects[index].id, 'index': index},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          for (var index = 0; index < projects.length; index++) ...[
            if (index > 0) const SizedBox(height: 16),
            ProjectRowCard(
              project: projects[index],
              index: index,
              onTap: () => _openProject(context, index),
            ),
          ],
        ],
      ),
    );
  }
}
