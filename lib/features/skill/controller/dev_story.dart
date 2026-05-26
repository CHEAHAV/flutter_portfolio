import 'package:flutter/material.dart';
import 'package:portfolio/api/model/story.dart';
import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/shared/theme/colors.dart';

class DevStory extends StatefulWidget {
  const DevStory({super.key, required this.stories});

  final List<Story> stories;

  @override
  State<DevStory> createState() => _DevStoryState();
}

class _DevStoryState extends State<DevStory> with TickerProviderStateMixin {
  bool _expanded = false;
  List<AnimationController> _barControllers = [];
  List<Animation<double>> barAnimations = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations(widget.stories.length);
  }

  @override
  void didUpdateWidget(covariant DevStory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stories.length != widget.stories.length) {
      _setupAnimations(widget.stories.length);
    }
  }

  void _setupAnimations(int count) {
    // Dispose old controllers if any
    for (final c in _barControllers) {
      c.dispose();
    }

    _barControllers = List.generate(
      count,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700 + i * 150),
      ),
    );

    barAnimations = _barControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOutCubic))
        .toList();

    for (int i = 0; i < _barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) _barControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _barControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = widget.stories;
    if (stories.isEmpty) return const SizedBox.shrink();

    final story = stories.first;
    final shortDesc = story.description.length > 80
        ? '${story.description.substring(0, 80)}...'
        : story.description;

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
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: title + description + read more
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _expanded ? story.description : shortDesc,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Text(
                      _expanded ? 'Show Less' : '... Read More',
                      style: const TextStyle(
                        color: AppColors.accentGlow,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right: icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: ApiImage.imageProviderFor(
                      story.icon,
                      fallbackAsset: 'assets/icons/backend.png',
                    ),
                    width: 28,
                    height: 28,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/icons/backend.png',
                        width: 28,
                        height: 28,
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    story.iconname,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
