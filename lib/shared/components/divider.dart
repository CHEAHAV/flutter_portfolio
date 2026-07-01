import 'package:flutter/material.dart';
import '../../shared/shared.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.bgCard,
            AppColors.accent.withValues(alpha: 0.5),
            AppColors.bgCard,
          ],
        ),
      ),
    );
  }
}
