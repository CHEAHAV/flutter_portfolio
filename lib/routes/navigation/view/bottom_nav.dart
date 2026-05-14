import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/routes/navigation/controller/navigation_controller.dart';
import 'package:portfolio/routes/navigation/model/navigation_model.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final NavigationModel _model = NavigationModel();
  final NavigationController _controller = NavigationController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {}); 
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
        items: _model.navIcons,
        index: _controller.currentTabIndex,
        height: 65,
        backgroundColor: Colors.black,
        color: Colors.white,
        animationDuration: const Duration(milliseconds: 500),
        onTap: _controller.onTabTapped,
      ),
      body: _model.pages[_controller.currentTabIndex],
    );
  }
}
