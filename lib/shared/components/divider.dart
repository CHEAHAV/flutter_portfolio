import 'package:flutter/material.dart';
import 'package:portfolio/shared/theme/colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.accent.withValues(alpha: 0.5),
      thickness: 1,
      height: 1,
    );
  }
}
