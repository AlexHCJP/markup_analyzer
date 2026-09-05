// ignore_for_file: simple_string

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class AnotherWidgetClass {
  final String text;

  AnotherWidgetClass({required this.text});
}

class _MyHomePageState extends State<MyHomePage> {
  final String string = 'Hello, World';
  final int counter = 42;

  /// Null here, so every `??` below falls through to its right-hand side —
  /// which is the shape `binary_expression` and `binary_string_literal`
  /// disagree about.
  String? get maybeString => null;
  final AnotherWidgetClass anotherWidget = AnotherWidgetClass(text: 'Hello');
  final justText = Text('Hello'); // simple_identifier

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // simple_string
              'Hello, World',
            ),
            Text(
              // string_interpolation
              'count clicks: $counter',
            ),
            Text(
              // adjacent_strings
              'Hello, '
              'world!',
            ),
            Text(
              // binary_expression, binary_string_literal ×2 — one per literal
              "1" + "2",
            ),
            Text(
              // binary_expression, binary_string_literal — the literal only:
              // `maybeString` is somebody else's rule.
              maybeString ?? 'Untitled',
            ),
            Text(
              // binary_expression, binary_string_literal — the walk recurses
              // through chained operators to reach it.
              maybeString ?? widget.subtitle ?? 'Untitled',
            ),
            Text(
              // binary_expression only. Nothing raw is in here: both operands
              // carry text from somewhere else, which is the case
              // `binary_string_literal` exists to let through.
              maybeString ?? string,
            ),
            Text(
              // binary_expression only. `?? ''` means "nothing yet", and an
              // empty literal has no text in it to translate.
              maybeString ?? '',
            ),
            Text(
              // prefixed_identifier
              widget.title,
            ),
            Text(
              // method_invocation
              'Hello'.toString(),
            ),
            Text(
              // simple_identifier
              string,
            ),
            Text(
              anotherWidget.text, // prefixed_identifier
            ),
          ],
        ),
      ),
    );
  }
}
