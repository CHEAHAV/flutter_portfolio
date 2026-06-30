import 'package:flutter/material.dart';
import '../../features/contact/contact.dart';
import '../../features/profile/profile.dart';
import '../../features/home/home.dart';
import '../../features/skill/skill.dart';
import '../../shared/shared.dart';

class NavigationModel {
  NavigationModel({
    required VoidCallback onContactTap,
    required VoidCallback onProfileTap,
  }) : pages = [
         HomePage(
           homeBackendMessage: [],
           onContactTap: onContactTap,
           onProfileTap: onProfileTap,
         ),
         SkillPage(skillBackendMessage: [], onProfileTap: onProfileTap),
         ContactPage(contactBackendMessage: [], onProfileTap: onProfileTap),
         ProfilePage(
           profileBackendMessage: [],
           dataSectionTitle: [],
           onContactTap: onContactTap,
           onProfileTap: onProfileTap,
         ),
       ];

  final List<Widget> pages;

  final List<Widget> navIcons = const [
    Icon(Icons.home, size: 24, color: AppColors.textPrimary),
    Icon(Icons.settings_ethernet, size: 24, color: AppColors.textPrimary),
    Icon(Icons.contact_mail, size: 24, color: AppColors.textPrimary),
    Icon(Icons.person, size: 24, color: AppColors.textPrimary),
  ];
}
