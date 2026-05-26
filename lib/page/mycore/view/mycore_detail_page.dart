import 'package:flutter/material.dart';
import 'package:portfolio/api/model/api_model.dart';
import 'package:portfolio/api/model/info.dart';
import 'package:portfolio/api/repository/api_repository.dart';
import 'package:portfolio/features/home/model/homebackend_message.dart';
import 'package:portfolio/page/certificate/controller/action_button.dart';
import 'package:portfolio/page/certificate/model/action_button_model.dart';
import 'package:portfolio/page/mycore/controller/mycore_card.dart';
import 'package:portfolio/routes/app_route.dart';
import 'package:portfolio/shared/components/backend_message.dart';
import 'package:portfolio/shared/components/myapp_bar.dart';
import 'package:portfolio/shared/theme/colors.dart';
import 'package:portfolio/page/certificate/model/meta_item_model.dart';

class MyCoreDetailPage extends StatefulWidget {
  const MyCoreDetailPage({super.key, required this.actionButtonModel});

  final List<ActionButtonModel> actionButtonModel;

  @override
  State<MyCoreDetailPage> createState() => _MyCoreDetailPageState();
}

class _MyCoreDetailPageState extends State<MyCoreDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeIn;
  late Future<ApiModel> apiModelFuture;
  Info? _info;
  int? mycoreIndex;

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
      mycoreIndex = arguments;
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
        appBar: MyAppBar(info: _info, index: 6),
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

              final mycores = content.mycore;
              final selectedIndex = mycoreIndex ?? 0;
              if (mycores.isEmpty ||
                  selectedIndex < 0 ||
                  selectedIndex >= mycores.length) {
                return BackendMessage(
                  title: homeBackendMessage[3].title,
                  message: homeBackendMessage[3].message,
                );
              }

              final mycore = mycores[selectedIndex];

              if (_info == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _info = info);
                });
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent, width: 1),
                      ),
                      child: MyCoreCard(
                        myCore: mycore,
                        metaItemModel: metaItemModel,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: ActionButton(
                            icon: actionButtonModel[1].icon,
                            label: actionButtonModel[1].label,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.homePageRoute,
                              );
                            },
                            filled: false,
                          ),
                        ),
                      ),
                    ),
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
