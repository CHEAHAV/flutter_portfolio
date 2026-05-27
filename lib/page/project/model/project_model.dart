import 'package:flutter/material.dart';

class ProjectModel {
  final IconData? icon;
  final String label;

  const ProjectModel({this.icon, required this.label});
}

const List<ProjectModel> projectModel = [
  ProjectModel(icon: Icons.schedule_rounded, label: 'Duration'),
  ProjectModel(icon: Icons.badge_outlined, label: 'Role'),
  ProjectModel(icon: Icons.devices_rounded, label: 'Platform'),
  ProjectModel(label: 'Description'),
  ProjectModel(label: 'The Challenge'),
];
