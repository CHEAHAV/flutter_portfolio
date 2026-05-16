import 'package:flutter/material.dart';
import 'package:portfolio/features/contact/model/message_model.dart';
import 'package:portfolio/shared/components/text_button.dart';
import 'package:portfolio/shared/components/textform.dart';
import 'package:portfolio/shared/components/textformarray.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> with TickerProviderStateMixin {
  bool expanded = false;
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;

  @override
  void initState() {
    super.initState();
    barControllers = List.generate(
      messageModel.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700 + i * 150),
      ),
    );
    barAnimations = barControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOutCubic))
        .toList();

    for (int i = 0; i < barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) barControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in barControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messageModel[0].name, style: AppStyle.bodyLarge),
            const SizedBox(height: 8),
            TextForm(hintText: nameHintText),
            const SizedBox(height: 10),
            Text(messageModel[0].gmail, style: AppStyle.bodyLarge),
            const SizedBox(height: 8),
            TextForm(hintText: gmailHintText),
            const SizedBox(height: 10),
            Text(messageModel[0].subject, style: AppStyle.bodyLarge),
            const SizedBox(height: 8),
            TextForm(hintText: subjectHintText),
            const SizedBox(height: 10),
            Text(messageModel[0].message, style: AppStyle.bodyLarge),
            const SizedBox(height: 8),
            TextFormArray(hintText: messageModel[0].hinttext),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: AppTextButton(
                text: 'Send Message',
                onPressed: () {},
                icon: Icons.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
