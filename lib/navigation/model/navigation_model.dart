import 'package:flutter/material.dart';
import 'package:portfolio/features/contact/view/contact.dart';
import 'package:portfolio/features/home/view/homepage.dart';
import 'package:portfolio/features/profile/view/profile.dart';
import 'package:portfolio/features/skill/view/skill.dart';

class NavigationModel {
  final List<Widget> pages = [  
    HomePage(),
    SkillPage(),
    ContactPage(),
    ProfilePage(),
  ];

  final List<Widget> navIcons = const [  
    Icon(Icons.home, size: 24),
    Icon(Icons.code, size: 24),
    Icon(Icons.contact_mail, size: 24),
    Icon(Icons.person, size: 24),
  ];
}