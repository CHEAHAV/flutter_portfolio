import 'package:flutter/material.dart';
import 'package:portfolio/features/profile/model/certification_model.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class Certification extends StatefulWidget {
  const Certification({super.key});

  @override
  State<Certification> createState() => _CertificationState();
}

class _CertificationState extends State<Certification>
    with TickerProviderStateMixin {
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
        height: 168,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: certificationModel.length,
          itemBuilder: (context, index) {
            final item = certificationModel[index];
            return FadeTransition(
              opacity: barAnimations[index],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.12),
                  end: Offset.zero,
                ).animate(barAnimations[index]),
                child: Container(
                  width: 170,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppStyle.radiusLg),
                    border: Border.all(color: AppColors.divider, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.32),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.bgTile,
                          borderRadius: BorderRadius.circular(
                            AppStyle.radiusMd,
                          ),
                          border: Border.all(color: AppColors.tileBorder),
                        ),
                        child: Icon(
                          item.icon,
                          color: AppColors.accent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.bodySmall.copyWith(
                          color: AppColors.textSub,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
