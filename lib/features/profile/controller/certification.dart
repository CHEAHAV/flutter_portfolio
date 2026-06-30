import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';

class CertificationCard extends StatefulWidget {
  const CertificationCard({
    super.key,
    required this.items,
    this.onCertificateDetailPage,
  });

  final List<Certification> items;
  final void Function(int index)? onCertificateDetailPage;

  @override
  State<CertificationCard> createState() => _CertificationCardState();
}

class _CertificationCardState extends State<CertificationCard>
    with TickerProviderStateMixin {
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;

  @override
  void initState() {
    super.initState();
    barControllers = List.generate(
      widget.items.length,
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
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 168,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
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
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onCertificateDetailPage != null) {
                        widget.onCertificateDetailPage!(index);
                        return;
                      }
                      Navigator.pushNamed(
                        context,
                        AppRoute.certificateDetailRoute,
                        arguments: index,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 67,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColors.bgTile,
                            borderRadius: BorderRadius.circular(
                              AppStyle.radiusMd,
                            ),
                            border: Border.all(color: AppColors.tileBorder),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppStyle.radiusSm,
                              ),
                              child: Image(
                                image: ApiImage.imageProviderFor(
                                  item.icon,
                                  fallbackAsset: 'assets/icons/resume.png',
                                ),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/icons/resume.png',
                                    color: AppColors.accent,
                                  );
                                },
                              ),
                            ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
