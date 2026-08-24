import 'package:flutter/material.dart';
import 'web/web.dart';
import 'page/certificate/certificate.dart';
import 'page/mycore/mycore.dart';
import 'page/project/project.dart';
import 'page/skill/skill.dart';
import 'routes/route.dart';
import 'shared/shared.dart';

class Portfolio extends StatelessWidget {
  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title                     : 'Portfolio',
      home                      : const ResponsiveRoot(),
      debugShowCheckedModeBanner: false,
      theme                     : ThemeData(
        useMaterial3           : true,
        fontFamily             : 'Geist',
        scaffoldBackgroundColor: AppColors.bgDeep,
        colorScheme            : ColorScheme.fromSeed(
          seedColor : AppColors.accent,
          brightness: Brightness.dark,
          surface   : AppColors.bgCard,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.textPrimary,
          elevation      : 0,
          centerTitle    : false,
          iconTheme      : IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      routes: {
        AppRoute.bottomNavRoute        : (context) => const ResponsiveRoot(),
        AppRoute.homePageRoute         : (context) => const ResponsiveRoot(initialIndex: 0),
        AppRoute.skillPageRoute        : (context) => const ResponsiveRoot(initialIndex: 1),
        AppRoute.contactPageRoute      : (context) => const ResponsiveRoot(initialIndex: 2),
        AppRoute.profilePageRoute      : (context) => const ResponsiveRoot(initialIndex: 3),
        AppRoute.projectDetailRoute    : (context) => const ProjectDetailPage(projectModel: []),
        AppRoute.certificateDetailRoute: (context) => const CertificateDetailPage(actionButtonModel: []),
        AppRoute.skillDetailRoute      : (context) => const SkillDetailPage(projectModel: []),
        AppRoute.mycoreDetailRoute     : (context) => const MyCoreDetailPage(actionButtonModel: []),
      },
    );
  }
}
