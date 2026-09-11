import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';
import '../controller/mycore_detail_content.dart';

/// Case-study screen for a single core competency — the same page chrome
/// and layout language as [SkillDetailPage], so both detail screens read as
/// one system.
class MyCoreDetailPage extends StatefulWidget {
  const MyCoreDetailPage({super.key, this.loadContent});

  final Future<ApiModel> Function()? loadContent;

  @override
  State<MyCoreDetailPage> createState() => _MyCoreDetailPageState();
}

class _MyCoreDetailPageState extends State<MyCoreDetailPage> {
  late Future<ApiModel> _content;

  @override
  void initState() {
    super.initState();
    _content = _load();
  }

  Future<ApiModel> _load() =>
      widget.loadContent?.call() ?? ApiRepository().loadApiModel();

  Future<void> _refresh() async {
    final future = _load();
    setState(() {
      _content = future;
    });
    // FutureBuilder displays a recoverable error if a refresh fails.
    try {
      await future;
    } catch (_) {}
  }

  void _backToHome() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoute.homePageRoute);
    }
  }

  MyCore? _selectedMyCore(List<MyCore> mycores) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    String? id;
    int? index;
    if (arguments is String) {
      id = arguments;
    } else if (arguments is int) {
      index = arguments;
    } else if (arguments is Map) {
      if (arguments['id'] is String) id = arguments['id'] as String;
      if (arguments['index'] is int) index = arguments['index'] as int;
    }
    // A supplied ID takes precedence over a potentially stale list index.
    if (id != null && id.trim().isNotEmpty) {
      for (final myCore in mycores) {
        if (myCore.id == id) return myCore;
      }
      return null;
    }
    final selectedIndex = index ?? 0;
    return selectedIndex >= 0 && selectedIndex < mycores.length
        ? mycores[selectedIndex]
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.bgCard,
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1216),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: AppColors.accent,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child:
                              MediaQuery.sizeOf(context).width >= 380 &&
                                  MediaQuery.textScalerOf(context).scale(14) <=
                                      21
                              ? Text('PORTFOLIO', style: AppStyle.labelLarge)
                              : const SizedBox.shrink(),
                        ),
                        TextButton.icon(
                          onPressed: _backToHome,
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Back to home'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            minimumSize: const Size(48, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<ApiModel>(
                future: _content,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'Loading core competency details',
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return BackendMessage(
                      title: 'Unable to load this competency',
                      message: 'Please check your connection and try again.',
                      actionLabel: 'Try again',
                      onActionPressed: _refresh,
                    );
                  }
                  final myCore = _selectedMyCore(
                    snapshot.data?.mycore ?? const [],
                  );
                  if (myCore == null) {
                    return BackendMessage(
                      title: 'Competency not found',
                      message:
                          'Return to the home page to choose another competency.',
                      actionLabel: 'Back to home',
                      onActionPressed: _backToHome,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1216),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              24,
                              context.isMobile ? 28 : 48,
                              24,
                              48,
                            ),
                            child: MyCoreDetailContent(myCore: myCore),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
