import 'package:flutter/material.dart';

/// Example widget demonstrating various string usage patterns
/// that would be caught by markup_analyzer
class BadExampleWidget extends StatelessWidget {
  const BadExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = 'John Doe';
    
    return Scaffold(
      // This will trigger an error: simple string literal
      appBar: AppBar(title: const Text('Bad Example')),
      body: Column(
        children: [
          // This will trigger an error: simple string literal
          const Text('Hello World'),
          
          // This will trigger a warning: string interpolation
          Text('Welcome, $userName!'),
          
          // This will trigger a warning: binary expression
          const Text('Hello ' + 'World'),
          
          // This will trigger a warning: adjacent strings
          const Text('This is a '
                     'multiline string'),
          
          // This will trigger a warning: method invocation
          Text(getUserGreeting()),
          
          // This widget type is excluded from analysis, so it won't trigger errors
          const DebugWidget('This is fine'),
          
          // Container is not in the include_widget_types list, so it won't be analyzed
          Container(
            child: const Text('This won\'t be analyzed'),
          ),
        ],
      ),
    );
  }

  String getUserGreeting() {
    return 'Hello from method';
  }
}

/// Example widget demonstrating good string usage patterns
/// that comply with markup_analyzer rules
class GoodExampleWidget extends StatelessWidget {
  const GoodExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using localization (would be ideal)
      appBar: AppBar(title: Text(AppLocalizations.of(context).appTitle)),
      body: Column(
        children: [
          // Using proper localization
          Text(AppLocalizations.of(context).welcomeMessage),
          
          // Using localization with parameters
          Text(AppLocalizations.of(context).userGreeting('John Doe')),
          
          // Using constants
          Text(AppStrings.defaultMessage),
          
          // Using constructor parameters
          Text(widget.title ?? AppStrings.defaultTitle),
        ],
      ),
    );
  }
}

/// Mock localization class for demonstration
class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations();
  }
  
  String get appTitle => 'Good Example';
  String get welcomeMessage => 'Welcome to our app!';
  String userGreeting(String name) => 'Hello, $name!';
}

/// String constants class - a good practice
class AppStrings {
  static const String defaultMessage = 'Default message';
  static const String defaultTitle = 'Default title';
}

/// Debug widget that is excluded from analysis
class DebugWidget extends StatelessWidget {
  const DebugWidget(this.message, {super.key});
  
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}

/// Extension on Widget to add a title property for demonstration
extension WidgetExtension on Widget {
  String? get title => null;
}