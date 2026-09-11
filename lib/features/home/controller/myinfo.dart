import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';
import '../../../web/controller/web_hero.dart' show WebHeroPortrait;

class MyInfo extends StatelessWidget {
  const MyInfo({
    super.key,
    required this.info,
    required this.mycore,
    this.onContactTap,
  });

  final Info info;
  final List<MyCore> mycore;
  final VoidCallback? onContactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.35),
      ),
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
            Center(
              child: WebHeroPortrait(
                image: info.image,
                radius: 120,
                mycore: mycore,
                compact: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
