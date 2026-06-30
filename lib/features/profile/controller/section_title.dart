
import 'package:flutter/material.dart';
import '../../../shared/shared.dart';

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