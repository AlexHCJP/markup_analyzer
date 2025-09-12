import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:example/examples.dart';

void main() {
  group('Example Widget Tests', () {
    testWidgets('BadExampleWidget should render', (WidgetTester tester) async {
      // This file is excluded from markup_analyzer analysis via exclude_patterns
      // So these string literals won't trigger lint errors
      await tester.pumpWidget(
        const MaterialApp(
          home: BadExampleWidget(),
        ),
      );

      // Test strings that would normally trigger errors
      expect(find.text('Bad Example'), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('GoodExampleWidget should render', (WidgetTester tester) async {
      // Even though this is excluded, it shows the proper way to write tests
      await tester.pumpWidget(
        const MaterialApp(
          home: GoodExampleWidget(),
        ),
      );

      // This is fine because test files are excluded
      expect(find.text('Good Example'), findsOneWidget);
    });
  });
}