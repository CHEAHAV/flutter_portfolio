import 'package:flutter/material.dart';
import 'package:portfolio/features/profile/model/certification_model.dart';
import 'package:portfolio/shared/theme/colors.dart';

class Certification extends StatefulWidget {
  const Certification({super.key});

  @override
  State<Certification> createState() => _CertificationState();
}

class _CertificationState extends State<Certification>
    with TickerProviderStateMixin {
  bool expanded = false;
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;

  @override
  void initState() {
    super.initState();
    barControllers = List.generate(
      certificationModel.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700 + i * 150),
      ),
    );
    barAnimations = barControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOutCubic))
        .toList();

    for (int i = 0; i < barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) barControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in barControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 155,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: certificationModel.length,
          itemBuilder: (context, index) {
            final item = certificationModel[index];
            return Container(
              width: 155,
              margin: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: AppColors.textPrimary),
                  const SizedBox(height: 5),
                  Text(
                    item.name,
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.title,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
