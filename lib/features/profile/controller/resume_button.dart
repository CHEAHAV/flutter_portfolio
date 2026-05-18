import 'package:flutter/material.dart';
import 'package:portfolio/features/profile/model/button_data.dart';
import 'package:portfolio/shared/theme/colors.dart';

class ResumeButton extends StatefulWidget {
  const ResumeButton({super.key});

  @override
  State<ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends State<ResumeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(buttonData[0].icon, color: AppColors.card, size: 18),
      label: Text(
        buttonData[0].title,
        style: TextStyle(color: AppColors.card, fontWeight: FontWeight.w400),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
