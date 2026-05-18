import 'package:flutter/material.dart';
import 'package:portfolio/navigation/view/bottom_nav.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/theme/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: const BottomNav(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Geist',
        scaffoldBackgroundColor: AppColors.bgDeep,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
          surface: AppColors.bgCard,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      routes: {bottomNavRoute: (context) => const BottomNav()},
    );
  }
}
