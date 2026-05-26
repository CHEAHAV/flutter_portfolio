import 'package:flutter/material.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/components/app_avatar.dart';
import 'package:portfolio/shared/components/text_button.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({super.key, required this.info, this.onContactTap});

  final Info info;
  final VoidCallback? onContactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.cardColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.name, style: AppStyle.headline1),
            const SizedBox(height: 10),
            Text(info.description, style: AppStyle.headline3),
            const SizedBox(height: 10),
            AppTextButton(
              text: 'Contact Me',
              onPressed:
                  onContactTap ??
                  () => Navigator.pushNamed(context, AppRoute.contactPageRoute),
              icon: Icons.arrow_forward_ios,
            ),
            const SizedBox(height: 20),
            Center(child: AppAvatar(imageUrl: info.image, radius: 120)),
          ],
        ),
      ),
    );
  }
}
