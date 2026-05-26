import 'package:flutter/material.dart';
import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/model/my_core.dart';
import 'package:portfolio/page/certificate/controller/meta_item.dart';
import 'package:portfolio/page/certificate/model/meta_item_model.dart';
import 'package:portfolio/shared/components/divider.dart';
import 'package:portfolio/shared/theme/colors.dart';

class MyCoreCard extends StatelessWidget {
  const MyCoreCard({
    super.key,
    required this.myCore,
    required this.metaItemModel,
  });
  final MyCore myCore;
  final List<MetaItemModel> metaItemModel;

  @override
  Widget build(BuildContext context) {
    if (metaItemModel.length < 3) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Center(
            child: Container(
              width: 260,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: ApiImage.imageProviderFor(
                    myCore.image,
                    fallbackAsset: 'assets/images/computer.png',
                  ),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/computer.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            myCore.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 28),
        AppDivider(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Issuer
              Expanded(
                child: MetaItem(
                  label: metaItemModel[3].label.toUpperCase(),
                  value: myCore.description,
                ),
              ),
              // Date Earned
            ],
          ),
        ),
      ],
    );
  }
}
