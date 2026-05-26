
import 'package:flutter/material.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class MetaTile extends StatelessWidget {
  const MetaTile({super.key, 
    this.icon,
    required this.label,
    required this.value,
  });

  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppStyle.radiusLg),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.textSub),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppStyle.bodySmall.copyWith(
              color: AppColors.textSub,
              fontSize: 10,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppStyle.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}