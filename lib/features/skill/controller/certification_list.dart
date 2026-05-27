import 'package:flutter/material.dart';
import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/model/certification.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class CertificationList extends StatelessWidget {
  const CertificationList({
    super.key,
    required this.certification,
    this.onCertificateDetailPage,
  });
  final List<Certification> certification;
  final void Function(int index)? onCertificateDetailPage;

  @override
  Widget build(BuildContext context) {
    if (certification.isEmpty) {
      return const Text(
        'No backend project yet.',
        style: TextStyle(color: AppColors.textSub, fontSize: 13),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(certification.length, (index) {
        final item = certification[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppStyle.radiusLg),
              border: Border.all(color: AppColors.divider, width: 1),
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
                if (onCertificateDetailPage != null) {
                  onCertificateDetailPage!(index);
                  return;
                }
                Navigator.pushNamed(
                  context,
                  AppRoute.certificateDetailRoute,
                  arguments: index,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.bgTile,
                      borderRadius: BorderRadius.circular(AppStyle.radiusMd),
                      border: Border.all(color: AppColors.tileBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppStyle.radiusSm),
                        child: Image(
                          image: ApiImage.imageProviderFor(
                            item.icon,
                            fallbackAsset: 'assets/images/computer.png',
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/icons/resume.png',
                              color: AppColors.accent,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.bodySmall.copyWith(
                      color: AppColors.textSub,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
