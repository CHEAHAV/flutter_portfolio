import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int currentTabIndex = 0;

  void onTabTapped(int index) {
    currentTabIndex = index;
    notifyListeners(); 
  }
}