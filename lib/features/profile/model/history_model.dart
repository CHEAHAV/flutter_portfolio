import 'package:flutter/material.dart';

class HistoryModel {
  final String title;
  final String subtitle;
  final String description;
  final String date;

  const HistoryModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.date,
  });
}

const List<HistoryModel> historyModel = [
  HistoryModel(
    title: 'Lead Engineer',
    subtitle: 'TechNova Solutions',
    description:
        'Architected global microservices infrastructure. Led a team of 12 engineers migrating monolithic legacy systems to event-driven architectures.',
    date: '2023 - present',
  ),
  HistoryModel(
    title: 'Senior Backend Dev',
    subtitle: 'Pixcel Backend',
    description:
        'Refers to the underlying data layer of an application that is processed, stored, and managed on the server-side. This includes user credentials, application logic states, database records, and third-party API payloads that are inaccessible to the frontend client without explicit authorization.',
    date: '2022 - 2023',
  ),
];

const List<Map<String, dynamic>> timeline = [
  {'id': 1, 'icon': Icons.work, 'title': 'Career Timeline'},
  {'id': 2, 'icon': Icons.verified, 'title': 'Certifications'},
];

const List<String> subjects = ['Go', 'Kubernetes', 'AWS'];
