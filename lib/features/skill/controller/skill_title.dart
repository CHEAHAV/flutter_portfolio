import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../shared/shared.dart';

class SkillTile extends StatelessWidget {
  final String assetPath;
  final String label;

  const SkillTile({super.key, required this.assetPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.bgTile,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.tileBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow,
            blurRadius: 16,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: ApiImage.imageProviderFor(
              assetPath,
              fallbackAsset: 'assets/icons/flutter.png',
            ),
            width: 36,
            height: 36,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/icons/flutter.png',
                width: 36,
                height: 36,
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSub,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
