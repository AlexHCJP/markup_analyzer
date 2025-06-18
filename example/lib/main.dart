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
              // 1. PrefixedIdentifier()
              'Hello, World',
            ),
            Text(
              // 2. PrefixedIdentifier()
              widget.title,
            ),
            Text(
              // 3. StringInterpolation()
              'Количество кликов: $counter',
            ),
            Text(
              // 4. BinaryExpression with +
              'Hello'
              ' World',
            ),
            Text(
              // 5. AdjacentStrings
              'Hello, '
              'world!',
            ),
            Text(
              // 6. MethodInvocation()
              'Hello'.toString(),
            ),
            Text(
              // 7. SimpleIdentifier()
              string,
            ),
            Text(
              // 8. FunctionExpressionInvocation or PropertyAccess
              Theme.of(context).textTheme.headlineMedium.toString(),
            ),
            Text(
              // 9. NamedExpression()
              'Заголовок',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
