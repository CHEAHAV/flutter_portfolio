
import 'package:flutter/material.dart';
import '../../shared/shared.dart';

class BackendMessage extends StatelessWidget {
  const BackendMessage({super.key, 
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppStyle.headline3, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppStyle.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}