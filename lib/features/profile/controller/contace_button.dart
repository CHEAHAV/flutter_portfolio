import 'package:flutter/material.dart';
import '../../profile/profile.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class ContaceButton extends StatelessWidget {
  const ContaceButton({super.key, this.onContactTap});

  final VoidCallback? onContactTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed:
          onContactTap ??
          () => Navigator.pushNamed(context, AppRoute.contactPageRoute),
      icon: Icon(buttonData[1].icon, color: AppColors.textPrimary, size: 18),
      label: Text(
        buttonData[1].title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: AppColors.textPrimary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
