import 'package:flutter/material.dart';

class CertificationModel {
  final IconData icon;
  final String name;
  final String title;

  const CertificationModel({
    required this.icon,
    required this.name,
    required this.title,
  });
}

const List<CertificationModel> certificationModel = [
  CertificationModel(
    icon: Icons.cloud_outlined,
    name: 'AWS Certifiend',
    title: 'Solution Architech',
  ),
  CertificationModel(
    icon: Icons.shield_outlined,
    name: 'CISSP',
    title: 'Security Professional',
  ),
];

const List<Map<String, dynamic>> certificate = [
  {'id': 1, 'icon': Icons.verified, 'title': 'Certifications'},
];