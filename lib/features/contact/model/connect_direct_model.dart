import 'package:flutter/material.dart';

class ConnectDirectModel {
  final String name;
  final String description;
  final IconData icon;

  const ConnectDirectModel({
    required this.name,
    required this.description,
    required this.icon,
  });
}

const List<ConnectDirectModel> connectDirectModel = [
  ConnectDirectModel(
    name: 'Phone',
    description: 'dara@gmail.com',
    icon: Icons.phone,
  ),
  ConnectDirectModel(
    name: 'Location',
    description: 'phnom penh, kampot',
    icon: Icons.location_city,
  ),
];

const String connect = 'Connect Directly';

class ContactModel {
  final String name;
  final String icon;

  const ContactModel({required this.name, required this.icon});
}

const List<ContactModel> contact = [
  ContactModel(name: 'Linkedin', icon: 'assets/icons/linkedin.png'),
  ContactModel(name: 'GitHub', icon: 'assets/icons/github.png'),
  ContactModel(name: 'Twitter', icon: 'assets/icons/twitter.png'),
  ContactModel(name: 'Resume', icon: 'assets/icons/resume.png'),
];
