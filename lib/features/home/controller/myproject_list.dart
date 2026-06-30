import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class MyprojectList extends StatelessWidget {
  const MyprojectList({
    super.key,
    required this.projects,
    this.onContactTap,
    this.onProjectDetailPage,
  });

  final List<Project> projects;
  final VoidCallback? onContactTap;
  final void Function(int index)? onProjectDetailPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final item = projects[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor),
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
        },
      ),
    );
  }
}
