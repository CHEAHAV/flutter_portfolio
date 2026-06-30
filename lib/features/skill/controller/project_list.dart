import 'package:flutter/material.dart';
import '../../../api/api.dart';
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

  @override
  Widget build(BuildContext context) {
    if (project.isEmpty) {
      return const Text(
        'No backend project yet.',
        style: TextStyle(color: AppColors.textSub, fontSize: 13),
      );
    }

    return Column(
      children: List.generate(project.length, (index) {
        final item = project[index];
        return Container(
          margin: EdgeInsets.only(bottom: index == project.length - 1 ? 0 : 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.32),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              if (onProjectDetailPage != null) {
                onProjectDetailPage!(index);
                return;
              }
              Navigator.pushNamed(
                context,
                AppRoute.projectDetailRoute,
                arguments: {'id': item.id, 'index': index},
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: ApiImage.imageProviderFor(
                      item.image,
                      fallbackAsset: 'assets/images/computer.png',
                    ),
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/computer.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppStyle.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        style: AppStyle.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
