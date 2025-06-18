import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String string = 'Hello, World';
  final int counter = 42;

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
              // binary_expression +
              'Hello' ' World',
            ),
            Text(
              // adjacent_strings
              'Hello, '
              'world!',
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
              // function_invocation
              (() => '')(),
            ),
          ],
        ),
      ),
    );
  }
}
