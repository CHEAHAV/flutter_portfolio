import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/navigation/navigation.dart';
import 'package:portfolio/shared/shared.dart';
import 'package:portfolio/web/web.dart';

void main() {
  for (final width in [390.0, 800.0, 1440.0]) {
    testWidgets('Portfolio renders its animated shell at ${width}px', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const Portfolio());
      // The sky loops continuously and backend data is unavailable in widget
      // tests. Verify the real shell without waiting for animations to settle.
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(ResponsiveRoot), findsOneWidget);
      expect(find.byType(AuroraBackground), findsOneWidget);
      expect(find.byType(width < 650 ? BottomNav : WebShell), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
