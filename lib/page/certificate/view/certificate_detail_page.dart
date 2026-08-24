import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../certificate/certificate.dart';
import '../../../shared/shared.dart';
import '../../../routes/route.dart';
import 'package:portfolio/features/home/model/homebackend_message.dart';

class CertificateDetailPage extends StatefulWidget {
  const CertificateDetailPage({super.key, required this.actionButtonModel});

  final List<ActionButtonModel> actionButtonModel;

  @override
  State<CertificateDetailPage> createState() => _CertificateDetailPageState();
}

class _CertificateDetailPageState extends State<CertificateDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeIn;
  late Future<ApiModel> apiModelFuture;
  Info? _info;
  int? certificateIndex;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    fadeIn = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    apiModelFuture = loadApiModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is int) {
      certificateIndex = arguments;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<ApiModel> loadApiModel() {
    return ApiRepository().loadApiModel();
  }

  void _retryLoadHomeContent() {
    setState(() {
      apiModelFuture = loadApiModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          apiModelFuture = loadApiModel();
        });
        await apiModelFuture;
      },
      child: Scaffold(
        backgroundColor: AppColors.tertiary,
        appBar: MyAppBar(info: _info, index: 5, contactme: []),
        body: FadeTransition(
          opacity: fadeIn,
          child: FutureBuilder<ApiModel>(
            future: apiModelFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (snapshot.hasError) {
                return BackendMessage(
                  title: homeBackendMessage[0].title,
                  message: homeBackendMessage[0].message,
                  actionLabel: homeBackendMessage[0].actionLabel,
                  onActionPressed: _retryLoadHomeContent,
                );
              }

              final content = snapshot.data;
              if (content == null || content.isEmpty) {
                return BackendMessage(
                  title: homeBackendMessage[1].title,
                  message: homeBackendMessage[1].message,
                );
              }

              final info = content.info.isNotEmpty ? content.info.first : null;
              if (info == null) {
                return BackendMessage(
                  title: homeBackendMessage[2].title,
                  message: homeBackendMessage[2].message,
                );
              }

              final certifications = content.certification;
              final selectedIndex = certificateIndex ?? 0;
              if (certifications.isEmpty ||
                  selectedIndex < 0 ||
                  selectedIndex >= certifications.length) {
                return BackendMessage(
                  title: homeBackendMessage[3].title,
                  message: homeBackendMessage[3].message,
                );
              }

              final certification = certifications[selectedIndex];

              if (_info == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _info = info);
                });
              }

              return SingleChildScrollView(
                padding: ResponsiveInsets.page(
                  context,
                ).copyWith(top: 24, bottom: 24) +
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent, width: 1),
                      ),
                      child: CertificateCard(
                        certification: certification,
                        metaItemModel: metaItemModel,
                      ),
                    ),

                    const SizedBox(height: 16),
                    ActionButton(
                      icon: actionButtonModel[0].icon,
                      label: actionButtonModel[0].label,
                      onTap: () async {
                        await ExternalLink.open(certification.certificateurl);
                      },
                      filled: true,
                    ),

                    const SizedBox(height: 12),
                    ActionButton(
                      icon: actionButtonModel[1].icon,
                      label: actionButtonModel[1].label,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.profilePageRoute);
                      },
                      filled: false,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
