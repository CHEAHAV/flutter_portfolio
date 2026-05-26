import 'package:flutter/material.dart';
import 'package:portfolio/api/core/api_image.dart';
import 'package:portfolio/api/model/certification.dart';
import 'package:portfolio/page/certificate/controller/meta_item.dart';
import 'package:portfolio/page/certificate/model/meta_item_model.dart';
import 'package:portfolio/shared/components/divider.dart';
import 'package:portfolio/shared/theme/colors.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({
    super.key,
    required this.certification,
    required this.metaItemModel,
  });
  final Certification certification;
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
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: ApiImage.imageProviderFor(
                    certification.icon,
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
            certification.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Text(
              certification.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.accentCyan,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.8,
              ),
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
                  label: metaItemModel[0].label.toUpperCase(),
                  value: certification.credentialId,
                ),
              ),
              // Date Earned
              Expanded(
                child: MetaItem(
                  label: metaItemModel[1].label.toUpperCase(),
                  value: certification.dateEarned,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: MetaItem(
            label: metaItemModel[2].label.toUpperCase(),
            value: certification.issuer,
            valueStyle: const TextStyle(
              color: AppColors.accentCyan,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
