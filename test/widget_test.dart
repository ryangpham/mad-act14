// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:act14/main.dart';

void main() {
  testWidgets('App shows notification placeholder UI', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Notification Dashboard'), findsOneWidget);
    expect(find.text('Waiting for a cloud message'), findsOneWidget);
    expect(find.text('assets/images/tacobell.png'), findsOneWidget);
    expect(find.text('Permission status: pending'), findsOneWidget);
    expect(find.text('FCM token: unavailable'), findsOneWidget);
    expect(find.text('Console Payload Hints'), findsOneWidget);
  });
}
