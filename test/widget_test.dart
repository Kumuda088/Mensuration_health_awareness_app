import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:menstrual_health_app/screens/home/home_screen.dart';
import 'package:menstrual_health_app/utils/app_theme.dart';

void main() {
  testWidgets('Home dashboard shows period tracking action', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const HomeScreen(greetingName: 'there'),
      ),
    );

    expect(find.text('Log Period'), findsOneWidget);
    expect(find.text('Period Tracking'), findsOneWidget);
  });
}
