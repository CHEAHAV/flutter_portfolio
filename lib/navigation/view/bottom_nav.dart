import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../navigation.dart';
import '../../shared/shared.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, this.initialIndex = 0, this.onIndexChanged});

  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late final NavigationController _controller;
  late final NavigationModel _model;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = NavigationController(initialIndex: widget.initialIndex);
    _model = NavigationModel(
      onContactTap: () {
        _bottomNavigationKey.currentState?.setPage(2);
        _controller.onTabTapped(2);
      },
      onProfileTap: () {
        _bottomNavigationKey.currentState?.setPage(3);
        _controller.onTabTapped(3);
      },
    );
    _controller.addListener(() {
      setState(() {});
      widget.onIndexChanged?.call(_controller.currentTabIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _model.navIcons,
        index: _controller.currentTabIndex,
        height: 65,
        backgroundColor: AppColors.bgDeep,
        color: AppColors.bgCard,
        buttonBackgroundColor: AppColors.accent,
        animationDuration: const Duration(milliseconds: 500),
        onTap: _controller.onTabTapped,
      ),
      body: _model.pages[_controller.currentTabIndex],
    );
  }
}
