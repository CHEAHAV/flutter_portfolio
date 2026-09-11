import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class MyCoreList extends StatelessWidget {
  const MyCoreList({super.key, required this.mycore, this.onMyCoreDetailPage});

  final List<MyCore> mycore;
  final void Function(int index)? onMyCoreDetailPage;

  @override
  Widget build(BuildContext context) {
    if (mycore.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mycore.length,
        itemBuilder: (context, index) {
          final item = mycore[index];
          return GestureDetector(
            onTap: () {
              if (onMyCoreDetailPage != null) {
                onMyCoreDetailPage!(index);
                return;
              }
              Navigator.pushNamed(
                context,
                AppRoute.mycoreDetailRoute,
                arguments: index,
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppStyle.radiusLg + 2),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.34),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                    spreadRadius: -8,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image(
                      image: ApiImage.imageProviderFor(
                        item.image,
                        fallbackAsset: 'assets/icons/backend.png',
                      ),
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/icons/backend.png',
                          width: 24,
                          height: 24,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    style: AppStyle.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
