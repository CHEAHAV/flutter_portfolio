import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  NavigationController({int initialIndex = 0}) : currentTabIndex = initialIndex;

  int currentTabIndex;

  void onTabTapped(int index) {
    currentTabIndex = index;
    notifyListeners();
  }
}
