import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  NavigationController({int initialIndex = 0})
    : currentTabIndex = _validIndex(initialIndex);

  int currentTabIndex;

  void onTabTapped(int index) {
    currentTabIndex = _validIndex(index);
    notifyListeners();
  }

  static int _validIndex(int index) {
    if (index < 0) return 0;
    if (index > 3) return 0;
    return index;
  }
}
