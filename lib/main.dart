import 'package:flutter/material.dart';
import 'package:portfolio/navigation/bottomnav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: const BottomNav(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/bottomNav': (context) => const BottomNav(),
      },
    );
  }
}
