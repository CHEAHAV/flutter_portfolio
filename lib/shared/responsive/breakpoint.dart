import 'dart:math' as math;
import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class Breakpoints {
  const Breakpoints._();

  // ── Screen width limits ─────────────────────────────────────
  static const double tablet  = 650;
  static const double desktop = 1100;

  // ── Readable content width per device ───────────────────────
  static const double tabletContent  = 900;
  static const double desktopContent = 1320;

  static DeviceType of(double width) {
    if (width >= desktop) return DeviceType.desktop;
    if (width >= tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static double contentWidth(DeviceType device) {
    switch (device) {
      case DeviceType.desktop:
        return desktopContent;
      case DeviceType.tablet:
        return tabletContent;
      case DeviceType.mobile:
        return double.infinity;
    }
  }
}

extension ResponsiveContext on BuildContext {
  DeviceType get deviceType => Breakpoints.of(MediaQuery.sizeOf(this).width);

  bool get isMobile  => deviceType == DeviceType.mobile;
  bool get isTablet  => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}

class ResponsiveInsets {
  const ResponsiveInsets._();

  /// Side gutters that keep the content centered on a wide screen while
  /// leaving the phone layout edge to edge exactly as it is today.
  static EdgeInsets page(BuildContext context, {double? maxContentWidth}) {
    final width  = MediaQuery.sizeOf(context).width;
    final device = Breakpoints.of(width);
    if (device == DeviceType.mobile) return EdgeInsets.zero;

    final limit     = maxContentWidth ?? Breakpoints.contentWidth(device);
    final minGutter = device == DeviceType.desktop ? 32.0 : 40.0;
    final gutter    = math.max(0.0, (width - limit) / 2);
    return EdgeInsets.symmetric(horizontal: math.max(gutter, minGutter));
  }
}
