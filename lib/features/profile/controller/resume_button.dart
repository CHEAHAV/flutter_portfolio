import 'package:flutter/material.dart';
import '../../profile/profile.dart';
import '../../../shared/shared.dart';

class ResumeButton extends StatefulWidget {
  const ResumeButton({super.key});

  @override
  State<ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends State<ResumeButton> {
  Future<void> _openResume() async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await ExternalLink.open(resumeUrl);
    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open the resume link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _openResume,
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
