import 'package:flutter/material.dart';

class HeaderData {
  final String id;
  final String name;
  final IconData icon;

  const HeaderData({required this.id, required this.name, required this.icon});
}

const List<HeaderData> headerdata = [
  HeaderData(id: '1', name: 'Portfolio', icon: Icons.email),
  HeaderData(id: '3', name: 'Skill', icon: Icons.email),
  HeaderData(id: '2', name: 'Contact', icon: Icons.email),
  HeaderData(id: '4', name: 'Profile', icon: Icons.email),
  HeaderData(id: '5', name: 'Project', icon: Icons.email),
  HeaderData(id: '6', name: 'Certification', icon: Icons.email),
  HeaderData(id: '7', name: 'My Core', icon: Icons.email),
];
