import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../shared/shared.dart';

class ProfileCard extends StatelessWidget {
  final String assetPath;

  const ProfileCard({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2A6B), Color(0xFF0D1535)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.35),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow,
            blurRadius: 28,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image(
          image: ApiImage.imageProviderFor(
            assetPath,
            fallbackAsset: 'assets/images/profile.png',
          ),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/profile.png', fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}
