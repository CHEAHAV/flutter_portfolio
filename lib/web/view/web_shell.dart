import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../web.dart';
import '../../api/api.dart';
import '../../features/home/home.dart';
import '../../routes/route.dart';
import '../../shared/shared.dart';

/// Tablet and desktop experience: one scrolling site, one backend load, and
/// exactly the records the phone layout renders.
class WebShell extends StatefulWidget {
  const WebShell({
    super.key,
    this.initialIndex = 0,
    this.onIndexChanged,
    this.loadContent,
  });

  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;
  final Future<ApiModel> Function()? loadContent;

  @override
  State<WebShell> createState() => _WebShellState();
}

class _WebShellState extends State<WebShell> {
  static const double _minZoom = 0.75;
  static const double _maxZoom = 1.5;

  final ScrollController _scrollController = ScrollController();
  final Map<WebAnchor, GlobalKey> _anchors = {
    for (final anchor in WebAnchor.values) anchor: GlobalKey(),
  };

  late Future<ApiModel> _apiModelFuture;
  WebAnchor _activeAnchor = WebAnchor.home;
  bool _scrolled = false;
  double _progress = 0;
  bool _jumpedToInitial = false;

  double _zoomScale = 1.0;
  double _panZoomStartScale = 1.0;
  final _navRevision = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _apiModelFuture = loadApiModel();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _navRevision.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // Browser pinch/Ctrl+wheel arrives as a scale signal, without a physical
  // Control key press. Older/native devices can send modified scroll signals.
  void _handlePointerSignal(PointerSignalEvent event) {
    final factor = switch (event) {
      PointerScaleEvent() => event.scale,
      PointerScrollEvent()
          when HardwareKeyboard.instance.isControlPressed ||
              HardwareKeyboard.instance.isMetaPressed =>
        math.exp(-event.scrollDelta.dy / 240),
      _ => null,
    };
    if (factor == null || !factor.isFinite || factor <= 0) return;
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      _setZoom(_zoomScale * factor);
    });
  }

  void _setZoom(double value) {
    final clamped = value.clamp(_minZoom, _maxZoom);
    if (clamped == _zoomScale) return;
    setState(() => _zoomScale = clamped);
  }

  void _zoomIn() => _setZoom(_zoomScale * 1.1);
  void _zoomOut() => _setZoom(_zoomScale / 1.1);
  void _resetZoom() => _setZoom(1.0);

  Future<ApiModel> loadApiModel() {
    return widget.loadContent?.call() ?? ApiRepository().loadApiModel();
  }

  void _retryLoadWebContent() {
    setState(() {
      _apiModelFuture = loadApiModel();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final maxExtra = _scrollController.position.maxScrollExtent;
    final scrolled = offset > 12;
    final progress = maxExtra <= 0 ? 0.0 : (offset / maxExtra).clamp(0.0, 1.0);
    final anchor = _anchorAtViewportTop();

    if (scrolled != _scrolled ||
        anchor != _activeAnchor ||
        (progress - _progress).abs() > 0.004) {
      _scrolled = scrolled;
      _progress = progress;
      _activeAnchor = anchor;
      _navRevision.value++;
    }
  }

  WebAnchor _anchorAtViewportTop() {
    var current = WebAnchor.home;

    for (final entry in _anchors.entries) {
      final context = entry.value.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;

      if (box.localToGlobal(Offset.zero).dy <= WebSection.navHeight + 24) {
        current = entry.key;
      }
    }

    return current;
  }

  void _scrollTo(WebAnchor anchor, {bool animate = true}) {
    final context = _anchors[anchor]?.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: animate ? const Duration(milliseconds: 650) : Duration.zero,
      curve: Curves.easeInOutCubic,
    );

    widget.onIndexChanged?.call(_tabForAnchor(anchor));
  }

  void _backToTop() => _scrollTo(WebAnchor.home);

  int _tabForAnchor(WebAnchor anchor) {
    switch (anchor) {
      case WebAnchor.skills:
      case WebAnchor.work:
        return 1;
      case WebAnchor.contact:
        return 2;
      case WebAnchor.about:
      case WebAnchor.career:
        return 3;
      case WebAnchor.home:
        return 0;
    }
  }

  void _jumpToInitialAnchor() {
    if (_jumpedToInitial || widget.initialIndex == 0) {
      _jumpedToInitial = true;
      return;
    }

    _jumpedToInitial = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollTo(webAnchorForTab(widget.initialIndex));
    });
  }

  /// Anchor target: the key sits on a spacer so the heading below it clears
  /// the sticky navigation bar once scrolled into view.
  Widget _anchor(WebAnchor anchor) {
    return SizedBox(key: _anchors[anchor], height: WebSection.navHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          const Positioned.fill(child: AuroraBackground()),
          Positioned.fill(
            child: ClipRect(
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(
                    LogicalKeyboardKey.equal,
                    control: true,
                  ): _zoomIn,
                  const SingleActivator(
                    LogicalKeyboardKey.equal,
                    control: true,
                    shift: true,
                  ): _zoomIn,
                  const SingleActivator(
                    LogicalKeyboardKey.minus,
                    control: true,
                  ): _zoomOut,
                  const SingleActivator(
                    LogicalKeyboardKey.digit0,
                    control: true,
                  ): _resetZoom,
                  const SingleActivator(LogicalKeyboardKey.equal, meta: true):
                      _zoomIn,
                  const SingleActivator(LogicalKeyboardKey.minus, meta: true):
                      _zoomOut,
                  const SingleActivator(LogicalKeyboardKey.digit0, meta: true):
                      _resetZoom,
                },
                child: Focus(
                  autofocus: true,
                  child: Listener(
                    onPointerSignal: _handlePointerSignal,
                    onPointerPanZoomStart: (_) =>
                        _panZoomStartScale = _zoomScale,
                    onPointerPanZoomUpdate: (event) =>
                        _setZoom(_panZoomStartScale * event.scale),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(
                          constraints.maxWidth / _zoomScale,
                          constraints.maxHeight / _zoomScale,
                        );
                        return FittedBox(
                          key: const ValueKey('page-zoom'),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          child: SizedBox.fromSize(
                            size: size,
                            child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(size: size),
                              child: FutureBuilder<ApiModel>(
                                future: _apiModelFuture,
                                builder: (context, snapshot) =>
                                    _body(context, snapshot),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FutureBuilder<ApiModel>(
              future: _apiModelFuture,
              builder: (context, snapshot) => ValueListenableBuilder<int>(
                valueListenable: _navRevision,
                builder: (context, revision, child) => WebNavBar(
                  activeAnchor: _activeAnchor,
                  onNavigate: _scrollTo,
                  contactme: snapshot.data?.contactme ?? const [],
                  scrolled: _scrolled,
                  progress: _progress,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, AsyncSnapshot<ApiModel> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return BackendMessage(
        title: homeBackendMessage[0].title,
        message: homeBackendMessage[0].message,
        actionLabel: homeBackendMessage[0].actionLabel,
        onActionPressed: _retryLoadWebContent,
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

    _jumpToInitialAnchor();

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Listener(
        // Resolve modified wheel input before the surrounding Scrollable.
        behavior: HitTestBehavior.translucent,
        onPointerSignal: _handlePointerSignal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(key: _anchors[WebAnchor.home], height: 0),
            WebHero(
              info: info,
              experience: content.experience,
              story: content.story,
              socials: content.social,
              mycore: content.mycore,
              onContactTap: () => _scrollTo(WebAnchor.contact),
              onWorkTap: () => _scrollTo(WebAnchor.work),
            ),
            _anchor(WebAnchor.about),
            WebSection(
              topPadding: 0,
              child: WebReveal(
                controller: _scrollController,
                child: WebAbout(
                  stories: content.story,
                  study: content.study,
                  career: content.career,
                  teachstack: content.teachstack,
                  onContactTap: () => _scrollTo(WebAnchor.contact),
                ),
              ),
            ),
            _anchor(WebAnchor.skills),
            WebSection(
              topPadding: 0,
              background: AppColors.bgCard.withValues(alpha: 0.5),
              child: WebReveal(
                controller: _scrollController,
                child: WebSkills(
                  skills: content.skill,
                  teachstack: content.teachstack,
                  onSkillTap: (index) => Navigator.pushNamed(
                    context,
                    AppRoute.skillDetailRoute,
                    arguments: {'id': content.skill[index].id, 'index': index},
                  ),
                ),
              ),
            ),
            _anchor(WebAnchor.work),
            WebSection(
              topPadding: 0,
              child: WebReveal(
                controller: _scrollController,
                child: WebWork(
                  projects: content.project,
                  onProjectTap: (index) => Navigator.pushNamed(
                    context,
                    AppRoute.projectDetailRoute,
                    arguments: {
                      'id': content.project[index].id,
                      'index': index,
                    },
                  ),
                ),
              ),
            ),
            _anchor(WebAnchor.career),
            WebSection(
              topPadding: 0,
              background: AppColors.bgCard.withValues(alpha: 0.5),
              child: WebReveal(
                controller: _scrollController,
                child: WebCareer(
                  study: content.study,
                  career: content.career,
                  certification: content.certification,
                  onCertificationTap: (index) => Navigator.pushNamed(
                    context,
                    AppRoute.certificateDetailRoute,
                    arguments: index,
                  ),
                ),
              ),
            ),
            _anchor(WebAnchor.contact),
            WebSection(
              topPadding: 0,
              selectable: false,
              child: WebContactSection(
                contactme: content.contactme,
                socials: content.social,
              ),
            ),
            WebFooter(
              info: info,
              socials: content.social,
              contactme: content.contactme,
              onNavigate: _scrollTo,
              onBackToTop: _backToTop,
            ),
          ],
        ),
      ),
    );
  }
}
