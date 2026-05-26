import 'package:flutter/material.dart';
import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/model/contact_me.dart';
import 'package:portfolio/features/contact/model/connect_direct_url.dart';
import 'package:portfolio/shared/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectDirect extends StatefulWidget {
  const ConnectDirect({super.key, required this.contactme});

  final List<ContactMe> contactme;

  @override
  State<ConnectDirect> createState() => _ConnectDirectState();
}

class _ConnectDirectState extends State<ConnectDirect>
    with TickerProviderStateMixin {
  bool expanded = false;
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(covariant ConnectDirect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contactme.length != widget.contactme.length) {
      _disposeAnimations();
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    barControllers = List.generate(
      widget.contactme.length,
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

  void _disposeAnimations() {
    for (final c in barControllers) {
      c.dispose();
    }
  }

  Future<void> _openContactUrl(ContactMe item) async {
    final url = ConnectDirectUrl.urlForName(item.name);
    if (url == null) {
      _showLinkError();
      return;
    }

    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showLinkError();
    }
  }

  void _showLinkError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open this contact link')),
    );
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect Directly',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            ...widget.contactme.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _openContactUrl(item),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Image(
                            image: ApiImage.imageProviderFor(
                              item.icon,
                              fallbackAsset: 'assets/icons/phone.png',
                            ),
                            color: AppColors.primary,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/icons/phone.png',
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Label + value stacked
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name.toUpperCase(),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.description,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
