import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../shared/shared.dart';

class ProfileController extends StatelessWidget {
  const ProfileController({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentGlow, width: 2),
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundImage: ApiImage.imageProviderFor(
                image,
                fallbackAsset: 'assets/images/profile.png',
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.card, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
