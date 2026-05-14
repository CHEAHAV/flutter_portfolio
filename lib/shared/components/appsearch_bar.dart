import 'package:flutter/material.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final Icon prefixicon;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.prefixicon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: controller,
        style: AppStyle.label,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: AppStyle.label,
          prefixIcon: prefixicon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
