import 'package:flutter/material.dart';
import 'package:portfolio/features/skill/model/skill_item.dart';
import 'package:portfolio/shared/theme/colors.dart';

class ExpertiseTabBar extends StatefulWidget {
  final ValueChanged<int> onTabSelected;

  const ExpertiseTabBar({super.key, required this.onTabSelected});

  @override
  State<ExpertiseTabBar> createState() => _ExpertiseTabBarState();
}

class _ExpertiseTabBarState extends State<ExpertiseTabBar> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tabs.length, (i) {
            final selected = i == _selectedTab;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedTab = i);
                widget.onTabSelected(i);
              },
              child: Column(
                children: [
                  Text(
                    tabs[i],
                    style: TextStyle(
                      color: selected ? AppColors.accent : AppColors.textSub,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: selected ? (tabs[i].length * 7.5) : 0,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.6),
                                blurRadius: 6,
                              ),
                            ]
                          : [],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 2),
        Container(height: 1, color: AppColors.divider),
      ],
    );
  }
}
