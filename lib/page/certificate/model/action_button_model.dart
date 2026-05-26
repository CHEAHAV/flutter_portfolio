import 'package:flutter/material.dart';

class ActionButtonModel {
  final IconData icon;
  final String label;

  const ActionButtonModel({required this.icon, required this.label});
}

const List<ActionButtonModel> actionButtonModel = [
  ActionButtonModel(icon: Icons.verified_outlined, label: 'Official Page'),
  ActionButtonModel(icon: Icons.backspace_outlined, label: 'Back Button'),
];
