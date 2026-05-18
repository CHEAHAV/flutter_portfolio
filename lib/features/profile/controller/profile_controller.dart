import 'package:flutter/material.dart';
import 'package:portfolio/features/home/model/home_model.dart';
import 'package:portfolio/shared/theme/colors.dart';

class ProfileController extends StatelessWidget {
  const ProfileController({super.key});

  @override
  Widget build(BuildContext context) {
    HomeModel homeModel = HomeModel();
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
              backgroundImage: AssetImage(homeModel.info.image),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.accentGlow,
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
