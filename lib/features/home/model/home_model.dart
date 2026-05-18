import 'package:flutter/material.dart';
import 'package:portfolio/features/home/model/headerdata.dart';
import 'package:portfolio/features/home/model/info.dart';

class HomeModel {
  final List<String> filters = [
    'ALL',
    'WEB',
    'MOBILE',
    'BACKEND',
    'CLOUD',
    'AI/ML',
  ];

  final HeaderData headerdata = HeaderData(
    name: 'Portfolio',
    imageUrl: 'assets/images/profile.png',
    icon: Icons.search,
  );

  final List<Map<String, dynamic>> searchdata = [
    {'hinttext': 'Search Projects & Skills...', 'icon': Icons.search},
  ];

  final Info info = Info(
    name: 'IT CHEAHAV',
    description: 'Full Stack & Mobile App Devilopment',
    button: 'Connect & Discuss',
    image: 'assets/images/profile.png',
  );

  final List<Map<String, dynamic>> mycore = [
    {'id': 1, 'name': 'Backend API', 'image': 'assets/icons/backend.png'},
    {'id': 2, 'name': 'Mobile App', 'image': 'assets/icons/phone.png'},
    {'id': 3, 'name': 'REST API', 'image': 'assets/icons/api.png'},
    {'id': 4, 'name': 'Docker', 'image': 'assets/icons/docker.png'},
    {'id': 5, 'name': 'Python', 'image': 'assets/icons/python.png'},
  ];

  final List<Map<String, dynamic>> project = [
    {
      'id': 1,
      'name': 'Artificial Intelligence',
      'description':
          'The simulation of human intelligence processes by machines, especially computer systems, including learning, reasoning, and self-correction.',
      'image': 'assets/images/computer.png',
    },
    {
      'id': 2,
      'name': 'Data Structures & Algorithms',
      'description':
          'The fundamental building blocks of software engineering, focusing on efficient ways to store, organize, and process data to solve complex problems.',
      'image': 'assets/images/computer.png',
    },
    {
      'id': 3,
      'name': 'Cybersecurity',
      'description':
          'The practice of protecting systems, networks, and programs from digital attacks aimed at accessing, changing, or destroying sensitive information.',
      'image': 'assets/images/computer.png',
    },
    {
      'id': 4,
      'name': 'Cloud Computing',
      'description':
          'The on-demand delivery of IT resources over the internet, providing scalable storage and processing power via platforms like AWS, Azure, or GCP.',
      'image': 'assets/images/computer.png',
    },
    {
      'id': 5,
      'name': 'Blockchain Technology',
      'description':
          'A decentralized, distributed ledger technology that records transactions across many computers so that the record cannot be altered retroactively.',
      'image': 'assets/images/computer.png',
    },
  ];
}
