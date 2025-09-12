import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:markup_analyzer/model/config_model.dart';
import 'package:markup_analyzer/rules/string_rule.dart';
import 'package:test/test.dart';

void main() {
  group('StringLintRule', () {
    late StringLintRule rule;

    group('with simple string configuration', () {
      setUp(() {
        final config = ConfigModel(simple: DiagnosticSeverity.ERROR);
        rule = StringLintRule(config);
      });

      test('should create rule with correct configuration', () {
        expect(rule.config.simple, equals(DiagnosticSeverity.ERROR));
        expect(rule.config.interpolation, isNull);
        expect(rule.config.binary, isNull);
      });
    });

    group('with interpolation configuration', () {
      setUp(() {
        final config = ConfigModel(interpolation: DiagnosticSeverity.WARNING);
        rule = StringLintRule(config);
      });

      test('should create rule with warning severity for interpolation', () {
        expect(rule.config.interpolation, equals(DiagnosticSeverity.WARNING));
        expect(rule.config.simple, isNull);
      });
    });

    group('with binary expression configuration', () {
      setUp(() {
        final config = ConfigModel(binary: DiagnosticSeverity.ERROR);
        rule = StringLintRule(config);
      });

      test('should create rule with error severity for binary expressions', () {
        expect(rule.config.binary, equals(DiagnosticSeverity.ERROR));
        expect(rule.config.simple, isNull);
      });
    });

    group('with adjacent strings configuration', () {
      setUp(() {
        final config = ConfigModel(adjacent: DiagnosticSeverity.INFO);
        rule = StringLintRule(config);
      });

      test('should create rule with info severity for adjacent strings', () {
        expect(rule.config.adjacent, equals(DiagnosticSeverity.INFO));
        expect(rule.config.simple, isNull);
      });
    });

    group('with method invocation configuration', () {
      setUp(() {
        final config = ConfigModel(method: DiagnosticSeverity.ERROR);
        rule = StringLintRule(config);
      });

      test('should create rule with error severity for method invocations', () {
        expect(rule.config.method, equals(DiagnosticSeverity.ERROR));
        expect(rule.config.simple, isNull);
      });
    });

    group('with simple identifier configuration', () {
      setUp(() {
        final config = ConfigModel(simpleIdentifier: DiagnosticSeverity.WARNING);
        rule = StringLintRule(config);
      });

      test('should create rule with warning severity for simple identifiers', () {
        expect(rule.config.simpleIdentifier, equals(DiagnosticSeverity.WARNING));
        expect(rule.config.simple, isNull);
      });
    });

    group('with prefixed identifier configuration', () {
      setUp(() {
        final config = ConfigModel(prefixedIdentifier: DiagnosticSeverity.ERROR);
        rule = StringLintRule(config);
      });

      test('should create rule with error severity for prefixed identifiers', () {
        expect(rule.config.prefixedIdentifier, equals(DiagnosticSeverity.ERROR));
        expect(rule.config.simple, isNull);
      });
    });

    group('with function expression configuration', () {
      setUp(() {
        final config = ConfigModel(function: DiagnosticSeverity.WARNING);
        rule = StringLintRule(config);
      });

      test('should create rule with warning severity for function expressions', () {
        expect(rule.config.function, equals(DiagnosticSeverity.WARNING));
        expect(rule.config.simple, isNull);
      });
    });

    group('with multiple configurations', () {
      setUp(() {
        final config = ConfigModel(
          simple: DiagnosticSeverity.ERROR,
          interpolation: DiagnosticSeverity.WARNING,
          binary: DiagnosticSeverity.INFO,
          adjacent: DiagnosticSeverity.ERROR,
          method: DiagnosticSeverity.WARNING,
          simpleIdentifier: DiagnosticSeverity.INFO,
          prefixedIdentifier: DiagnosticSeverity.ERROR,
          function: DiagnosticSeverity.WARNING,
        );
        rule = StringLintRule(config);
      });

      test('should create rule with all configurations set correctly', () {
        expect(rule.config.simple, equals(DiagnosticSeverity.ERROR));
        expect(rule.config.interpolation, equals(DiagnosticSeverity.WARNING));
        expect(rule.config.binary, equals(DiagnosticSeverity.INFO));
        expect(rule.config.adjacent, equals(DiagnosticSeverity.ERROR));
        expect(rule.config.method, equals(DiagnosticSeverity.WARNING));
        expect(rule.config.simpleIdentifier, equals(DiagnosticSeverity.INFO));
        expect(rule.config.prefixedIdentifier, equals(DiagnosticSeverity.ERROR));
        expect(rule.config.function, equals(DiagnosticSeverity.WARNING));
      });
    });

    group('with no configuration', () {
      setUp(() {
        final config = ConfigModel();
        rule = StringLintRule(config);
      });

      test('should create rule with all configurations as null', () {
        expect(rule.config.simple, isNull);
        expect(rule.config.interpolation, isNull);
        expect(rule.config.binary, isNull);
        expect(rule.config.adjacent, isNull);
        expect(rule.config.method, isNull);
        expect(rule.config.simpleIdentifier, isNull);
        expect(rule.config.prefixedIdentifier, isNull);
        expect(rule.config.function, isNull);
      });
    });

    group('type checkers', () {
      test('should have correct widget type checker', () {
        // Test that the type checker constants are properly defined
        expect(StringLintRule._widgetChecker.isFromName('Widget'), isTrue);
      });

      test('should have correct string type checker', () {
        expect(StringLintRule._stringChecker.isFromName('String'), isTrue);
      });
    });
  });
}