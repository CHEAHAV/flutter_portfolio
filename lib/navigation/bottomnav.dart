import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/Views/contact/contact.dart';
import 'package:portfolio/Views/home/homepage.dart';
import 'package:portfolio/Views/profile/profile.dart';
import 'package:portfolio/Views/skill/skill.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SkillPage(),
    ContactPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home, size: 24),
          Icon(Icons.code, size: 24),
          Icon(Icons.contact_mail, size: 24),
          Icon(Icons.person, size: 24),
        ],
        height: 65,
        backgroundColor: Colors.black,
        color: Colors.white,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
      ),
      body: pages[currentTabIndex],
    );
  }
}
