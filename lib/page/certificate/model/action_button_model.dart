import 'package:flutter/material.dart';

class ActionButtonModel {
  final IconData icon;
  final String label;

  const ActionButtonModel({required this.icon, required this.label});
}

const List<ActionButtonModel> actionButtonModel = [
  ActionButtonModel(icon: Icons.verified_outlined, label: 'View Certificate'),
  ActionButtonModel(icon: Icons.backspace_outlined, label: 'Back Button'),
  ActionButtonModel(icon: Icons.link, label: 'Link to Project'),
];
