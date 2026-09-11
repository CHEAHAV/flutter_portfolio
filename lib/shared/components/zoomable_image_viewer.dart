import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/style.dart';
import '../theme/colors.dart';

/// Opens a full-screen lightbox for [image] with scroll-wheel, pinch, and
/// button zoom. Closing returns to exactly where the reader left off — the
/// route behind it never rebuilds.
Future<void> showZoomableImage(
  BuildContext context, {
  required ImageProvider image,
  String? title,
  ImageErrorWidgetBuilder? errorBuilder,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (context, animation, _) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween(
            begin: 0.96,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: _ZoomableImageViewer(
            image: image,
            title: title,
            errorBuilder: errorBuilder,
          ),
        ),
      ),
    ),
  );
}

class _ZoomableImageViewer extends StatefulWidget {
  const _ZoomableImageViewer({
    required this.image,
    this.title,
    this.errorBuilder,
  });

  final ImageProvider image;
  final String? title;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  State<_ZoomableImageViewer> createState() => _ZoomableImageViewerState();
}

class _ZoomableImageViewerState extends State<_ZoomableImageViewer>
    with SingleTickerProviderStateMixin {
  static const double _minScale = 1.0;
  static const double _maxScale = 6.0;
  static const double _doubleTapScale = 2.6;

  final TransformationController _controller = TransformationController();
  final GlobalKey _viewportKey = GlobalKey();
  late final AnimationController _animController;
  Animation<Matrix4>? _matrixAnimation;

  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 240))
          ..addListener(() {
            final animation = _matrixAnimation;
            if (animation != null) _controller.value = animation.value;
          });
    _controller.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final scale = _controller.value.getMaxScaleOnAxis();
    if ((scale - _scale).abs() > 0.001) setState(() => _scale = scale);
  }

  Offset get _viewportCenter {
    final renderBox = _viewportKey.currentContext?.findRenderObject();
    if (renderBox is RenderBox && renderBox.hasSize) {
      return renderBox.size.center(Offset.zero);
    }
    return Offset.zero;
  }

  void _animateTo(Matrix4 end) {
    _matrixAnimation = Matrix4Tween(begin: _controller.value, end: end).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0);
  }

  /// Scales the current transform by [factor], keeping [focal] (a local
  /// point in the viewport) fixed on screen — the standard zoom-toward-cursor
  /// composition: translate the focal point to the origin, scale, translate
  /// it back.
  Matrix4 _scaledAround(Offset focal, double factor) {
    final scenePoint = _controller.toScene(focal);
    return _controller.value.clone()
      ..translateByDouble(scenePoint.dx, scenePoint.dy, 0, 1)
      ..scaleByDouble(factor, factor, factor, 1)
      ..translateByDouble(-scenePoint.dx, -scenePoint.dy, 0, 1);
  }

  void _zoomByButton(double factor) {
    final target = (_scale * factor).clamp(_minScale, _maxScale);
    if ((target - _scale).abs() < 0.001) return;
    _animateTo(_scaledAround(_viewportCenter, target / _scale));
  }

  void _reset() => _animateTo(Matrix4.identity());

  void _onDoubleTapDown(TapDownDetails details) => _pendingDoubleTapAt = details.localPosition;

  Offset? _pendingDoubleTapAt;

  void _onDoubleTap() {
    final at = _pendingDoubleTapAt ?? _viewportCenter;
    if (_scale > _minScale + 0.01) {
      _reset();
    } else {
      _animateTo(_scaledAround(at, _doubleTapScale / _scale));
    }
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.escape:
        Navigator.of(context).maybePop();
      case LogicalKeyboardKey.add:
      case LogicalKeyboardKey.equal:
      case LogicalKeyboardKey.numpadAdd:
        _zoomByButton(1.3);
      case LogicalKeyboardKey.minus:
      case LogicalKeyboardKey.numpadSubtract:
        _zoomByButton(1 / 1.3);
      case LogicalKeyboardKey.digit0:
      case LogicalKeyboardKey.numpad0:
        _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canZoomOut = _scale > _minScale + 0.01;
    final canZoomIn = _scale < _maxScale - 0.01;

    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: _handleKey,
      child: Semantics(
        label: 'Image viewer${widget.title != null ? ', ${widget.title}' : ''}',
        child: Material(
          color: Colors.black.withValues(alpha: 0.9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onDoubleTapDown: _onDoubleTapDown,
                  onDoubleTap: _onDoubleTap,
                  child: InteractiveViewer(
                    key: _viewportKey,
                    transformationController: _controller,
                    minScale: _minScale,
                    maxScale: _maxScale,
                    clipBehavior: Clip.none,
                    // Without this, a trackpad's two-finger scroll (which is
                    // what a pinch gesture becomes on web and desktop) only
                    // pans — it never zooms. This is a lightbox, not a
                    // scrollable page, so panning gives no value scrolling
                    // wouldn't already cover once zoomed.
                    trackpadScrollCausesScale: true,
                    child: Center(
                      child: Image(
                        image: widget.image,
                        fit: BoxFit.contain,
                        errorBuilder: widget.errorBuilder,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: _ViewerButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Close (Esc)',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              if (widget.title != null)
                Positioned(
                  top: 24,
                  left: 24,
                  child: Text(
                    widget.title!,
                    style: AppStyle.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: _ZoomToolbar(
                    scale: _scale,
                    canZoomIn: canZoomIn,
                    canZoomOut: canZoomOut,
                    onZoomIn: () => _zoomByButton(1.3),
                    onZoomOut: () => _zoomByButton(1 / 1.3),
                    onReset: _reset,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoomToolbar extends StatelessWidget {
  const _ZoomToolbar({
    required this.scale,
    required this.canZoomIn,
    required this.canZoomOut,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  final double scale;
  final bool canZoomIn;
  final bool canZoomOut;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppStyle.radiusLg),
        border: Border.all(color: AppColors.tileBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewerButton(
            icon: Icons.remove_rounded,
            tooltip: 'Zoom out',
            onPressed: canZoomOut ? onZoomOut : null,
          ),
          SizedBox(
            width: 64,
            child: Center(
              child: Text(
                '${(scale * 100).round()}%',
                style: AppStyle.bodySmall.copyWith(
                  color: Colors.white,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _ViewerButton(
            icon: Icons.add_rounded,
            tooltip: 'Zoom in',
            onPressed: canZoomIn ? onZoomIn : null,
          ),
          Container(
            width: 1,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            color: AppColors.divider,
          ),
          _ViewerButton(
            icon: Icons.restart_alt_rounded,
            tooltip: 'Reset zoom',
            onPressed: canZoomOut ? onReset : null,
          ),
        ],
      ),
    );
  }
}

class _ViewerButton extends StatelessWidget {
  const _ViewerButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: 22,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
