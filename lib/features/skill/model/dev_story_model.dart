// dev_story.dart
import 'package:flutter/material.dart';

class DevStoryModel {
  final String title;
  final String description;
  final IconData icon;
  final String iconname;

  const DevStoryModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconname,
  });
}

const List<DevStoryModel> devStory = [
  DevStoryModel(
    title: 'Dev Story',
    description:
        'I am a passionate, detail-oriented Full Stack and Mobile Developer dedicated to crafting high-performance, scalable, and visually intuitive digital experiences. With a strong foundation in both frontend interfaces and robust backend architectures, I bridge the gap between complex technical engineering and seamless user design.',
    icon: Icons.phone,
    iconname: 'phone',
  ),
];

const IconData icon = Icons.terminal;
