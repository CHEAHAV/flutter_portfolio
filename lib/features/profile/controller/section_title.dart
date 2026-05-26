
import 'package:flutter/material.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent),
        const SizedBox(width: 5),
        Text(
          '// $title',
          style: AppStyle.labelLarge.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}