import 'package:flutter/material.dart';
import 'package:portfolio/shared/theme/colors.dart';

class MetaItem extends StatelessWidget {
  const MetaItem({super.key, 
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.accentGlow,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
