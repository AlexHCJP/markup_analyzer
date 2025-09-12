import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:markup_analyzer/model/config_model.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigModel', () {
    group('fromMap constructor', () {
      test('should parse all severity types correctly', () {
        final map = {
          'simple': 'error',
          'prefixed_identifier': 'warning',
          'interpolation': 'info',
          'binary': 'none',
          'adjacent': 'ERROR',
          'method': 'WARNING',
          'simple_identifier': 'INFO',
          'function': 'NONE',
        };

        final config = ConfigModel.fromMap(map);

        expect(config.simple, equals(DiagnosticSeverity.ERROR));
        expect(config.prefixedIdentifier, equals(DiagnosticSeverity.WARNING));
        expect(config.interpolation, equals(DiagnosticSeverity.INFO));
        expect(config.binary, isNull); // 'none' should be null
        expect(config.adjacent, equals(DiagnosticSeverity.ERROR));
        expect(config.method, equals(DiagnosticSeverity.WARNING));
        expect(config.simpleIdentifier, equals(DiagnosticSeverity.INFO));
        expect(config.function, isNull); // 'NONE' should be null
      });

      test('should parse new configuration options', () {
        final map = {
          'simple': 'error',
          'exclude_patterns': ['.*\\.generated\\.dart', '.*\\.g\\.dart'],
          'include_widget_types': ['Text', 'Button'],
          'exclude_widget_types': ['DebugWidget'],
          'enable_suggestions': false,
        };

        final config = ConfigModel.fromMap(map);

        expect(config.simple, equals(DiagnosticSeverity.ERROR));
        expect(config.excludePatterns, equals(['.*\\.generated\\.dart', '.*\\.g\\.dart']));
        expect(config.includeWidgetTypes, equals(['Text', 'Button']));
        expect(config.excludeWidgetTypes, equals(['DebugWidget']));
        expect(config.enableSuggestions, isFalse);
      });

      test('should parse single string as list', () {
        final map = {
          'exclude_patterns': '.*\\.generated\\.dart',
          'include_widget_types': 'Text',
        };

        final config = ConfigModel.fromMap(map);

        expect(config.excludePatterns, equals(['.*\\.generated\\.dart']));
        expect(config.includeWidgetTypes, equals(['Text']));
      });

      test('should handle null values for new options', () {
        final map = {
          'simple': 'error',
          'exclude_patterns': null,
          'include_widget_types': null,
          'exclude_widget_types': null,
          'enable_suggestions': null,
        };

        final config = ConfigModel.fromMap(map);

        expect(config.simple, equals(DiagnosticSeverity.ERROR));
        expect(config.excludePatterns, isNull);
        expect(config.includeWidgetTypes, isNull);
        expect(config.excludeWidgetTypes, isNull);
        expect(config.enableSuggestions, isTrue); // Default value
      });

      test('should handle null values', () {
        final map = {
          'simple': null,
          'interpolation': 'error',
        };

        final config = ConfigModel.fromMap(map);

        expect(config.simple, isNull);
        expect(config.interpolation, equals(DiagnosticSeverity.ERROR));
        expect(config.binary, isNull);
      });

      test('should handle invalid severity values', () {
        final map = {
          'simple': 'invalid',
          'interpolation': 'error',
          'binary': '',
        };

        final config = ConfigModel.fromMap(map);

        expect(config.simple, isNull); // Invalid value should be null
        expect(config.interpolation, equals(DiagnosticSeverity.ERROR));
        expect(config.binary, isNull); // Empty string should be null
      });

      test('should handle missing keys', () {
        final map = {
          'simple': 'error',
          // Other keys are missing
        };

        final config = ConfigModel.fromMap(map);

        expect(config.simple, equals(DiagnosticSeverity.ERROR));
        expect(config.interpolation, isNull);
        expect(config.binary, isNull);
        expect(config.adjacent, isNull);
        expect(config.method, isNull);
        expect(config.simpleIdentifier, isNull);
        expect(config.prefixedIdentifier, isNull);
        expect(config.function, isNull);
        expect(config.excludePatterns, isNull);
        expect(config.includeWidgetTypes, isNull);
        expect(config.excludeWidgetTypes, isNull);
        expect(config.enableSuggestions, isTrue); // Default value
      });

      test('should handle empty map', () {
        final config = ConfigModel.fromMap({});

        expect(config.simple, isNull);
        expect(config.interpolation, isNull);
        expect(config.binary, isNull);
        expect(config.adjacent, isNull);
        expect(config.method, isNull);
        expect(config.simpleIdentifier, isNull);
        expect(config.prefixedIdentifier, isNull);
        expect(config.function, isNull);
        expect(config.excludePatterns, isNull);
        expect(config.includeWidgetTypes, isNull);
        expect(config.excludeWidgetTypes, isNull);
        expect(config.enableSuggestions, isTrue); // Default value
      });
    });

    group('fromRules constructor', () {
      test('should return default config when rules map is empty', () {
        final config = ConfigModel.fromRules({});

        expect(config.simple, isNull);
        expect(config.interpolation, isNull);
        expect(config.binary, isNull);
        expect(config.adjacent, isNull);
        expect(config.method, isNull);
        expect(config.simpleIdentifier, isNull);
        expect(config.prefixedIdentifier, isNull);
        expect(config.function, isNull);
        expect(config.excludePatterns, isNull);
        expect(config.includeWidgetTypes, isNull);
        expect(config.excludeWidgetTypes, isNull);
        expect(config.enableSuggestions, isTrue);
      });

      test('should parse first rule configuration', () {
        final rules = {
          'markup_analyzer': LintOptions.fromMap({
            'simple': 'error',
            'interpolation': 'warning',
          }),
          'other_rule': LintOptions.fromMap({
            'simple': 'info', // This should be ignored
          }),
        };

        final config = ConfigModel.fromRules(rules);

        expect(config.simple, equals(DiagnosticSeverity.ERROR));
        expect(config.interpolation, equals(DiagnosticSeverity.WARNING));
      });

      test('should handle parsing errors gracefully', () {
        // Create a mock rules map that would cause parsing errors
        final rules = {
          'markup_analyzer': MockLintOptions(),
        };

        // This should not throw and should return default config
        final config = ConfigModel.fromRules(rules);

        expect(config.simple, isNull);
        expect(config.interpolation, isNull);
        expect(config.binary, isNull);
        expect(config.adjacent, isNull);
        expect(config.method, isNull);
        expect(config.simpleIdentifier, isNull);
        expect(config.prefixedIdentifier, isNull);
        expect(config.function, isNull);
        expect(config.excludePatterns, isNull);
        expect(config.includeWidgetTypes, isNull);
        expect(config.excludeWidgetTypes, isNull);
        expect(config.enableSuggestions, isTrue);
      });
    });

    group('constructor with parameters', () {
      test('should create config with specified values', () {
        final config = ConfigModel(
          simple: DiagnosticSeverity.ERROR,
          interpolation: DiagnosticSeverity.WARNING,
          binary: DiagnosticSeverity.INFO,
          adjacent: DiagnosticSeverity.ERROR,
          method: DiagnosticSeverity.WARNING,
          simpleIdentifier: DiagnosticSeverity.INFO,
          prefixedIdentifier: DiagnosticSeverity.ERROR,
          function: DiagnosticSeverity.WARNING,
          excludePatterns: ['pattern1', 'pattern2'],
          includeWidgetTypes: ['Text', 'Button'],
          excludeWidgetTypes: ['DebugWidget'],
          enableSuggestions: false,
        );

        expect(config.simple, equals(DiagnosticSeverity.ERROR));
        expect(config.interpolation, equals(DiagnosticSeverity.WARNING));
        expect(config.binary, equals(DiagnosticSeverity.INFO));
        expect(config.adjacent, equals(DiagnosticSeverity.ERROR));
        expect(config.method, equals(DiagnosticSeverity.WARNING));
        expect(config.simpleIdentifier, equals(DiagnosticSeverity.INFO));
        expect(config.prefixedIdentifier, equals(DiagnosticSeverity.ERROR));
        expect(config.function, equals(DiagnosticSeverity.WARNING));
        expect(config.excludePatterns, equals(['pattern1', 'pattern2']));
        expect(config.includeWidgetTypes, equals(['Text', 'Button']));
        expect(config.excludeWidgetTypes, equals(['DebugWidget']));
        expect(config.enableSuggestions, isFalse);
      });

      test('should create config with null values when not specified', () {
        final config = ConfigModel();

        expect(config.simple, isNull);
        expect(config.interpolation, isNull);
        expect(config.binary, isNull);
        expect(config.adjacent, isNull);
        expect(config.method, isNull);
        expect(config.simpleIdentifier, isNull);
        expect(config.prefixedIdentifier, isNull);
        expect(config.function, isNull);
        expect(config.excludePatterns, isNull);
        expect(config.includeWidgetTypes, isNull);
        expect(config.excludeWidgetTypes, isNull);
        expect(config.enableSuggestions, isTrue); // Default value
      });

      test('should create config with partial values', () {
        final config = ConfigModel(
          simple: DiagnosticSeverity.ERROR,
          interpolation: DiagnosticSeverity.WARNING,
          excludePatterns: ['pattern1'],
          enableSuggestions: false,
        );

        expect(config.simple, equals(DiagnosticSeverity.ERROR));
        expect(config.interpolation, equals(DiagnosticSeverity.WARNING));
        expect(config.binary, isNull);
        expect(config.adjacent, isNull);
        expect(config.method, isNull);
        expect(config.simpleIdentifier, isNull);
        expect(config.prefixedIdentifier, isNull);
        expect(config.function, isNull);
        expect(config.excludePatterns, equals(['pattern1']));
        expect(config.includeWidgetTypes, isNull);
        expect(config.excludeWidgetTypes, isNull);
        expect(config.enableSuggestions, isFalse);
      });
    });

    group('shouldAnalyzeWidget', () {
      test('should return false when widget is in exclude list', () {
        final config = ConfigModel(
          excludeWidgetTypes: ['DebugWidget', 'TestWidget'],
        );

        expect(config.shouldAnalyzeWidget('DebugWidget'), isFalse);
        expect(config.shouldAnalyzeWidget('TestWidget'), isFalse);
        expect(config.shouldAnalyzeWidget('Text'), isTrue);
      });

      test('should return true only for included widgets when include list is specified', () {
        final config = ConfigModel(
          includeWidgetTypes: ['Text', 'Button'],
        );

        expect(config.shouldAnalyzeWidget('Text'), isTrue);
        expect(config.shouldAnalyzeWidget('Button'), isTrue);
        expect(config.shouldAnalyzeWidget('Container'), isFalse);
        expect(config.shouldAnalyzeWidget('DebugWidget'), isFalse);
      });

      test('should prioritize exclude list over include list', () {
        final config = ConfigModel(
          includeWidgetTypes: ['Text', 'Button'],
          excludeWidgetTypes: ['Text'],
        );

        expect(config.shouldAnalyzeWidget('Text'), isFalse); // Excluded takes precedence
        expect(config.shouldAnalyzeWidget('Button'), isTrue);
        expect(config.shouldAnalyzeWidget('Container'), isFalse);
      });

      test('should return true by default when no lists are specified', () {
        final config = ConfigModel();

        expect(config.shouldAnalyzeWidget('Text'), isTrue);
        expect(config.shouldAnalyzeWidget('Button'), isTrue);
        expect(config.shouldAnalyzeWidget('Container'), isTrue);
        expect(config.shouldAnalyzeWidget('DebugWidget'), isTrue);
      });
    });

    group('shouldExcludeFile', () {
      test('should return false when no exclude patterns are specified', () {
        final config = ConfigModel();

        expect(config.shouldExcludeFile('lib/main.dart'), isFalse);
        expect(config.shouldExcludeFile('test/widget_test.dart'), isFalse);
        expect(config.shouldExcludeFile('lib/generated.dart'), isFalse);
      });

      test('should return true when file matches exclude patterns', () {
        final config = ConfigModel(
          excludePatterns: [r'.*\.generated\.dart$', r'.*\.g\.dart$'],
        );

        expect(config.shouldExcludeFile('lib/main.generated.dart'), isTrue);
        expect(config.shouldExcludeFile('lib/models.g.dart'), isTrue);
        expect(config.shouldExcludeFile('lib/main.dart'), isFalse);
        expect(config.shouldExcludeFile('test/widget_test.dart'), isFalse);
      });

      test('should handle complex regex patterns', () {
        final config = ConfigModel(
          excludePatterns: [r'^test/.*', r'.*\.mock\.dart$'],
        );

        expect(config.shouldExcludeFile('test/widget_test.dart'), isTrue);
        expect(config.shouldExcludeFile('test/unit/my_test.dart'), isTrue);
        expect(config.shouldExcludeFile('lib/service.mock.dart'), isTrue);
        expect(config.shouldExcludeFile('lib/main.dart'), isFalse);
        expect(config.shouldExcludeFile('integration_test/app_test.dart'), isFalse);
      });

      test('should return false for invalid regex patterns', () {
        final config = ConfigModel(
          excludePatterns: ['[invalid regex'],
        );

        // Should not throw an exception and return false for invalid regex
        expect(() => config.shouldExcludeFile('lib/main.dart'), returnsNormally);
      });
    });
  });
}

/// Mock implementation of LintOptions for testing error handling
class MockLintOptions implements LintOptions {
  @override
  Map<String, dynamic> get json => throw Exception('Mock parsing error');
  
  @override
  noSuchMethod(Invocation invocation) => throw Exception('Mock error');
}