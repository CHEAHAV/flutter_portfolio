import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../routes/route.dart';
import '../../../shared/shared.dart';
import '../../../web/controller/web_section.dart';
import '../controller/certificate_detail_bar.dart';
import '../controller/certificate_detail_content.dart';
import '../model/certificate_detail_model.dart';

/// Case study for a single credential. The phone keeps the app bar it
/// shares with every other detail page; tablet and desktop get the site
/// header, the centred content column, and the aurora backdrop — the same
/// chrome as [ProjectDetailPage], so a certificate never feels like a
/// plainer, second-class page.
class CertificateDetailPage extends StatefulWidget {
  const CertificateDetailPage({super.key, this.loadContent});

  final Future<ApiModel> Function()? loadContent;

  @override
  State<CertificateDetailPage> createState() => _CertificateDetailPageState();
}

class _CertificateDetailPageState extends State<CertificateDetailPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();

  late final AnimationController _fadeController;
  late final Animation<double> _fade;
  late Future<ApiModel> _content;

  bool _scrolled = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _content = _load();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<ApiModel> _load() =>
      widget.loadContent?.call() ?? ApiRepository().loadApiModel();

  Future<void> _refresh() async {
    final future = _load();
    setState(() {
      _content = future;
    });
    // FutureBuilder shows a recoverable error if the refresh itself fails.
    try {
      await future;
    } catch (_) {}
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;

    final offset = _scroll.offset;
    final maxExtra = _scroll.position.maxScrollExtent;
    final scrolled = offset > 12;
    final progress = maxExtra <= 0 ? 0.0 : (offset / maxExtra).clamp(0.0, 1.0);

    if (scrolled != _scrolled || (progress - _progress).abs() > 0.004) {
      setState(() {
        _scrolled = scrolled;
        _progress = progress;
      });
    }
  }

  void _backToTop() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOutCubic,
    );
  }

  void _backToCareer() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoute.homePageRoute);
    }
  }

  void _openSite() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoute.homePageRoute);
    }
  }

  /// `-1` when the requested record is no longer served by the backend.
  int _selectedIndex(List<Certification> certifications) {
    if (certifications.isEmpty) return -1;

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

    if (id != null && id.trim().isNotEmpty) {
      return certifications.indexWhere((item) => item.id == id);
    }

    final selected = index ?? 0;
    return selected >= 0 && selected < certifications.length ? selected : -1;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return FutureBuilder<ApiModel>(
      future: _content,
      builder: (context, snapshot) {
        final content = snapshot.data;
        final info = content != null && content.info.isNotEmpty
            ? content.info.first
            : null;

        return Scaffold(
          backgroundColor: AppColors.bgDeep,
          appBar: isMobile
              ? MyAppBar(
                  info: info,
                  index: 5,
                  contactme: content?.contactme ?? const [],
                )
              : null,
          body: Stack(
            children: [
              const Positioned.fill(child: AuroraBackground()),
              Positioned.fill(child: _body(context, snapshot)),
              if (!isMobile)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CertificateDetailBar(
                    scrolled: _scrolled,
                    progress: _progress,
                    onBrandTap: _openSite,
                    onBack: _backToCareer,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, AsyncSnapshot<ApiModel> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(
          semanticsLabel: certificateLoadingLabel,
        ),
      );
    }

    if (snapshot.hasError) {
      return BackendMessage(
        title: certificateErrorTitle,
        message: certificateErrorMessage,
        actionLabel: certificateRetryAction,
        onActionPressed: _refresh,
      );
    }

    final certifications = snapshot.data?.certification ?? const <Certification>[];
    final index = _selectedIndex(certifications);
    if (index < 0) {
      return BackendMessage(
        title: certificateMissingTitle,
        message: certificateMissingDetail,
        actionLabel: certificateBackAction,
        onActionPressed: _backToCareer,
      );
    }

    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop;
    final padding = isMobile
        ? const EdgeInsets.fromLTRB(20, 26, 20, 44)
        : ResponsiveInsets.page(context).copyWith(
            top: WebSection.navHeight + (isDesktop ? 46 : 34),
            bottom: isDesktop ? 76 : 56,
          );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          child: CertificateDetailContent(
            certification: certifications[index],
            onBackToCareer: _backToCareer,
            onBackToTop: _backToTop,
          ),
        ),
      ),
    );
  }
}
