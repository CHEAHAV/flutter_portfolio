import 'package:flutter/material.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/features/home/model/headerdata.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/components/divider.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.info,
    required this.index,
    this.onProfileTap,
  });

  final Info? info;
  final int index;
  final VoidCallback? onProfileTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: GestureDetector(
              onTap:
                  onProfileTap ??
                  () => Navigator.pushNamed(context, AppRoute.profilePageRoute),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundImage: info != null
                      ? NetworkImage(info!.image)
                      : null,
                  radius: 20,
                  child: info == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accent, Color(0xFFB0C4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              headerdata[index].name.toUpperCase(),
              style: AppStyle.headline1.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.contactPageRoute);
          },
          icon: Icon(headerdata[index].icon),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: AppDivider(),
      ),
    );
  }
}
