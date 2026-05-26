import 'package:flutter/material.dart';

class ButtonData {
  final IconData icon;
  final String title;

  const ButtonData({required this.icon, required this.title});
}

const List<ButtonData> buttonData = [
  ButtonData(icon: Icons.download, title: 'Resume'),
  ButtonData(icon: Icons.message, title: 'Contact'),
];
