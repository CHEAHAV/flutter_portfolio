import 'package:flutter/material.dart';

class HeaderData {
  final IconData iconLeft;
  final String title;
  final IconData iconRight;

  const HeaderData({
    required this.iconLeft,
    required this.title,
    required this.iconRight,
  });
}

HeaderData headerData = HeaderData(
  iconLeft: Icons.chevron_left,
  title: 'Skill & Profile',
  iconRight: Icons.search,
);
