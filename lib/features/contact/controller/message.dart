import 'dart:async';
import 'package:flutter/material.dart';
import '../../contact/contact.dart';
import '../../../api/api.dart';
import '../../../shared/shared.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> with TickerProviderStateMixin {
  bool expanded = false;
  bool _isSending = false;
  bool _showSuccessAnimation = false;
  Timer? _successAnimationTimer;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _successAnimationTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate() || _isSending) return;

    setState(() {
      _isSending = true;
      _showSuccessAnimation = false;
    });
    try {
      await sendContactMessage(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (!mounted) return;
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      setState(() => _showSuccessAnimation = true);
      _successAnimationTimer?.cancel();
      _successAnimationTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showSuccessAnimation = false);
        }
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$errormessage: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(messageModel[0].firstName, style: AppStyle.bodyLarge),
              const SizedBox(height: 8),
              TextForm(
                hintText: firstNameHintText,
                controller: _firstNameController,
                validator: MessageValidation.requiredField,
              ),
              const SizedBox(height: 10),
              Text(messageModel[0].lastName, style: AppStyle.bodyLarge),
              const SizedBox(height: 8),
              TextForm(
                hintText: lastNameHintText,
                controller: _lastNameController,
                validator: MessageValidation.requiredField,
              ),
              const SizedBox(height: 10),
              Text(messageModel[0].gmail, style: AppStyle.bodyLarge),
              const SizedBox(height: 8),
              TextForm(
                hintText: gmailHintText,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: MessageValidation.emailField,
              ),
              const SizedBox(height: 10),
              Text(messageModel[0].subject, style: AppStyle.bodyLarge),
              const SizedBox(height: 8),
              TextForm(
                hintText: subjectHintText,
                controller: _subjectController,
                validator: MessageValidation.requiredField,
              ),
              const SizedBox(height: 10),
              Text(messageModel[0].message, style: AppStyle.bodyLarge),
              const SizedBox(height: 8),
              TextFormArray(
                hintText: messageModel[0].hinttext,
                controller: _messageController,
                validator: MessageValidation.requiredField,
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 3000),
                child: _showSuccessAnimation
                    ? Container(
                        key: const ValueKey(overlay),
                        decoration: BoxDecoration(
                          color: AppColors.bgColor.withValues(alpha: 0.70),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const MyLottie(),
                            const SizedBox(height: 16),
                            Text(
                              successmessage,
                              style: AppStyle.bodyLarge.copyWith(
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.70,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              callback,
                              style: AppStyle.bodyLarge.copyWith(
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.70,
                                ),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey(emply)),
              ),
              if (_showSuccessAnimation) const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: AppTextButton(
                  text: _isSending ? sending[0].message : sending[1].message,
                  onPressed: _isSending ? null : _sendMessage,
                  icon: _isSending ? sending[0].icon : sending[1].icon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
