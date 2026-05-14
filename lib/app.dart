import 'package:flutter/material.dart';
import 'package:portfolio/navigation/view/bottom_nav.dart';
import 'package:portfolio/routes/app_route.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: const BottomNav(),
      debugShowCheckedModeBanner: false,
      routes: {
        bottomNavRoute: (context) => const BottomNav(), 
      },
    );
  }
}