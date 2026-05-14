import 'package:flutter/material.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton( // ← now this refers to Flutter's TextButton, not itself
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.primary),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primary.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
        side: WidgetStateProperty.all(
          BorderSide(color: AppColors.primary, width: 1),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.radiusFull),
          ),
        ),
        textStyle: WidgetStateProperty.all(AppStyle.bodyLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          SizedBox(width: 6),
          Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }
}