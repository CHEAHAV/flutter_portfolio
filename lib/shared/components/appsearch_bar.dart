import 'package:flutter/material.dart';
import '../../shared/shared.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final Icon prefixicon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.prefixicon,
    this.onChanged,
    this.onClear,
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
        onChanged: onChanged,
        style: AppStyle.label,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: AppStyle.label,
          prefixIcon: prefixicon,
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClear,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
