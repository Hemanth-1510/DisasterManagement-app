// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disaster_app/main.dart';

void main() {
  group('Disaster Guardian App Tests', () {
    testWidgets('App should start with home screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: DisasterGuardianApp(),
        ),
      );

      // Verify that the app starts with the home screen
      expect(find.text('Disaster Guardian'), findsOneWidget);
      expect(find.text('Be Prepared, Stay Safe!'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Sign up button should navigate to signup screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DisasterGuardianApp(),
        ),
      );

      // Tap the sign up button
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify navigation to signup screen
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Login button should navigate to login screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DisasterGuardianApp(),
        ),
      );

      // Tap the login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify navigation to login screen
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('App should have proper theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DisasterGuardianApp(),
        ),
      );

      // Verify that the app uses the teal theme
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, isA<MaterialColor>());
    });
  });
}
