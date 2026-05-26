import 'package:flutter/material.dart';

class DataSectionTitle {
  final String id;
  final IconData icon;
  final String title;

  const DataSectionTitle({
    required this.id,
    required this.icon,
    required this.title,
  });
}

const List<DataSectionTitle> dataSectionTitle = [
  DataSectionTitle(id: '1', icon: Icons.school, title: 'Study Timeline'),
  DataSectionTitle(id: '2', icon: Icons.work, title: 'Career Timeline'),
  DataSectionTitle(id: '3', icon: Icons.verified, title: 'Certifications'),
];
