import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';

void main() {
  testWidgets('Portfolio app renders the home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const Portfolio());
    await tester.pumpAndSettle();

    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('It Cheahav'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsWidgets);
  });
}
