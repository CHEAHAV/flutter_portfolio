import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../shared/shared.dart';

class Contact extends StatefulWidget {
  const Contact({super.key, required this.social});

  final List<Social> social;

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> with TickerProviderStateMixin {
  bool expanded = false;
  late List<AnimationController> barControllers;
  late List<Animation<double>> barAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(covariant Contact oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.social.length != widget.social.length) {
      _disposeAnimations();
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    barControllers = List.generate(
      widget.social.length,
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

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  Future<void> _openContactUrl(Social item) async {
    final opened = await ExternalLink.open(item.socialUrl);
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
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap  : true,
      physics     : const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount  : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing : 12,
        childAspectRatio: 2.8,
      ),
      itemCount: widget.social.length,
      itemBuilder: (context, index) {
        final item = widget.social[index];
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openContactUrl(item),
          child: Container(
            decoration: BoxDecoration(
              color       : AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border      : Border.all(color: AppColors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color     : Colors.black.withValues(alpha: 0.32),
                  blurRadius: 20,
                  offset    : const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: ApiImage.imageProviderFor(
                      item.icon,
                      fallbackAsset: 'assets/icons/github.png',
                    ),
                    width : 20,
                    height: 20,
                    color : AppColors.textPrimary,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/icons/github.png',
                        width: 20,
                        height: 20,
                        color: AppColors.textPrimary,
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.name,
                    style: TextStyle(
                      color     : AppColors.textPrimary,
                      fontSize  : 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
