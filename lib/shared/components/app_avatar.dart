import 'package:flutter/material.dart';
import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/shared/theme/colors.dart';

class AppAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const AppAvatar({super.key, required this.imageUrl, this.radius = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: CircleAvatar(
            backgroundImage: ApiImage.imageProviderFor(
              imageUrl,
              fallbackAsset: 'assets/images/profile.png',
            ),
            radius: radius,
          ),
        ),
      ),
    );
  }
}
