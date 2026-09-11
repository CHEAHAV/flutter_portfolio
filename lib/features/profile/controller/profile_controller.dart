import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../web/controller/web_hero.dart' show WebHeroPortrait;

class ProfileController extends StatelessWidget {
  const ProfileController({
    super.key,
    required this.image,
    required this.mycore,
  });

  final String image;
  final List<MyCore> mycore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WebHeroPortrait(
        image: image,
        radius: 120,
        mycore: mycore,
        compact: true,
      ),
    );
  }
}
